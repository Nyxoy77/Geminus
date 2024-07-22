import 'package:ai_bot/Services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class AlertServices {
  final GetIt _getIt = GetIt.instance;
  late final NavigationService _navigationService;

  AlertServices() {
    _navigationService = _getIt.get<NavigationService>();
  }

  void showToast({required String text, IconData icon = Icons.info}) {
    try {
      DelightToastBar(
          autoDismiss: true,
          snackbarDuration: const Duration(seconds: 3),
          position: DelightSnackbarPosition.top,
          builder: (context) {
            return ToastCard(
              title: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                icon,
                size: 28,
              ),
            );
          }).show(_navigationService.navigatorKey!.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}
