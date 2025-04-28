import 'dart:math';

import 'package:dio/dio.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http_parser/http_parser.dart';

void navigate({
  required BuildContext context,
  required String route,
  Object? arguments,
  Function(dynamic value)? onNavigateComplete,
}) {
  Navigator.pushNamed(
    context,
    route,
    arguments: arguments,
  ).then((value) {
    if (onNavigateComplete != null) {
      onNavigateComplete(value);
    }
  });
}

void navigateReplacement({
  required BuildContext context,
  required String route,
}) {
  Navigator.pushReplacementNamed(context, route);
}

void navigatepushNamedAndRemoveUntil(
    {required BuildContext context, required String route}) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    route,
    (Route<dynamic> route) => false,
  );
}

void navigatePop({required BuildContext context}) {
  Navigator.pop(context);
}

Future navBarNavigate({
  required BuildContext context,
  required Widget screen,
  bool? withNavBar,
  Object? arguments,
  Function(dynamic value)? onNavigateComplete,
}) async {
  return PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: screen,
    withNavBar: withNavBar ?? false,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  ).then(
    (value) {
      if (onNavigateComplete != null) {
        onNavigateComplete(value);
      }
    },
  );
}

Future launchCustomUrl(context, String? url) async {
  if (url != null) {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }
}

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message, {
    IconData? icon,
    ToastStates state = ToastStates.success,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: const ValueKey("dismiss_snackbar"),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              overlayEntry.remove(); // Now overlayEntry is correctly referenced
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: getState(context, state),
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, color: Colors.white, size: 26),
                  Expanded(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.roboto500sized16White.copyWith(
                        color: Colors.white,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Automatically remove after 3 seconds if not swiped
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      },
    );
  }
}

void showTwist({
  required BuildContext context,
  required String messege,
  ToastStates? state,
  IconData? icon,
}) {
  CustomSnackbar.show(
    context,
    messege,
    state: state ?? ToastStates.success,
    icon: icon,
  );
}

enum ToastStates {
  error,
  success,
  warning,
}

Color getState(BuildContext context, ToastStates state) {
  switch (state) {
    case ToastStates.error:
      return Colors.red;
    case ToastStates.success:
      return AppColors.primary;
    case ToastStates.warning:
      return Colors.orange;
  }
}

String? displayDate(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

String? displayDateAndTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  return DateFormat('yyyy-MM-dd - hh:mm a').format(dateTime);
}

String? formatTimeOfDay(TimeOfDay? timeOfDay) {
  if (timeOfDay != null) {
    final hours = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return "$hours:$minutes $period";
  }
  return null;
}

getHourFromTimeOfDay(TimeOfDay time) {
  return time.hourOfPeriod;
}

getMinuteFromTimeOfDay(TimeOfDay time) {
  return time.minute;
}

getPeriodFromTimeOfDay(TimeOfDay time) {
  return time.period == DayPeriod.am ? 'AM' : 'PM';
}

String generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(
      length, (index) => characters[random.nextInt(characters.length)]).join();
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd MMM').format(dateTime);
}

String convertTime(DateTime? date) {
  if (date == null) {
    return '--:--';
  }
  return DateFormat('hh:mm a').format(date);
}

String? formatTime(String? dateTimeString) {
  if (dateTimeString == null) return null;
  try {
    DateTime dateTime =
        DateFormat('dd MMM yyyy, hh:mm a').parse(dateTimeString);
    return DateFormat('hh:mma').format(dateTime);
  } catch (e) {
    return null;
  }
}

Future<MultipartFile> uploadImageToAPI(XFile image) async {
  // Get the mime type of the file
  String? mimeType = lookupMimeType(image.path);

  return MultipartFile.fromFile(
    image.path,
    filename: image.path.split('/').last,
    contentType: MediaType.parse(
        mimeType ?? 'image/jpeg'), // defaulting to image/jpeg if not found
  );
}
