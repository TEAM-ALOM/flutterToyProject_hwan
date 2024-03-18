import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist_hwan/models/todo.dart';
import 'package:todolist_hwan/screens/addtodo_screen.dart';

late Box<ToDo> box;

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  box = await Hive.openBox<ToDo>('box');
  box.put('todo', ToDo(task: 'task1'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVisibleToday = false;
  bool isVisibleWeek = false;
  bool isVisibleMonth = false;
  bool isVisibleNow = false;

  @override
  Widget build(BuildContext context) {
    ToDo? todo = box.get('todo') as ToDo;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 109, 231, 107),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(todo.task),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check),
              Text(
                "TodoList",
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddToDo(),
                      ));
                },
                child: const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('오늘의 할 일'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibleToday = !isVisibleToday;
                          });
                        },
                        icon: isVisibleToday
                            ? const Icon(Icons.keyboard_arrow_up_outlined)
                            : const Icon(Icons.keyboard_arrow_down_outlined))
                  ],
                ),
                Visibility(
                  visible: isVisibleToday,
                  child: const Text('리스트가 비었습니다.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('일주일 간 해야 할 일'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibleWeek = !isVisibleWeek;
                          });
                        },
                        icon: isVisibleWeek
                            ? const Icon(Icons.keyboard_arrow_up_outlined)
                            : const Icon(Icons.keyboard_arrow_down_outlined))
                  ],
                ),
                Visibility(
                  visible: isVisibleWeek,
                  child: const Text('리스트가 비었습니다.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('이번 달에 할 일'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibleMonth = !isVisibleMonth;
                          });
                        },
                        icon: isVisibleMonth
                            ? const Icon(Icons.keyboard_arrow_up_outlined)
                            : const Icon(Icons.keyboard_arrow_down_outlined))
                  ],
                ),
                Visibility(
                  visible: isVisibleMonth,
                  child: const Text('리스트가 비었습니다.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('지금 당장 할 일'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibleNow = !isVisibleNow;
                          });
                        },
                        icon: isVisibleNow
                            ? const Icon(Icons.keyboard_arrow_up_outlined)
                            : const Icon(Icons.keyboard_arrow_down_outlined))
                  ],
                ),
                Visibility(
                  visible: isVisibleNow,
                  child: const Text('리스트가 비었습니다.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
