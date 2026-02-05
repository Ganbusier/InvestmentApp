import 'package:flutter/material.dart';
import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/theme/app_theme.dart';

class AddFundForm extends StatefulWidget {
  final Fund? existingFund;
  final void Function(Fund fund)? onSaved;
  final PortfolioCategory? initialCategory;

  const AddFundForm({
    super.key,
    this.existingFund,
    this.onSaved,
    this.initialCategory,
  });

  @override
  State<AddFundForm> createState() => _AddFundFormState();
}

class _AddFundFormState extends State<AddFundForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _amountController;
  PortfolioCategory _category = PortfolioCategory.stock;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingFund?.name ?? '');
    _codeController = TextEditingController(text: widget.existingFund?.code ?? '');
    _amountController = TextEditingController(
      text: widget.existingFund?.amount.toString() ?? '',
    );
    _category = widget.existingFund?.category ?? widget.initialCategory ?? PortfolioCategory.stock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _nameController,
            label: '基金名称',
            hint: '请输入基金名称',
            icon: Icons.label_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _codeController,
            label: '基金代码',
            hint: '请输入基金代码',
            icon: Icons.qr_code_2,
          ),
          const SizedBox(height: 16),
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _amountController,
            label: '投资金额',
            hint: '请输入投资金额',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            prefixText: '¥ ',
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  final fund = Fund(
                    id: widget.existingFund?.id,
                    name: _nameController.text,
                    code: _codeController.text,
                    amount: double.parse(_amountController.text),
                    category: _category,
                    createdAt: widget.existingFund?.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  if (widget.onSaved != null) {
                    widget.onSaved!(fund);
                  } else {
                    Navigator.of(context).pop(fund);
                  }
                }
              },
              borderRadius: BorderRadius.circular(14),
              splashColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentGold, Color(0xFFE8C560)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.existingFund == null ? '添加基金' : '保存修改',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            prefixText: prefixText,
            prefixStyle: const TextStyle(color: Colors.white, fontSize: 16),
            filled: true,
            fillColor: AppTheme.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2D4A6A), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.accentGold, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入$label';
            }
            if (keyboardType == TextInputType.number) {
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return '请输入有效金额';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '投资类别',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2D4A6A), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PortfolioCategory>(
              value: _category,
              dropdownColor: AppTheme.surface,
              icon: const Icon(Icons.expand_more, color: AppTheme.accentGold),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: PortfolioCategory.values.map((category) {
                final color = AppTheme.getCategoryColor(category);
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(category.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
