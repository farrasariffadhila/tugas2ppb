import 'dart:io';
import 'package:flutter/material.dart';
import 'entities/objectbox.dart';
import 'entities/person.dart';
import 'objectbox.g.dart';

late Store store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = (await ObjectBox.create()).store;
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController inputController = TextEditingController();
  late Box<Person> personBox;
  List<Person> people = [];

  @override
  void initState() {
    super.initState();
    personBox = store.box<Person>();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      people = personBox.getAll();
    });
  }

  Future<void> deleteAll() async {

    personBox.removeAll();


    store.close();


    final dir = Directory('${Directory.current.path}/objectbox');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }


    store = (await ObjectBox.create()).store;
    personBox = store.box<Person>();

    _refreshData();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffad68ff)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ObjectBox CRUD Demo'),
          elevation: 12,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: inputController,
              decoration: const InputDecoration(hintText: 'Input'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                personBox.put(Person(name: inputController.text));
                inputController.clear();
                _refreshData();
              },
              child: const Text('Create'),
            ),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Retrieve / Read'),
            ),
            ElevatedButton(
              onPressed: () {
                List<String> strings = inputController.text.split('-');
                if (strings.length == 2) {
                  int id = int.tryParse(strings[0]) ?? 0;
                  if (id > 0) {
                    personBox.put(Person(id: id, name: strings[1]));
                    inputController.clear();
                    _refreshData();
                  }
                }
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                int id = int.tryParse(inputController.text) ?? 0;
                if (id > 0) {
                  personBox.remove(id);
                  inputController.clear();
                  _refreshData();
                }
              },
              child: const Text('Delete'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await deleteAll();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('🗑️ Delete All'),
            ),
            const SizedBox(height: 20),
            const Text('📋 Daftar Data:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];
                return ListTile(
                  title: Text('${person.id} - ${person.name}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
