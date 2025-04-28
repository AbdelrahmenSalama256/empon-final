import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:embone/core/locale/app_loacl.dart';

void showColorPickerDialog(
  BuildContext context, {
  required Color initialColor,
  required ValueChanged<Color> onColorChanged,
  required VoidCallback onSavePressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('custom_color_picker'.tr(context)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: onColorChanged,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            colorPickerWidth: 300,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('cancel'.tr(context)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            onPressed: () {
              onSavePressed();
              Navigator.of(context).pop();
            },
            child: Text('save'.tr(context)),
          ),
        ],
      );
    },
  );
}
