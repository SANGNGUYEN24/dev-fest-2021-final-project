///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// Container to store each option of each question
/// Ex: A option1
///=============================================================================
import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  OptionTile(
      {required this.option,
      required this.description,
      required this.correctAnswer,
      required this.optionSelected});
  @override
  _OptionTileState createState() => _OptionTileState();
}

/// The UI of the option
class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          /// Letter symbol for each option
          /// Handle the option color when the user click option
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.description == widget.optionSelected
                      ? widget.optionSelected == widget.correctAnswer
                          ? Colors.green
                          : Colors.red
                      : Colors.grey,
                  width: 2.0),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              "${widget.option}",
              style: TextStyle(
                color: widget.description == widget.optionSelected
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green
                        : Colors.red
                    : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),

          /// The content of the option
          Expanded(
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 18,
                color: widget.description == widget.optionSelected
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green
                        : Colors.red
                    : Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
}
