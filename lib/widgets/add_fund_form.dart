import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/utils/constants.dart';

class AddFundForm extends StatefulWidget {
  final Fund? existingFund;
  final VoidCallback? onSaved;

  const AddFundForm({
    super.key,
    this.existingFund,
    this.onSaved,
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
    _category = widget.existingFund?.category ?? PortfolioCategory.stock;
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
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '基金名称',
              hintText: '请输入基金名称',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入基金名称';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: '基金代码',
              hintText: '请输入基金代码',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入基金代码';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<PortfolioCategory>(
            value: _category,
            decoration: const InputDecoration(
              labelText: '投资类别',
            ),
            items: PortfolioCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _category = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: '投资金额',
              hintText: '请输入投资金额',
              prefixText: '¥ ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入投资金额';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return '请输入有效金额';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
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
                  Navigator.of(context).pop(fund);
                }
              },
              child: Text(widget.existingFund == null ? '添加基金' : '保存修改'),
            ),
          ),
        ],
      ),
    );
  }
}
