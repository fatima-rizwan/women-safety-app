import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:women_safety_app/data/hive%20db/boxes.dart';
import 'package:women_safety_app/model/contact_model.dart';
import 'package:women_safety_app/res/colors/colors.dart';
import 'package:get/get.dart';
import 'package:women_safety_app/views/child/contact/contact_screen.dart';

class AddContacts extends StatelessWidget {
  const AddContacts({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centers the title in the app bar
        title: const Text(
          'Manage Trusted Contacts',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Makes the title white for better visibility
          ),
        ),
        backgroundColor: primaryColor, // Keeps the original primary color
        elevation: 5, // Adds a slight shadow for a more appealing look
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => const ContactScreen());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          child: const Text(
            'Add Trusted Contacts ',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Moves the image down
                child: Image.asset(
                  'assets/logo.png',
                  height: size.width * 0.4, // Adjusts the size of the image
                  width: size.width * 0.4,
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<Box<ContactModel>>(
                  valueListenable: Boxes.getContacts().listenable(),
                  builder: (context, box, child) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Trusted contacts available",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: Boxes.getContacts().length,
                      itemBuilder: (context, index) {
                        final contact = box.getAt(index) as ContactModel;
                        return Card(
                          child: ListTile(
                            title: Text(
                              contact.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(contact.phoneNumber),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      await FlutterDirectCallerPlugin
                                          .callNumber(contact.phoneNumber);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      box.deleteAt(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
