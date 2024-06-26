import 'package:flutter/material.dart';
import 'package:temp_flutter/constants.dart';

class AddVideo extends StatelessWidget {
  const AddVideo({super.key});
  // showOptions(BuildContext context){
  //
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          // onTap: () => showOptions,
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: buttonColor),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
