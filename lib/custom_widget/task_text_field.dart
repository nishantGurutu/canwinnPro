import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';

class TaskCustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? data;
  final int index;
  final ValueNotifier<int?> focusedIndexNotifier;

  TaskCustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.keyboardType,
    required this.controller,
    required this.textCapitalization,
    this.maxLine,
    this.maxLength,
    this.suffixIcon,
    this.obscureText,
    this.data,
    required this.index,
    required this.focusedIndexNotifier,
  });

  @override
  _TaskCustomTextFieldState createState() => _TaskCustomTextFieldState();
}

class _TaskCustomTextFieldState extends State<TaskCustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.focusedIndexNotifier.value = widget.index;
      } else if (widget.focusedIndexNotifier.value == widget.index) {
        widget.focusedIndexNotifier.value = null;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: widget.focusedIndexNotifier,
      builder: (context, focusedIndex, child) {
        final bool isFocused = focusedIndex == widget.index;

        return TextFormField(
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          textCapitalization: widget.textCapitalization,
          maxLines: widget.obscureText == true ? 1 : widget.maxLine,
          maxLength: widget.maxLength,
          obscureText: widget.obscureText ?? false,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please Enter ${widget.data}";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            suffixIcon: widget.suffixIcon,
            fillColor: isFocused ? Colors.white : lightSecondaryColor,
            filled: true,
            labelStyle: TextStyle(
              color: isFocused ? secondaryColor : darkGreyColor,
            ),
            counterText: "",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: lightSecondaryColor),
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: lightSecondaryColor),
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor),
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          ),
        );
      },
    );
  }
}
