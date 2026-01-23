import os
import cv2
import numpy as np
import base64
import json
import threading
import easyocr
from fastapi import FastAPI, UploadFile, File
from ultralytics import YOLO
import re
import paho.mqtt.client as mqtt

app = FastAPI()

# MQTT Configuration
MQTT_BROKER = os.getenv("MQTT_BROKER", "mosquitto")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
MQTT_TOPIC_INPUT = "car/camera/input"
MQTT_TOPIC_OUTPUT = "car/ai/result"

# Load Model (will download on first run)
print("Loading YOLOv8 model...")
# Using yolov8n.pt (nano) for performance
# using yolov8n.pt (nano) for performance
model = YOLO("yolov8n.pt") 
print("Model loaded.")

# Initialize EasyOCR Reader
print("Loading EasyOCR...")
reader = easyocr.Reader(['en'], gpu=False) # Set gpu=True if CUDA is available
print("EasyOCR loaded.")

# MQTT Client
mqtt_client = mqtt.Client()

def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(MQTT_TOPIC_INPUT)

def on_message(client, userdata, msg):
    try:
        # Expecting JSON: { "carId": 1, "image": "base64_string...", "timestamp": "..." }
        payload_str = msg.payload.decode()
        payload = json.loads(payload_str)
        
        car_id = payload.get("carId")
        img_b64 = payload.get("image")
        
        if img_b64:
            # Decode image
            img_bytes = base64.b64decode(img_b64)
            nparr = np.frombuffer(img_bytes, np.uint8)
            img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

            if img is not None:
                # Inference
                results = model(img)
                
                # Process results
                detections = []
                detected_plate = None

                for r in results:
                    for box in r.boxes:
                        cls = int(box.cls[0])
                        conf = float(box.conf[0])
                        label = model.names[cls]
                        
                        # Only include high confidence
                        if conf > 0.5:
                            detections.append({
                                "label": label,
                                "confidence": round(conf, 2),
                                "box": box.xyxy[0].tolist() 
                            })

                            # Check for vehicle to crop and read plate
                            # Assuming standard YOLO classes: 2=car, 5=bus, 7=truck
                            if cls in [2, 5, 7]:
                                x1, y1, x2, y2 = map(int, box.xyxy[0])
                                # Crop the vehicle from image
                                vehicle_crop = img[y1:y2, x1:x2]
                                if vehicle_crop.size > 0:
                                    # Detect text (license plate)
                                    ocr_results = reader.readtext(vehicle_crop)
                                    for (_, text, ocr_conf) in ocr_results:
                                        if ocr_conf > 0.3: # Threshold
                                            print(f"Detected Text: {text}")
                                            detected_plate = text
                                            break # Just take the first one for now

                # Publish result
                result_payload = {
                    "carId": car_id,
                    "detections": detections,
                    "license_plate": detected_plate,
                    "status": "processed",
                    "damage_detected": False # Placeholder: Logic for damage detection would go here
                }
                client.publish(MQTT_TOPIC_OUTPUT, json.dumps(result_payload))
                print(f"Processed image for Car {car_id}. Plate: {detected_plate}")
            else:
                print("Failed to decode image from base64")

    except Exception as e:
        print(f"Error processing MQTT message: {e}")

mqtt_client.on_connect = on_connect
mqtt_client.on_message = on_message

def start_mqtt():
    try:
        print(f"Connecting to MQTT Broker at {MQTT_BROKER}:{MQTT_PORT}...")
        mqtt_client.connect(MQTT_BROKER, MQTT_PORT, 60)
        mqtt_client.loop_forever()
    except Exception as e:
        print(f"MQTT Connection failed: {e}")

# Start MQTT in background thread
threading.Thread(target=start_mqtt, daemon=True).start()

@app.get("/")
def read_root():
    return {"status": "AIService is running", "model": "YOLOv8n"}

