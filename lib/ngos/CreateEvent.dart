import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Questionnaire Form'),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(  // Wrap the Form in SingleChildScrollView
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Class *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your class';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Division *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your division';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Roll No. (Seven Digit) *',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your roll number';
                  } else if (value.length != 7) {
                    return 'Roll number must be seven digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 1 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 2 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 2';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 3 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 3';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 4 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 4';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 5 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 6 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 6';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question 7 *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer Question 7';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}