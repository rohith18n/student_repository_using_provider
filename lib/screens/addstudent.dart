import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository_using_provider/screens/widget.dart';
import '../db/model/student_model.dart';
import '../db/providers/image_provide.dart';
import '../db/providers/student_provider.dart';

class AddStudent extends StatelessWidget {
  AddStudent({super.key});

  final namecntrl = TextEditingController();

  final agecntrl = TextEditingController();

  final addresscntrl = TextEditingController();

  final numbercntrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const appTitle = "Add Student's Details";
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<TempImageProvider>(
                    builder: (context, value, child) => Column(
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: value.tempImagePath == null
                                ? const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/man.jpg'),
                                    radius: 100,
                                  )
                                : CircleAvatar(
                                    radius: 100,
                                    backgroundImage: FileImage(
                                      File(value.tempImagePath!),
                                    ),
                                  )),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              getimage(value);
                            },
                            icon: const Icon(Icons.photo),
                            label: const Text("Add Photo")),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: namecntrl,
                    keyboardType: TextInputType.name,
                    decoration: Custom('Name', Icons.person),
                    validator: (value) {
                      if (namecntrl.text.isEmpty) {
                        return 'Name Field is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: agecntrl,
                    keyboardType: TextInputType.number,
                    decoration: Custom('Age', Icons.calendar_month),
                    maxLength: 3,
                    validator: (value) {
                      if (agecntrl.text.isEmpty) {
                        return 'Age Field is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addresscntrl,
                    keyboardType: TextInputType.streetAddress,
                    decoration: Custom('Address', Icons.home),
                    validator: (value) {
                      if (addresscntrl.text.isEmpty) {
                        return 'Address Field is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: numbercntrl,
                    keyboardType: TextInputType.phone,
                    decoration: Custom('phone', Icons.phone_android),
                    maxLength: 10,
                    validator: (value) {
                      if (numbercntrl.text.isEmpty) {
                        return 'Phone Field is Empty';
                      } else if (numbercntrl.text.length < 10) {
                        return 'Enter a valid Phone number';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                    child: Consumer<TempImageProvider>(
                      builder: (context, value, child) =>
                          Consumer<ProviderForStudent>(
                        builder: (context, value2, child) => ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (value.tempImagePath == null) {
                                addingFailed(context);
                              } else {
                                addingSuccess(value2, context, value);
                              }
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      )),
    );
  }

  void addingFailed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Please add your photo!"),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: Duration(seconds: 3),
    ));
  }

  void addingSuccess(ProviderForStudent value, BuildContext context,
      TempImageProvider value2) async {
    StudentModel st = StudentModel(
      profile: value2.tempImagePath!,
      name: namecntrl.text.trim(),
      age: agecntrl.text.trim(),
      address: addresscntrl.text.trim(),
      number: numbercntrl.text.trim(),
    );
    value.addStudent(st);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${namecntrl.text} is added to your repository'),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 3),
    ));
    value2.tempImagePath = null;
    value2.notify();
    Navigator.of(context).pop();
  }

  getimage(TempImageProvider value) async {
    await value.getImage();
  }
}

// ignore: non_constant_identifier_names
Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return SizedBox(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 20,
          ),
          Text(title),
        ],
      ),
    ),
  );
}
