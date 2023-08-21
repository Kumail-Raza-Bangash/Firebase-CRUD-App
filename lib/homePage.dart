import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase002/email_auth/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userEmail; // Store the user's email address
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the user's email address when the screen is initialized
    loadUserEmail();
  }

  void loadUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(fontSize: 14),
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void saveUser() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    nameController.clear();
    emailController.clear();
    phoneController.clear();

    if (name.isNotEmpty && email.isNotEmpty || phone.isNotEmpty) {
      Map<String, dynamic> userData = {
        "Name": name,
        "Email": email,
        "Phone Number": phone
      };
      FirebaseFirestore.instance.collection("users").add(userData);
      showErrorSnackbar("User Created");
      return;
    } else {
      showErrorSnackbar("Please fill all the details");
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => Signin()));
  }

  Future<void> deleteUser(String docId) async {
    await FirebaseFirestore.instance.collection("users").doc(docId).delete();
    showErrorSnackbar("User Deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (userEmail != null)
                    Text(
                      userEmail!,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: saveUser,
                child: Text('Save'),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            String docId = snapshot.data!.docs[index].id;

                            return ListTile(
                              title: Text(userMap["Name"]),
                              subtitle: Text(
                                userMap["Email"].isEmpty
                                    ? userMap["Phone Number"]
                                    : userMap["Email"],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteUser(docId);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("No Data"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
