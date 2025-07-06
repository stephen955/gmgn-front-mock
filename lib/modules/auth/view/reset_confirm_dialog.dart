import 'package:flutter/material.dart';

Future showResetConfirmDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('确认重置'),
      content: Text('你确定要重置吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('确定'),
        ),
      ],
    ),
  );
}