import 'package:flutter/material.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';

class AppDropdownFormField extends FormField<String> {
  AppDropdownFormField({
    super.key,
    required String hint,
    required List<String> items,
    super.onSaved,
    super.validator,
    super.initialValue,
    bool autovalidate = false,
  }) : super(
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDropdownField(
                  hint: hint,
                  value: state.value,
                  items: items,
                  onChanged: (value) {
                    state.didChange(value);
                  },
                  validator: validator,
                  showErrorBorder: state.hasError,
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
