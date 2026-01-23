import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../viewmodels/profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _nameController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  
  final _dateFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    _nameController.text = vm.name ?? "";
    _licenseNoController.text = vm.licenseNo ?? "";
    _issueDateController.text = vm.licenseIssueDate ?? "";
    _expiryDateController.text = vm.licenseExpiryDate ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseNoController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }
  
  Future<void> _pickAvatar() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 800);
    if (photo != null && mounted) {
       Provider.of<ProfileViewModel>(context, listen: false).uploadAvatar(File(photo.path));
    }
  }

  Future<void> _scanLicense() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1000, imageQuality: 90);
    
    if (photo != null && mounted) {
      final vm = Provider.of<ProfileViewModel>(context, listen: false);
      
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đang quét thông tin GPLX...")));
      
      final result = await vm.scanLicense(File(photo.path));
      
      if (result != null) {
        setState(() {
          if (result['licenseNo']!.isNotEmpty) _licenseNoController.text = result['licenseNo']!;
          if (result['expiryDate']!.isNotEmpty) _expiryDateController.text = result['expiryDate']!;
          // AI might miss issue date or DOB confusion, user fills manually if missing
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã điền thông tin từ ảnh!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không đọc được thông tin GPLX.")));
      }
    }
  }

  Future<void> _save() async {
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    
    await vm.updateAllInfo(
      newName: _nameController.text.trim(),
      newLicenseNo: _licenseNoController.text.trim(),
      newIssueDate: _issueDateController.text.trim(),
      newExpiryDate: _expiryDateController.text.trim(),
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cập nhật hồ sơ thành công!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa hồ sơ")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AVATAR SECTION
            Center(
              child: Stack(
                children: [
                   CircleAvatar(
                     radius: 50,
                     backgroundColor: Colors.grey[300],
                     backgroundImage: (vm.photoUrl != null && vm.photoUrl!.isNotEmpty) 
                        ? NetworkImage(vm.photoUrl!) 
                        : null,
                     child: (vm.photoUrl == null || vm.photoUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                   ),
                   Positioned(
                     bottom: 0,
                     right: 0,
                     child: GestureDetector(
                       onTap: _pickAvatar,
                       child: Container(
                         padding: const EdgeInsets.all(6),
                         decoration: const BoxDecoration(
                           color: Colors.blue,
                           shape: BoxShape.circle,
                         ),
                         child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                       ),
                     ),
                   )
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // USER INFO SECTION
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              enabled: false, 
              controller: TextEditingController(text: vm.phone ?? vm.email), 
              decoration: const InputDecoration(
                labelText: "Email / Số điện thoại",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                fillColor: Colors.black12,
                filled: true,
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 8),

            // LICENSE SECTION
            const Text(
              "Giấy phép lái xe (GPLX)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!)
              ),
              child: Column(
                children: [
                  const Text("Chụp ảnh mặt trước GPLX để tự động điền"),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _scanLicense,
                    icon: const Icon(Icons.camera_enhance),
                    label: const Text("Quét ảnh GPLX"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _licenseNoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số GPLX",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
                hintText: "12 chữ số"
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _issueDateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_dateFormatter],
                    decoration: const InputDecoration(
                      labelText: "Ngày cấp",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: "dd/mm/yyyy"
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_dateFormatter],
                    decoration: const InputDecoration(
                      labelText: "Ngày hết hạn",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                      hintText: "dd/mm/yyyy"
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: vm.isLoading 
                   ? const CircularProgressIndicator(color: Colors.white)
                   : const Text("Lưu thay đổi", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
