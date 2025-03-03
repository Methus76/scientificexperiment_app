import 'package:flutter/material.dart';

// โมเดลข้อมูล
class Item {
  String name;
  int score;
  DateTime date;
  String category;

  Item(this.name, this.score, this.date, this.category);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ลิสต์ที่เก็บข้อมูล
  List<Item> items = [];

  // ฟังก์ชันที่ใช้เพิ่มข้อมูลจาก AddPage
  void _addItem(Item item) {
    setState(() {
      items.add(item);
    });
  }

  // ฟังก์ชันลบไอเทม
  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Experiment App'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item.name),
            onDismissed: (direction) {
              // เมื่อปัดลบ
              _deleteItem(index);
            },
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('Score: ${item.score}, Date: ${item.date}, Category: ${item.category}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteItem(index);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // เปิด AddPage และรอรับค่าที่ส่งกลับจาก AddPage
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );

          // ถ้า newItem ไม่เป็น null ก็เพิ่มลงในรายการ
          if (newItem != null) {
            _addItem(newItem);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _score = 0;
  DateTime _date = DateTime.now();
  String _category = 'ฟิสิกส์'; // ค่าเริ่มต้นเป็น ฟิสิกส์

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name/Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Score/Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a score';
                  }
                  return null;
                },
                onSaved: (value) {
                  _score = int.parse(value!);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _date) {
                    setState(() {
                      _date = selectedDate;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              DropdownButton<String>(
                value: _category,
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                items: <String>['ฟิสิกส์', 'เคมี', 'ชีวะ']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // ส่งค่ากลับไปที่ HomePage
                    final newItem = Item(_name, _score, _date, _category);
                    Navigator.pop(context, newItem);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
