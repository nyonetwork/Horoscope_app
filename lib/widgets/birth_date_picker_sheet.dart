import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showBirthDatePickerSheet(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
}) async {
  final now = DateTime.now();
  DateTime temp = initialDate;
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: const Color(0xFF0D1020),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SizedBox(
        height: 320,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const Text(
                    'Select birth date',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(temp),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF2C3862)),
            Expanded(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.dark),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: minimumDate ?? DateTime(1950, 1, 1),
                    maximumDate: maximumDate ?? now,
                    onDateTimeChanged: (value) => temp = value,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
