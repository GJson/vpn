import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final EdgeInsets contentPadding;
  final bool enabled;
  final FocusNode? focusNode;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelText,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            autofocus: widget.autofocus,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            style: AppTextStyles.bodyMedium,
            focusNode: _focusNode,
            showCursor: true,
            cursorWidth: 2.0,
            cursorRadius: const Radius.circular(1),
            cursorColor: AppColors.primaryColor,
            enableInteractiveSelection: true,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            toolbarOptions: const ToolbarOptions(
              copy: true,
              cut: true,
              paste: true,
              selectAll: true,
            ),
            selectionControls: MaterialTextSelectionControls(),
            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              );
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLightColor,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon,
              contentPadding: widget.contentPadding,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.textLightColor.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.errorColor,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.errorColor,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.textLightColor.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 