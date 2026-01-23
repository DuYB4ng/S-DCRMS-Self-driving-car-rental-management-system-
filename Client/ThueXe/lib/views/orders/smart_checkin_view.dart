import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../services/smart_checkin_service.dart';
import '../../viewmodels/orders_viewmodel.dart';

class SmartCheckInView extends StatefulWidget {
  final String orderId;
  final String expectedLicensePlate;
  final VoidCallback onCheckInSuccess;

  const SmartCheckInView({
    super.key, 
    required this.orderId, 
    required this.expectedLicensePlate,
    required this.onCheckInSuccess,
  });

  @override
  State<SmartCheckInView> createState() => _SmartCheckInViewState();
}

class _SmartCheckInViewState extends State<SmartCheckInView> {
  final SmartCheckInService _service = SmartCheckInService();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;
  String? _resultMessage;
  bool _isMatch = false;

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera, 
      maxWidth: 800, // Resize to avoid crash
      imageQuality: 85,
    );
    
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
        _resultMessage = null;
        _isMatch = false;
      });
      _analyze();
    }
  }

  Future<void> _analyze() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await _service.analyzeImage(_image!);
      
      if (result != null) {
        var detections = result['detections'] as List;
        var licensePlate = result['license_plate'] as String?;
        var carsFound = detections.where((d) => ['car', 'truck', 'bus'].contains(d['label'])).toList();
        
        if (carsFound.isNotEmpty) {
           if (licensePlate != null) {
             // Clean comparison
             String cleanExpected = widget.expectedLicensePlate.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
             String cleanDetected = licensePlate.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
             
             if (cleanDetected.contains(cleanExpected) || cleanExpected.contains(cleanDetected)) {
               setState(() {
                 _isMatch = true;
                 _resultMessage = "✅ Xác thực thành công!\nBiển số: $licensePlate";
               });
             } else {
               setState(() {
                 _isMatch = false; // Set true for simulated demo if needed
                 _resultMessage = "❌ Biển số không khớp.\nTìm thấy: $licensePlate\nCần: ${widget.expectedLicensePlate}";
               });
             }
           } else {
             // Fallback logic
             setState(() {
               _isMatch = true;
               _resultMessage = "✅ Đã nhận diện xe. (Demo Mode: Auto-Pass)";
             });
           }
        } else {
           setState(() {
             _isMatch = false;
             _resultMessage = "⚠️ Không tìm thấy xe trong ảnh.";
           });
        }
      } else {
        setState(() => _resultMessage = "Lỗi kết nối AI Service.");
      }
    } catch (e) {
      setState(() => _resultMessage = "Lỗi: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processCheckIn() async {
    setState(() => _isLoading = true);
    try {
      final ordersVM = Provider.of<OrdersViewModel>(context, listen: false);
      await ordersVM.checkIn(int.parse(widget.orderId));
      
      if (mounted) {
        widget.onCheckInSuccess(); 
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi Check-in: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Check-in")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("Đơn hàng: ${widget.orderId}", style: const TextStyle(fontSize: 16)),
            Text("Biển số xe cần tìm: ${widget.expectedLicensePlate}", 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            
            const SizedBox(height: 20),
            
            if (_image != null)
              Image.file(_image!, height: 300, fit: BoxFit.cover)
            else
              Container(
                height: 300,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.camera_alt, size: 64, color: Colors.grey)),
              ),
              
            const SizedBox(height: 20),
            
            if (_isLoading)
               const CircularProgressIndicator()
            else if (_resultMessage != null)
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: _isMatch ? Colors.green[50] : Colors.red[50], 
                   borderRadius: BorderRadius.circular(8)
                 ),
                 child: Text(_resultMessage!, 
                    style: TextStyle(color: _isMatch ? Colors.green[800] : Colors.red[800], fontSize: 16),
                    textAlign: TextAlign.center,
                 ),
               ),
               
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _takePicture,
                  icon: const Icon(Icons.camera),
                  label: const Text("Chụp ảnh lại"),
                ),
                
                ElevatedButton(
                  onPressed: _isMatch && !_isLoading ? _processCheckIn : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Xác nhận Check-in"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
