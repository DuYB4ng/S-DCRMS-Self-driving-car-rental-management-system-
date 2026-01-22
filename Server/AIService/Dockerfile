FROM python:3.9-slim-bookworm

WORKDIR /app

# Install system dependencies (required for OpenCV)
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Create directory for YOLO models if not exists
RUN mkdir -p models

# Expose API port
EXPOSE 8002

# Run command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8002"]
