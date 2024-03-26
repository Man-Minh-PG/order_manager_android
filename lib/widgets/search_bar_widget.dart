import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchIcon = 'assets/icons/search_icon.svg';
  final Function(String) onSearchChanged;
  final TextEditingController controller; // Thêm trường controller

  const SearchBarWidget({required this.onSearchChanged, required this.controller}); // Nhận controller

  @override
  _StateBarWidget createState() => _StateBarWidget();
}

class _StateBarWidget extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(0xFFF2F3F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(widget.searchIcon),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller, // Sử dụng controller
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Note...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
