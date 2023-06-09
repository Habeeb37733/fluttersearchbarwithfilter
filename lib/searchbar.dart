import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  String? selectedOption;
  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 26},
    {"id": 10, "name": "Becky", "age": 32},
  ];

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    _foundUsers = _allUsers;
    //selectedOption = '1-15';
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];

    if (enteredKeyword.isEmpty) {
      if (selectedOption == '1-15') {
        results = _allUsers
            .where((user) => user["age"] >= 1 && user["age"] <= 15)
            .toList();
      } else if (selectedOption == '15-30') {
        results = _allUsers
            .where((user) => user["age"] >= 15 && user["age"] <= 30)
            .toList();
      } else if (selectedOption == '30-50') {
        results = _allUsers
            .where((user) => user["age"] >= 30 && user["age"] <= 50)
            .toList();
      } else {
        results = _allUsers;
      }
    } else {
      results = _allUsers.where((user) {
        final name = user["name"].toLowerCase();
        final age = user["age"].toString();
        final keyword = enteredKeyword.toLowerCase();
        return (_checkbox1 && user["id"].toString().contains(keyword)) ||
            (_checkbox2 && name.contains(keyword)) ||
            (_checkbox3 && age.contains(keyword));
      }).toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Bar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showPopup(context);
                  },
                ),



              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Filter"),


                DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue;
                      _runFilter('');
                    });
                  },
                  hint: const Text('Age', style: TextStyle(fontSize: 16)),
                  // Heading "Age"
                  items: <String>[
                    '1-15',
                    '15-30',
                    '30-50',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),


            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) =>
                    Card(
                      key: ValueKey(_foundUsers[index]["id"]),
                      color: Colors.amberAccent,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Text(
                          _foundUsers[index]["id"].toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Row(
                          children: [
                            const Text("Name:"),
                            Text(_foundUsers[index]['name']),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Row(
                              children: [
                                const Text("Age:"),
                                Text(
                                  '${_foundUsers[index]["age"]
                                      .toString()} years old',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Window'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _checkbox1,
                        onChanged: (value) {
                          setState(() {
                            _checkbox1 = value!;
                          });
                        },
                      ),
                      Text('ID'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _checkbox2,
                        onChanged: (value) {
                          setState(() {
                            _checkbox2 = value!;
                          });
                        },
                      ),
                      Text('Name'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _checkbox3,
                        onChanged: (value) {
                          setState(() {
                            _checkbox3 = value!;
                          });
                        },
                      ),
                      Text('Age'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text('Submit'),
                onPressed: () {
                  // Perform actions with the entered data

                  print('ID: $_checkbox1');
                  print('NAME: $_checkbox2');
                  print('AGE: $_checkbox3');

                  // Close the dialog
                  Navigator.of(context).pop();
                  _runFilter('');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
