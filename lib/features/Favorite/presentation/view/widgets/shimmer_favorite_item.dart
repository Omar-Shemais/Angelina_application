// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ShimmerFavoriteItem extends StatelessWidget {
//   const ShimmerFavoriteItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           height: 140.h,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             textDirection: TextDirection.rtl,
//             children: [
//               // Image placeholder with heart icon
//               Stack(
//                 children: [
//                   Container(
//                     height: double.infinity,
//                     width: 150.w,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.horizontal(
//                         right: Radius.circular(15.r),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 5.h,
//                     right: 5.w,
//                     child: Container(
//                       height: 30.r,
//                       width: 30.r,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // Text and price placeholders
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 20.h,
//                     horizontal: 10.w,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Product name placeholder
//                       Container(
//                         height: 14.h,
//                         width: double.infinity,
//                         color: Colors.grey[300],
//                       ),
//                       SizedBox(height: 8.h),
//                       Container(
//                         height: 14.h,
//                         width: 80.w,
//                         color: Colors.grey[300],
//                       ),
//                       SizedBox(height: 18.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Cart icon placeholder
//                           Container(
//                             height: 26.r,
//                             width: 26.r,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           // Price placeholder
//                           Container(
//                             height: 12.h,
//                             width: 60.w,
//                             color: Colors.grey[300],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