@app.post("/detect")
async def detect(file: UploadFile = File(...)):
    contents = await file.read()
    nparr = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    results = model(img)
    detections = []
    detected_plate = None

    for r in results:
        for box in r.boxes:
            cls = int(box.cls[0])
            conf = float(box.conf[0])
            label = model.names[cls]
            detections.append({
                "label": label,
                "confidence": float(conf)
            })

            # OCR Logic (Same as MQTT)
            if cls in [2, 5, 7] and conf > 0.5:
                x1, y1, x2, y2 = map(int, box.xyxy[0])
                vehicle_crop = img[y1:y2, x1:x2]
                if vehicle_crop.size > 0:
                    ocr_results = reader.readtext(vehicle_crop)
                    for (_, text, ocr_conf) in ocr_results:
                        if ocr_conf > 0.3: 
                            detected_plate = text
                            break
            
    return {"filename": file.filename, "detections": detections, "license_plate": detected_plate}

@app.post("/ocr-license")
async def ocr_license(file: UploadFile = File(...)):
    contents = await file.read()
    nparr = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    if img is None:
        return {"error": "Invalid image"}

    # Run EasyOCR on the whole image
    # detail=0 returns just the list of strings
    raw_texts = reader.readtext(img, detail=0) 
    
    # Join all texts to easier regex search or list search
    full_text = " ".join(raw_texts)
    print(f"OCR Raw Text: {full_text}")

    # Initialize result fields
    license_no = None
    issue_date = None
    expiry_date = None
    
    # 1. Extract License Number (12 digits)
    # Search for patterns like "No: 123456789012" or just 12 digits floating
    license_match = re.search(r'\b\d{12}\b', full_text)
    if license_match:
        license_no = license_match.group(0)
    
    # 2. Extract Dates (dd/mm/yyyy)
    # Usually there are DOB, Issue Date, Expiry Date.
    # Logic: 
    # - Expiry date is usually the last date or near "Có giá trị đến / Expires"
    # - DOB is usually near "Ngày sinh / DOB"
    # - Issue date is usually near bottom right
    
    date_matches = re.findall(r'\b\d{2}/\d{2}/\d{4}\b', full_text)
    
    # Simple heuristic:
    # If 1 date found -> Unknown which one
    # If 2 dates -> Likely DOB and Expiry (or Issue and Expiry)
    # If 3 dates -> DOB, Issue, Expiry (in some order)
    
    # Let's try to be smart based on keywords if possible, but line-by-line is better for keyword context.
    # Re-read with detail=1 to get line positions is better but complex.
    # For now, let's use list index heuristic.
    # Usually: DOB (top), Issue (bottom), Expiry (bottom left corner or similar).
    # In Vietnamese PET card: DOB is near top. Expiry is bottom left ("Có giá trị đến"). Issue Date ("Ngày... tháng... năm") is bottom right.
    
    if len(date_matches) >= 1:
        # Assuming the last date found is likely the Expiry date (common layout)
        expiry_date = date_matches[-1]
        
    if len(date_matches) >= 2:
         # If 3 dates: [0]=DOB, [1]=Issue?, [2]=Expiry
         # If 2 dates: could be DOB, Expiry.
         # Let's just return what we found and let User verify.
         pass
         
    # Refined Search for specific keywords in the raw list
    for i, line in enumerate(raw_texts):
        line_clean = line.lower()
        
        # Check Expiry explicitly
        if "giá trị đến" in line_clean or "until" in line_clean:
             # Look for date in this line or next line
             temp_date = re.search(r'\d{2}/\d{2}/\d{4}', line)
             if temp_date: 
                 expiry_date = temp_date.group(0)
             elif i+1 < len(raw_texts):
                 temp_date_next = re.search(r'\d{2}/\d{2}/\d{4}', raw_texts[i+1])
                 if temp_date_next:
                     expiry_date = temp_date_next.group(0)

    return {
        "license_no": license_no,
        "expiry_date": expiry_date,
        "raw_text": raw_texts
    }
