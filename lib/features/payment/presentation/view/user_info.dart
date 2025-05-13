import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/validator_utils/validator_utils.dart';
import 'package:angelina_app/core/widgets/app_app_bar.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text_field.dart';
import 'package:angelina_app/core/widgets/snack_bar.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/payment/presentation/view/payment_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoPage extends StatefulWidget {
  final int totalPriceCents;
  final List<CartProductModel> reorderedItems;
  final bool shouldClearCart;

  const UserInfoPage({
    required this.totalPriceCents,
    required this.reorderedItems,
    required this.shouldClearCart,
  });

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetNameController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _buildingNumberController = TextEditingController();
  final _apartmentNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCachedUserInfo();
  }

  Future<void> _loadCachedUserInfo() async {
    final data = await CachingUtils.getUserInfo();

    _firstNameController.text = data['first_name']!;
    _lastNameController.text = data['last_name']!;
    _emailController.text = data['email']!;
    _phoneController.text = data['phone']!;
    _addressLineController.text = data['address']!;
    _cityController.text = data['city']!;
    _countryController.text = data['country']!;
    _streetNameController.text = data['street']!;
    _buildingNumberController.text = data['building']!;
    _floorNumberController.text = data['floor']!;
    _apartmentNumberController.text = data['apartment']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                AppAppBar(title: 'معلومات المستخدم'),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: ' الاسم الاول',
                  hasUnderline: true,
                  controller: _firstNameController,
                  validator: ValidatorUtils.name,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'الاسم التاني',
                  hasUnderline: true,
                  controller: _lastNameController,
                  validator: ValidatorUtils.name,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'البريد الالكتروني',
                  hasUnderline: true,
                  controller: _emailController,
                  validator: ValidatorUtils.email,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'رقم الهاتف',
                  hasUnderline: true,
                  controller: _phoneController,
                  validator: ValidatorUtils.phone,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'العنوان',
                  hasUnderline: true,
                  controller: _addressLineController,
                  validator: ValidatorUtils.standered,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      hint: 'المدينه',
                      hasUnderline: true,
                      controller: _cityController,
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                    CustomTextField(
                      hint: 'الدوله',
                      hasUnderline: true,
                      controller: _countryController,
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      hint: 'رقم المبنى',
                      hasUnderline: true,
                      controller: _buildingNumberController,
                      keyboardType: TextInputType.numberWithOptions(),
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                    CustomTextField(
                      hint: 'اسم الشارع',
                      hasUnderline: true,
                      controller: _streetNameController,
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      hint: 'رقم الدور',
                      hasUnderline: true,
                      controller: _floorNumberController,
                      keyboardType: TextInputType.numberWithOptions(),
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                    CustomTextField(
                      hint: 'رقم الشقه',
                      hasUnderline: true,
                      controller: _apartmentNumberController,
                      width: 140.w,
                      height: 45.h,
                      keyboardType: TextInputType.numberWithOptions(),
                      validator: ValidatorUtils.standered,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AppButton(
                  width: double.infinity,
                  btnText: 'متابعة للدفع',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final state = context.read<CartCubit>().state;

                      if (state is CartLoaded) {
                        final cartItems = state.items;

                        final lineItems =
                            widget.reorderedItems
                                .map(
                                  (item) => {
                                    "product_id": item.id,
                                    "quantity": item.quantity,
                                  },
                                )
                                .toList();

                        await CachingUtils.saveUserInfo(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          address: _addressLineController.text,
                          city: _cityController.text,
                          country: _countryController.text,
                          street: _streetNameController.text,
                          building: _buildingNumberController.text,
                          floor: _floorNumberController.text,
                          apartment: _apartmentNumberController.text,
                        );

                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentWebViewPage(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  address1: _addressLineController.text,
                                  city: _cityController.text,
                                  country: _countryController.text,
                                  totalPriceCents: widget.totalPriceCents,
                                  lineItems: lineItems,
                                  reorderedItems: cartItems,
                                  shouldClearCart: widget.shouldClearCart,
                                ),
                          ),
                        );
                      } else {
                        showSnackBar('السلة غير جاهزة بعد');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
