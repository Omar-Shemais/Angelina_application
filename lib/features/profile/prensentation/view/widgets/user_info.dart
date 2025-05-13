import 'dart:io';
import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final path = await CachingUtils.getSavedImagePath();
    setState(() {
      _imagePath = path;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);
      await CachingUtils.saveImageToLocalStorage(file);
      setState(() {
        _imagePath = file.path;
      });
    }
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final firstName = await CachingUtils.getUserFirstName();
    final secondName = await CachingUtils.getUserSecondName();
    final email = await CachingUtils.getUserEmail();
    return {'firstName': firstName, 'secondName': secondName, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Text("تعذر تحميل بيانات المستخدم");
        } else {
          final firstName = snapshot.data!['firstName'] ?? '';
          final secondName = snapshot.data!['secondName'] ?? '';
          final email = snapshot.data!['email'] ?? '';

          return Row(
            children: [
              GestureDetector(
                onTap: () => _showImageSourceDialog(context),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _imagePath != null
                          ? FileImage(File(_imagePath!))
                          : const AssetImage(
                                'assets/images/user_placeholder.jpg',
                              )
                              as ImageProvider,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        title: firstName,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 5.w),
                      AppText(
                        title: secondName,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  AppText(
                    title: email,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor,
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder:
          (_) => Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(title: 'Profile photo', fontSize: 24),
                        IconButton(
                          onPressed: () => RouteUtils.pop(),
                          icon: Icon(
                            Icons.delete,
                            color: AppColors.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                RouteUtils.pop();
                                _pickImage(ImageSource.camera);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 30.r,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            AppText(
                              title: "استخدم الكاميرا",
                              fontSize: 15,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                radius: 30.r,
                                child: Icon(
                                  Icons.photo,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            AppText(
                              title: "اختر من المعرض",
                              fontSize: 15,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    AppButton(
                      btnText: 'الغاء',
                      textColor: AppColors.primaryColor,
                      btnColor: AppColors.white,
                      width: double.infinity,
                      onTap: () => RouteUtils.pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
