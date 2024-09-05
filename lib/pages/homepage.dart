import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dummyapi/models/user_model.dart';
import 'package:dummyapi/pages/userdetailspage.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<UserModel>>? users;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No internet connection. Showing cached data.')),
        );
      } else {
        setState(() {
          users = apiService.fetchUsers();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        actions: [
          IconButton(
              onPressed: () => checkConnectivity(), icon: Icon(Icons.restore))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => checkConnectivity(),
        child: LayoutBuilder(builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          final isWiderDesktopScreen = constraints.maxWidth > 1000;
          final crossAxisCount = isWiderDesktopScreen
              ? 6
              : isWideScreen
                  ? 4
                  : 3;
          return FutureBuilder<List<UserModel>>(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.none) {
                return const Center(
                  child: Text('Please enable your internet connection.'),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No users found'));
              } else {
                final users = snapshot.data!;
                if (!isWideScreen) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.picture),
                        ),
                        title: Text('${user.firstName} ${user.lastName}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailsPage(userId: user.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailsPage(userId: user.id),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.picture),
                                  radius:
                                      MediaQuery.of(context).size.width * .055,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  '${user.title}. ${user.firstName} ${user.lastName}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            .015,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            },
          );
        }),
      ),
    );
  }
}
