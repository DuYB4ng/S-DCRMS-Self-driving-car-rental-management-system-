import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../services/smart_checkin_service.dart';
import '../../viewmodels/orders_viewmodel.dart';

class SmartCheckOutView extends StatefulWidget {
  final String orderId;
  final String expectedLicensePlate;
  final VoidCallback onCheckOutSuccess;

  const SmartCheckOutView({
    super.key, 
    required this.orderId, 
    required this.expectedLicensePlate,
    required this.onCheckOutSuccess,
  });

  @override
  State<SmartCheckOutView> createState() => _SmartCheckOutViewState();
}

class _SmartCheckOutViewState extends State<SmartCheckOutView> {
  final SmartCheckInService _service = SmartCheckInService();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;
  String? _resultMessage;
  bool _isMatch = false;

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera, 
      maxWidth: 800, // Resize to avoid AI crash
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

    setState(() {
      _isLoading = true;
      _resultMessage = "Đang kiểm tra xe...";
    });

    try {
      final result = await _service.analyzeImage(_image!);
      
      if (result != null) {
        var detections = result['detections'] as List;
        var licensePlate = result['license_plate'] as String?;
        var carsFound = detections.where((d) => ['car', 'truck', 'bus'].contains(d['label'])).toList();
        
        if (carsFound.isNotEmpty) {
           if (licensePlate != null) {
             // Clean up plates for comparison (remove dot, dash, space)
             String cleanExpected = widget.expectedLicensePlate.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
             String cleanDetected = licensePlate.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
             
             if (cleanDetected.contains(cleanExpected) || cleanExpected.contains(cleanDetected)) {
               setState(() {
                 _isMatch = true;
                 _resultMessage = "✅ Xác thực thành công!\nBiển số: $licensePlate";
               });
             } else {
               setState(() {
                 _isMatch = false;
                 _resultMessage = "❌ Biển số không khớp.\nTìm thấy: $licensePlate\nCần: ${widget.expectedLicensePlate}";
               });
             }
           } else {
             // Fallback if OCR fails but Car is detected (Simulated for demo)
             // In real production, we might enforce OCR or ask user to retake.
             // For strict mode:
             /*
             setState(() {
               _isMatch = false;
               _resultMessage = "⚠️ Nhận diện xe thành công nhưng không đọc được biển số. Vui lòng chụp rõ biển số.";
             });
             */
             // For Demo Mode (Easier):
             setState(() {
               _isMatch = true;
               _resultMessage = "✅ Đã nhận diện xe. (Chế độ Demo: Bỏ qua kiểm tra biển số chi tiết)";
             });
           }
        } else {
           setState(() {
             _isMatch = false;
             _resultMessage = "⚠️ Không tìm thấy xe ô tô trong ảnh.";
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

  Future<void> _processCheckOut() async {
    setState(() => _isLoading = true);
    try {
      final ordersVM = Provider.of<OrdersViewModel>(context, listen: false);
      await ordersVM.requestCheckOut(int.parse(widget.orderId));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã gửi yêu cầu trả xe thành công!")));
        widget.onCheckOutSuccess();
        Navigator.pop(context); // Close SmartCheckOutView
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi gửi yêu cầu: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Check-out (Trả xe)")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Đơn hàng: #${widget.orderId}", style: const TextStyle(fontSize: 16)),
              Text("Xe cần trả: ${widget.expectedLicensePlate}", 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
              
              const SizedBox(height: 10),
              const Text("Vui lòng chụp ảnh xe và biển số để xác nhận trả xe.", textAlign: TextAlign.center),
              
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_image!, fit: BoxFit.cover))
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                            Text("Chạm để chụp ảnh"),
                          ],
                        ),
                ),
              ),
                
              const SizedBox(height: 20),
              
              if (_isLoading)
                 const CircularProgressIndicator()
              else if (_resultMessage != null)
                 Container(
                   padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(
                     color: _isMatch ? Colors.green[50] : Colors.red[50],
                     borderRadius: BorderRadius.circular(8),
                     border: Border.all(color: _isMatch ? Colors.green : Colors.red),
                   ),
                   child: Text(_resultMessage!, 
                      style: TextStyle(color: _isMatch ? Colors.green[800] : Colors.red[800], fontSize: 16),
                      textAlign: TextAlign.center,
                   ),
                 ),
                 
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isMatch && !_isLoading ? _processCheckOut : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    disabledBackgroundColor: Colors.grey[300],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("XÁC NHẬN TRẢ XE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
