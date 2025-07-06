import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    required this.icon, 
    required this.label, 
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: const BorderSide(color: Color(0xFFE6E6E6), width: 0.5),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
