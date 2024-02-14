import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatelessWidget {
  final String searchIcon = "assets/icons/search_icon.svg";
  final Function(String) onSearchChanged;

  SearchBarWidget({required this.onSearchChanged});

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
          SvgPicture.asset(searchIcon),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged, // Gọi hàm callback khi giá trị thay đổi
              decoration: InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
