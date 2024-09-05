import 'package:dummyapi/models/user_model.dart';
import 'package:dummyapi/services/api_services.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;

  UserDetailsPage({required this.userId});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Future<UserModel>? user;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    user = apiService.fetchUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<UserModel>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
                child: Text(
                    'Something wrong!. Please check your internet connection.'));
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    textAlign: TextAlign.center,
                    'Something wrong!. Please check your internet connection.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user details found'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.picture),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name: ${user.title}. ${user.firstName} ${user.lastName}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
