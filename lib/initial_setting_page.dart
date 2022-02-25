import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqttchat/bloc/room_cubit.dart';
import 'package:mqttchat/global/connection_status.dart';

class InitialSettingPage extends StatefulWidget {
  final ConnectionStatus status;

  final String notification;

  InitialSettingPage({required this.status, required this.notification});

  @override
  State<StatefulWidget> createState() {
    return InitialSettingPageState();
  }
}

class InitialSettingPageState extends State<InitialSettingPage> {
  final TextEditingController _inputBrokerController = TextEditingController();

  final TextEditingController _inputPortController = TextEditingController()
    ..text = '1883';

  final TextEditingController _inputClientNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Setting')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              color: Colors.amberAccent,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.notification.isEmpty
                        ? 'Fill in Broker Address, Broker port, and Your Name'
                        : widget.notification,
                    textAlign: TextAlign.justify,
                  )),
            ),
            Row(
              children: [
                Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Broker Address'),
                          TextField(
                            controller: _inputBrokerController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '192.168.100.1',
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Port'),
                          TextField(
                            controller: _inputPortController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: '1883'),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              alignment: Alignment.center,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name (Required)',
                ),
                controller: _inputClientNameController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 40,
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    if (allFilled()) {
                      BlocProvider.of<RoomCubit>(context).setUpClient(
                        _inputBrokerController.text,
                        int.parse(_inputPortController.text),
                        _inputClientNameController.text + '-${generateUniqueId(5)}',
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Fill All Required Informations!');
                    }
                  },
                  child: const Text('CONNECT')),
            ),
          ],
        ),
      ),
    );
  }

  bool allFilled() {
    return _inputBrokerController.text.isNotEmpty &&
        _inputPortController.text.isNotEmpty &&
        _inputClientNameController.text.isNotEmpty;
  }

  String generateUniqueId(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
