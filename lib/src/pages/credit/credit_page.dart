import 'package:flutter/material.dart';
import 'package:battery_swap_station/src/config/theme.dart' as custom_theme;

class CreditPage extends StatefulWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Amount of credit',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '1000',
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Count of booked',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '20',
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 120,
                  right: 120,
                ),
                child: TextButton.icon(
                  onPressed: () {
                    //todo
                  },
                  icon: const Icon(
                    Icons.refresh,
                  ),
                  label: const Text('Refresh'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Credit'),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: custom_theme.Theme.gradient,
        ),
      ),
      centerTitle: true,
    );
  }
}
