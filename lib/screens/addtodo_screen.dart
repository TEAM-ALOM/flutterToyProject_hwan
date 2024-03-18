import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist_hwan/main.dart';
import 'package:hive/hive.dart';
import 'package:todolist_hwan/models/todo.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  String _textFormFieldValue = '';
  DateTime? _selectedDate;
  Duration selectedDuration = const Duration(hours: 0, minutes: 0);
  Duration selectedDuration2 = const Duration(hours: 0, minutes: 0);

  void _showTimerPicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: CupertinoColors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                        child: const Text("완료"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                Expanded(
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      initialTimerDuration: selectedDuration,
                      onTimerDurationChanged: (Duration duration) {
                        setState(() {
                          selectedDuration = duration;
                        });
                      }),
                )
              ],
            ),
          );
        });
  }

  void _showTimerPicker2(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: CupertinoColors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                        child: const Text("완료"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                Expanded(
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      initialTimerDuration: selectedDuration2,
                      onTimerDurationChanged: (Duration duration) {
                        setState(() {
                          selectedDuration2 = duration;
                        });
                      }),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 109, 231, 107),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "오늘의 할 일은 무엇인가요?",
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                  child: const Text(
                    "취소",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_textFormFieldValue == '') {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('닫기'))
                                ],
                                title: const Text('알림'),
                                content: const Text('할일 칸이 비었습니다.'),
                              ));
                    } else if (_selectedDate == null) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('닫기'))
                                ],
                                title: const Text('알림'),
                                content: const Text('날짜를 선택하시오.'),
                              ));
                    } else if (selectedDuration.inMinutes.toInt() >
                        selectedDuration2.inMinutes.toInt()) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('닫기'))
                                ],
                                title: const Text('알림'),
                                content:
                                    const Text('시작 시간과 종료 시간을 다시 확인해주시기 바랍니다.'),
                              ));
                    } else {
                      Map<String, String> todoMap = {
                        'task': _textFormFieldValue,
                        'date': _selectedDate.toString().split(" ")[0],
                        'timeStart':
                            '${selectedDuration.inHours.toString()}:${selectedDuration.inMinutes.remainder(60).toString()}',
                        'timeEnd':
                            '${selectedDuration2.inHours.toString()}:${selectedDuration2.inMinutes.remainder(60).toString()}',
                      };

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    }
                  },
                  child: const Text(
                    "확인",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '할일',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            onChanged: (newValue) {
                              setState(() {
                                _textFormFieldValue = newValue;
                              });
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '날짜',
                      style: TextStyle(
                        fontSize: 24,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(_selectedDate != null
                        ? _selectedDate.toString().split(" ")[0]
                        : ''),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        ).then((selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                        });
                      },
                      child: const Text('날짜 선택'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '시간',
                            style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text('시작시간'),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showTimerPicker(context);
                                    },
                                    child: Text(
                                        '${selectedDuration.inHours.toString()}:${selectedDuration.inMinutes.remainder(60).toString()}'),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('종료시간'),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showTimerPicker2(context);
                                    },
                                    child: Text(
                                        '${selectedDuration2.inHours.toString()}:${selectedDuration2.inMinutes.remainder(60).toString()}'),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Column(
                  children: [
                    Text(
                      '메모',
                      style: TextStyle(
                        fontSize: 24,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AlertDialogPage extends StatelessWidget {
  const AlertDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlertDialog'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'))
                      ],
                      title: const Text('Alert Dialog'),
                      content: const Text('Hello'),
                    ));
          },
          child: const Text('AlertDialog'),
        ),
      ),
    );
  }
}
