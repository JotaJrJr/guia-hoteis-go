import 'package:flutter/material.dart';

class SmoothToggleSwitch extends StatefulWidget {
  @override
  _SmoothToggleSwitchState createState() => _SmoothToggleSwitchState();
}

class _SmoothToggleSwitchState extends State<SmoothToggleSwitch> {
  int selectedIndex = 0;

  void _selectOption(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selectedIndex == 0 ? 0 : MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 43.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _selectOption(0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      FlutterLogo(),
                      const SizedBox(width: 1.0),
                      Text(
                        'ir agora',
                        style: TextStyle(
                          color: selectedIndex == 0 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6.0),
              GestureDetector(
                onTap: () => _selectOption(1),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      const SizedBox(width: 1.0),
                      Text(
                        'ir outro dia',
                        style: TextStyle(
                          color: selectedIndex == 1 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
