import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/styles/colors.dart';

// class GroceryItemCardWidget extends StatelessWidget {
// Set up widget UI for product 
class GroceryItemCardWidget extends StatefulWidget {

  GroceryItemCardWidget({Key? key, required this.item, this.heroSuffix})
      : super(key: key);
  final GroceryItem item;
  final String? heroSuffix;

  final double width = 174;
  final double height = 250;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;

  @override
  _GroceryItemCardWidget createState() => _GroceryItemCardWidget(); 
}

// Create call back to chil children
// https://chat.openai.com/c/4efb206e-b365-497b-8240-8969d9cb24e2
// typedef AddToCartCallback = void Function(GroceryItem item, int orderQuantity);

class _GroceryItemCardWidget extends State<GroceryItemCardWidget> {
  // int orderQuantity = 0; // Value default for button

  int calculateTotalPrice() {
    return widget.item.price * widget.item.orderQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor,
        ),
        borderRadius: BorderRadius.circular(
          widget.borderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: "GroceryItem:" + widget.item.name + "-" + (widget.heroSuffix ?? ""),
                  child: imageWidget(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              text: widget.item.name,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            // AppText(
            //   text: widget.item.description,
            //   fontSize: 14,
            //   fontWeight: FontWeight.w600,
            //   color: Color(0xFF7C7C7C),
            // ),
            AppText(
                  text: "\$${calculateTotalPrice().toStringAsFixed(2)}",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                // AppText(
                //   text: "\$${item.price.toStringAsFixed(2)}",
                //   fontSize: 18,
                //   fontWeight: FontWeight.bold,
                // ),
                Spacer(),
                addButtonOrder()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Container(
      child: Image.asset(
        widget.item.imagePath,
        height: 350,
        fit: BoxFit.contain, // hoặc BoxFit.cover tùy thuộc vào nhu cầu
      ),
    );
  }

  Widget addWidget() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.primaryColor),
      child: Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

  // Button + -
  Widget addButtonOrder() {
    return Row(
      children: [
        IconButton(
          onPressed: (){
            setState(() {
              // Increment value when the + button is pressed
              widget.item.orderQuantity++;  // Update value product
              // orderQuantity = widget.item.orderQuantity; // update value UI
            });
        
          }, 
          icon: Icon(Icons.add)
        ),  
     
        Center(
          child: Text(
             widget.item.orderQuantity.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () {
              if(widget.item.orderQuantity > 0) {
                setState(() {
                // Decrement value when the - button is pressed (but not below 1)
                widget.item.orderQuantity--;
                // orderQuantity = widget.item.orderQuantity; // update value UI
              });   
            }
          }, 
          icon: Icon(Icons.remove)
        )
      ],
    );
  }

}
