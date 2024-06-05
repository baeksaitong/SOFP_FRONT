import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'appColors.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isDelayed = false;

  bool get isLoading => _isLoading;

  void showLoading({bool delayed = false}) {
    if (delayed) {
      _isDelayed = true;
      Future.delayed(Duration(seconds: 1), () {
        if (_isDelayed) {
          _isLoading = true;
          notifyListeners();
        }
      });
    } else {
      _isLoading = true;
      notifyListeners();
    }
  }

  void hideLoading() {
    _isLoading = false;
    _isDelayed = false;
    notifyListeners();
  }
}

// class LoadingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoadingProvider>(
//       builder: (context, loadingProvider, child) {
//         if (!loadingProvider.isLoading) return SizedBox.shrink();
//
//         return Container(
//           color: AppColors.wh,
//           child: Center(
//             child: Lottie.asset(
//               'assets/loading.json', // Ensure this file is placed in the assets folder
//               width: 100,
//               height: 100,
//               fit: BoxFit.fill,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// Widget loadingOverlay(BuildContext context) {
//   return LoadingScreen();
// }
