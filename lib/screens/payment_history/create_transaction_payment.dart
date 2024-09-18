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
  final List<String> _subOptionTypeLabel = ['Momo', 'Bank'];
  String _finalNoteInsert = '';

  String? _optionType = "Chi";
  String? _optionNote = "Mua đá";
  String? _subOptionType = "Momo";

  bool _showTextFieldNote = false;

  List<Map<String, dynamic>> dataInitialCost = [];
  final double _defaultPadding = 10.0;

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      resizeToAvoidBottomInset: true, // Prevent shrinking when keyboard appears
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
      body: SingleChildScrollView( // Wrap content to avoid overflow
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
            SizedBox(height: 16), // Add space between fields

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

            SizedBox(height: 16), // Add space between fields

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
            SizedBox(height: 16), // Add space between fields

            // Show option if _optionNote == "Đổi tiền" -- after release - clean code
            if(_optionNote == "Đổi tiền")
            _buildInputField(
              title: "Loại giao dịch",
              child: Wrap(
                spacing: 8.0,
                children: _subOptionTypeLabel.map((String option) {
                  return ChoiceChip(
                    label: Text(option),
                    selected: _subOptionType == option,
                    onSelected: (bool selected) {
                      setState(() {
                        _optionType = selected ? option : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),       

            // Show TextField for custom note if 'Khác' is selected
            if (_showTextFieldNote)
              _buildInputField(
                title: "Nội dung khác",
                child: TextField(
                  controller: _inputOptionNote,
                  decoration: _buildInputDecoration("Nhập nội dung"),
                ),
              ),

            SizedBox(height: 16), // Add space before the button

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

                  _handelTransactionPayment(_inputMoneyValue, _optionType.toString());
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

  /*
   * Custom UI dialog
   * Common generate popup 
   * temp  - after release - move funtion to class common_ui
   * 
   */
  Widget _generateDialog(context, String message, {int? type}) {
    return AlertDialog(
      title: Text(message),
      icon: Icon(
        type == 1 ? Icons.notifications : Icons.error,
        color: type == 1 ? Colors.green : Colors.red      
      ),
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

  /**
   * Write function caculator rồi từ funtion xử lý này gọi vô
   */
  Future<void> _handelTransactionPayment(TextEditingController _inputMoneyValue, String optionType) async {
    int tempDataInitialCost = 0;
    int tempValueMoney = _convertInputToInt(_inputMoneyValue);
   
   if ( optionType == '' || (_inputMoneyValue.text).isEmpty) {
      showDialog(context: context, builder: (context) => _generateDialog(context, "Chưa nhập dữ lệu bạn êy , Error đó !!"));
      return;
    }

    // Handle data processing
    Map<String, dynamic> dataInsert = {
      'value_payment': _inputMoneyValue.text,
      'type': (optionType == 'Chi') ? 0 : 1 ,
      'note': _finalNoteInsert,
    };

    int insertResult =
        await commonService.insertData("transaction_history", dataInsert);

    if (insertResult < 0) {
      showDialog(context: context, builder: (context) => _generateDialog(context, "Insert fail"));
      return;
    }

    // Prepare update cost
    Map<String, dynamic> conditionGetCost = {'name': 'initialCost'};

    dataInitialCost =
        await commonService.getDataWithCondition("generic", conditions: conditionGetCost);

    // if get fail close form
    if(dataInitialCost.isEmpty){
       showDialog(context: context, builder: (context) => _generateDialog(context, "Get data fail"));
       Navigator.pop(context);
    }

    // convert data
    tempDataInitialCost = int.parse(dataInitialCost[0]['value']);

    if (optionType == "Chi") {
      tempDataInitialCost =  tempDataInitialCost - tempValueMoney;
    } else {
      tempDataInitialCost += int.tryParse(_inputMoneyValue.text) ?? 0;
    }

    if(_finalNoteInsert == "Đổi tiền"){ 
      _processTypeExchangeMoney(tempValueMoney, _subOptionType!);
    }

    Map<String, dynamic> updateCost = {"value": tempDataInitialCost.toString()};
    Map<String, dynamic> conditionUpdateCost = {"name": 'initialCost'};

    int resultUpdate = await commonService.updateData("generic", updateCost, conditions: conditionUpdateCost);

    if (resultUpdate < 0) {
      showDialog(context: context, builder: (context) => _generateDialog(context, "Update fail ! Err"));
      return;
    }

    // Update sucess
    // showDialog(context: context, builder: (context) => _generateDialog(context, "Đã tạo giao dịch"));
    Navigator.pop(context, true); // return true if update sucess
  }

  int _convertInputToInt(TextEditingController _inputMoneyController) {
  // Kiểm tra giá trị đầu vào có phải là số hợp lệ không
    if (_inputMoneyController.text.isNotEmpty) {
        try {
          // Chuyển đổi giá trị từ TextField thành int
          int _inputMoneyValue = int.parse(_inputMoneyController.text);
         return _inputMoneyValue;
        } catch (e) {
          print('Lỗi: Giá trị nhập không phải là số hợp lệ.');
        }
      } else {
        return 0;
      }
      return 0;
  }


  /**
   * Process save data case money conversion
   */
  Future<int> _processTypeExchangeMoney(int tempValueMoney, String typeExchange) async{
    int resultUpdate = 0;
    String conditionUpdate = "exchangeMomo";
    List<Map<String, dynamic>> valueUpdate = [];

    if(typeExchange.isEmpty) {
      showDialog(context: context, builder: (context) => _generateDialog(context, "Param err !!"));
        Navigator.pop(context);
    }
    
    // Process data case Momo
    valueUpdate = await commonService.getDataWithCondition('generic', conditions: {
          'name' : "exchangeMomo"
      });

      // if get fail close form
    if(valueUpdate.isEmpty){
        showDialog(context: context, builder: (context) => _generateDialog(context, "Get data fail"));
        Navigator.pop(context);
    }


    // Process data case Bank
    if(typeExchange == _subOptionTypeLabel[1]){
      conditionUpdate = "exchangeBank";

      valueUpdate = await commonService.getDataWithCondition('generic', conditions: {
          'name' : "exchangeBank"
      });

      // if get fail close form
      if(valueUpdate.isEmpty){
        showDialog(context: context, builder: (context) => _generateDialog(context, "Get data fail"));
        Navigator.pop(context);
      }
    }

    // Process Sum and update data
    int valueFinal = int.parse(valueUpdate[0]['value']) + tempValueMoney;

    resultUpdate = await commonService.updateData("generic", {
        "value" :  valueFinal.toString(),
      }, 
      conditions: {
          "name" : conditionUpdate
      }
    );

    if (resultUpdate < 0) {
      showDialog(context: context, builder: (context) => _generateDialog(context, "Update fail ! Err"));
      Navigator.pop(context);
    }

    return resultUpdate;
  }
}
