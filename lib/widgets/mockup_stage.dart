import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// Places children in the same coordinate space as a BoxFit.cover mockup image.
class MockupStage extends StatelessWidget {
  const MockupStage({
    super.key,
    required this.asset,
    required this.designSize,
    required this.children,
  });

  final String asset;
  final Size designSize;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = Size(constraints.maxWidth, constraints.maxHeight);
        final scale = math.max(
          screen.width / designSize.width,
          screen.height / designSize.height,
        );
        final painted = Size(designSize.width * scale, designSize.height * scale);
        final origin = Offset(
          (screen.width - painted.width) / 2,
          (screen.height - painted.height) / 2,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.center),
            ),
            ...children.map((child) {
              if (child is MockupRect) {
                return Positioned(
                  left: origin.dx + child.left * scale,
                  top: origin.dy + child.top * scale,
                  width: child.width * scale,
                  height: child.height * scale,
                  child: child.child,
                );
              }
              return child;
            }),
          ],
        );
      },
    );
  }
}

class MockupRect extends StatelessWidget {
  const MockupRect({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.child,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Interactive field sitting on a blank mockup input pill.
class MockupFormField extends StatelessWidget {
  const MockupFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        enableSuggestions: !obscureText,
        autocorrect: !obscureText,
        style: AppFonts.dmSans(
          color: AppColors.navy,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.navy,
        inputFormatters: [LengthLimitingTextInputFormatter(64)],
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: AppFonts.dmSans(
            color: AppColors.textSecondary.withValues(alpha: 0.75),
            fontSize: 13,
          ),
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.navy, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class MockupTap extends StatelessWidget {
  const MockupTap({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
    );
  }
}
