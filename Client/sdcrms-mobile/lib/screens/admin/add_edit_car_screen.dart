import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../models/car.dart';

class AddEditCarScreen extends StatefulWidget {
  final Car? car;

  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _seatsController = TextEditingController();
  final _colorController = TextEditingController();

  String _selectedType = 'Sedan';
  String _selectedTransmission = 'Số tự động';
  String _selectedFuelType = 'Xăng';
  String _selectedStatus = 'Sẵn sàng';
  String? _imagePath;

  final List<String> _carTypes = [
    'Sedan',
    'SUV',
    'Hatchback',
    'MPV',
    'Coupe',
    'Crossover',
  ];
  final List<String> _transmissions = ['Số tự động', 'Số sàn'];
  final List<String> _fuelTypes = ['Xăng', 'Dầu', 'Điện', 'Hybrid'];
  final List<String> _statuses = ['Sẵn sàng', 'Đang thuê', 'Bảo trì'];

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _loadCarData();
    }
  }

  void _loadCarData() {
    final car = widget.car!;
    _nameController.text = car.name;
    _brandController.text = car.brand;
    _modelController.text = car.model;
    _licensePlateController.text = car.licensePlate;
    _yearController.text = car.year.toString();
    _priceController.text = car.pricePerDay.toString();
    _seatsController.text = car.seats.toString();
    _colorController.text = car.color;
    _selectedType = car.type;
    _selectedTransmission = car.transmission;
    _selectedFuelType = car.fuelType;
    _selectedStatus = car.status;
    _imagePath = car.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _licensePlateController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.car != null;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Chỉnh sửa xe' : 'Thêm xe mới',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveCar,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              'Lưu',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh
              _buildImageSection(),
              const SizedBox(height: 24),

              // Thông tin cơ bản
              _buildSectionTitle('Thông tin cơ bản'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Tên xe',
                hint: 'VD: Toyota Camry 2024',
                icon: Icons.directions_car,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên xe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _brandController,
                      label: 'Hãng xe',
                      hint: 'VD: Toyota',
                      icon: Icons.business,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập hãng xe';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _modelController,
                      label: 'Model',
                      hint: 'VD: Camry',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập model';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Loại xe',
                value: _selectedType,
                items: _carTypes,
                icon: Icons.category,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Thông tin đăng ký
              _buildSectionTitle('Thông tin đăng ký'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _licensePlateController,
                label: 'Biển số xe',
                hint: 'VD: 30A-12345',
                icon: Icons.confirmation_number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập biển số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _yearController,
                      label: 'Năm sản xuất',
                      hint: 'VD: 2024',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập năm';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _colorController,
                      label: 'Màu sắc',
                      hint: 'VD: Trắng',
                      icon: Icons.color_lens,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập màu';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Thông số kỹ thuật
              _buildSectionTitle('Thông số kỹ thuật'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Hộp số',
                      value: _selectedTransmission,
                      items: _transmissions,
                      icon: Icons.settings,
                      onChanged: (value) {
                        setState(() {
                          _selectedTransmission = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _seatsController,
                      label: 'Số chỗ',
                      hint: 'VD: 5',
                      icon: Icons.airline_seat_recline_normal,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập số chỗ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Nhiên liệu',
                value: _selectedFuelType,
                items: _fuelTypes,
                icon: Icons.local_gas_station,
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Giá và trạng thái
              _buildSectionTitle('Giá & Trạng thái'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _priceController,
                label: 'Giá thuê (VNĐ/ngày)',
                hint: 'VD: 800000',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá thuê';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Trạng thái',
                value: _selectedStatus,
                items: _statuses,
                icon: Icons.info,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Hình ảnh xe'),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _imagePath != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          _imagePath!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Không thể tải ảnh',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _imagePath = null;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nhấn để thêm hình ảnh',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _pickImage() async {
    try {
      // Danh sách ảnh có sẵn trong thư mục image
      final availableImages = [
        'image/toyota-vios-2020.png',
        'image/mazda-3-2018-7.png',
        'image/vinfastvf6-4.png',
        'image/1-1.png',
        'image/Xanh-Noc-trang-min.png',
      ];

      final ImagePicker picker = ImagePicker();

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library, color: primaryColor),
                  title: const Text('Chọn từ ảnh có sẵn'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAvailableImages(availableImages);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: primaryColor),
                  title: const Text('Chụp ảnh'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      setState(() {
                        _imagePath = image.path;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image, color: primaryColor),
                  title: const Text('Chọn từ thư viện'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      setState(() {
                        _imagePath = image.path;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi chọn ảnh: $e')));
    }
  }

  void _showAvailableImages(List<String> images) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Chọn ảnh xe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final imagePath = images[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _imagePath = imagePath;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _imagePath == imagePath
                                  ? primaryColor
                                  : Colors.grey[300]!,
                              width: _imagePath == imagePath ? 3 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveCar() {
    if (_formKey.currentState!.validate()) {
      final car = Car(
        id: widget.car?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        brand: _brandController.text,
        model: _modelController.text,
        type: _selectedType,
        licensePlate: _licensePlateController.text,
        year: int.parse(_yearController.text),
        pricePerDay: double.parse(_priceController.text),
        transmission: _selectedTransmission,
        seats: int.parse(_seatsController.text),
        fuelType: _selectedFuelType,
        color: _colorController.text,
        imagePath: _imagePath,
        status: _selectedStatus,
        rating: widget.car?.rating ?? 0.0,
        totalTrips: widget.car?.totalTrips ?? 0,
      );

      Navigator.pop(context, car);
    }
  }
}
