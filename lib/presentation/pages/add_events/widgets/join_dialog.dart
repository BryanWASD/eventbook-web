import 'package:flutter/material.dart';

class SuccessfulJoinDialog {
  Future<void> show({
    required BuildContext context,
    String? title,
    Duration? duration,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);

        return AlertDialog(
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check,
                  size: 100,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    title ?? 'Te has unido',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    await Future.delayed(duration ?? const Duration(seconds: 2))
        .then((value) => close(context));
  }

  void close(BuildContext context) => Navigator.pop(context);
}
