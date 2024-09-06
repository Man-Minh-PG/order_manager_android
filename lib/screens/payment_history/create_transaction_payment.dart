import 'package:flutter/material.dart';
import 'package:grocery_app/provider/app_common_service.dart';

class CreateTransactionPayment extends StatefulWidget {
  @override
  _CreateTransactionPaymentState createState() =>
      _CreateTransactionPaymentState();
}

class _CreateTransactionPaymentState extends State<CreateTransactionPayment> {
  final AppCommonService commonService = AppCommonService();

  TextEditingController _inputMoneyValue = TextEditingController();
  TextEditingController _inputOptionNote = TextEditingController();

  List<String> _optionTypeLabel = ['Chi', 'Thu'];
  final List<String> _optionNoteLabel = ['Mua đá', 'Đổi tiền', 'A Hậu', 'Khác'];
  String _finalNoteInsert = '';

  String? _optionType = "Chi";
  String? _optionNote = "Mua đá";

  bool _showTextFieldNote = false;

  List<Map<String, dynamic>> dataInitialCost = [];
  final double _defaultPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Transaction Payment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromARGB(255, 134, 72, 241),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nhập số tiền
              _buildInputField(
                title: "Nhập số tiền",
                child: TextField(
                  controller: _inputMoneyValue,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration("vnd"),
                ),
              ),
              // Loại giao dịch
              _buildInputField(
                title: "Loại giao dịch",
                child: Wrap(
                  spacing: 8.0,
                  children: _optionTypeLabel.map((String option) {
                    return ChoiceChip(
                      label: Text(option),
                      selected: _optionType == option,
                      onSelected: (bool selected) {
                        setState(() {
                          _optionType = selected ? option : null;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              // Ghi chú
              _buildInputField(
                title: "Ghi chú",
                child: Wrap(
                  spacing: 8.0,
                  children: _optionNoteLabel.map((String option) {
                    return ChoiceChip(
                      label: Text(option),
                      selected: _optionNote == option,
                      onSelected: (bool selected) {
                        setState(() {
                          _optionNote = selected ? option : null;
                          _showTextFieldNote = option == 'Khác';
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              // TextField for custom note
              if (_showTextFieldNote)
                _buildInputField(
                  title: "Nội dung khác",
                  child: TextField(
                    controller: _inputOptionNote,
                    decoration: _buildInputDecoration("Nhập nội dung"),
                  ),
                ),
              // Button Save
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_optionNote != null) {
                      if (_optionNote == 'Khác') {
                        _finalNoteInsert = _inputOptionNote.text;
                      } else {
                        _finalNoteInsert = _optionNote!;
                      }
                    }

                    _handelTransactionPayment();
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String title, required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2.0,
        ),
      ),
    );
  }

  Widget _generateDialog(context) {
    return AlertDialog(
      title: Text("Insert Fail"),
      icon: Icon(Icons.error),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Future<void> _handelTransactionPayment() async {
    // Handle data processing
    Map<String, dynamic> dataInsert = {
      'value_payment': _inputMoneyValue.text,
      'type': _optionType,
      'note': _finalNoteInsert,
    };

    int insertResult =
        await commonService.insertData("transaction_history", dataInsert);

    if (insertResult < 0) {
      showDialog(context: context, builder: (context) => _generateDialog(context));
    }

    // Prepare update cost
    Map<String, dynamic> conditionGetCost = {'name': 'initialCost'};

    dataInitialCost =
        await commonService.getDataWithCondition("generic", conditions: conditionGetCost);

    if (_optionType == "Chi") {
      dataInitialCost[0]['value'] -= int.tryParse(_inputMoneyValue.text) ?? 0;
    } else {
      dataInitialCost[0]['value'] += int.tryParse(_inputMoneyValue.text) ?? 0;
    }

    Map<String, dynamic> updateCost = {"value": dataInitialCost[0]['value']};
    Map<String, dynamic> conditionUpdateCost = {"name": 'initialCost'};

    int resultUpdate = await commonService.updateData("generic", updateCost, conditions: conditionUpdateCost);

    if (resultUpdate < 0) {
      showDialog(context: context, builder: (context) => _generateDialog(context));
    }
  }
}
