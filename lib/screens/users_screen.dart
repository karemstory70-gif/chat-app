import 'package:chatapp_task/Services/auth_services.dart';
import 'package:chatapp_task/core/chat_widget.dart';
import 'package:chatapp_task/core/story_widget.dart';
import 'package:chatapp_task/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final auth = AuthServices();
  bool isMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversations',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
      
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }

                  final users = snapshot.data!.docs;
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                  return Row(
                    children: [
                      StoryWidget(
                        name: null,
                        image: null,
                        isMe: true,
                      ),

                      ...users
                          .where((user) => user['uid'] != currentUserId)
                          .map((user) {
                        return StoryWidget(
                          name: user['name'],
                          image: user['image'],
                          isMe: false,
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final users = snapshot.data!.docs;
                return ListView(
                  children: users
                      .where(
                        (user) =>
                            user['uid'] !=
                            FirebaseAuth.instance.currentUser!.uid,
                      )
                      .map((user) {
                        final currentUserId =
                            FirebaseAuth.instance.currentUser!.uid;

                        final otherUserId = user['uid'] ?? '';

                        List<String> ids = [currentUserId, otherUserId];
                        ids.sort();
                        String chatId = ids.join("_");

                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("chats")
                              .doc(chatId)
                              .collection("message")
                              .orderBy("timestamp", descending: true)
                              .limit(1)
                              .get(),
                          builder: (context, snapshot) {
                            String lastMessage = '';
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              final data =
                                  snapshot.data!.docs.first.data()
                                      as Map<String, dynamic>;

                              lastMessage = data['message'] ?? '';
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatPage(
                                      reciverId: user['uid'],
                                      reciverEmail: user['email'],
                                    ),
                                  ),
                                );
                              },
                              child: ChatWidget(
                                name: user['name'] ?? '',
                                chat: lastMessage,
                                lastTime: '',
                                countMessage: 0,
                                image: user['image'] ?? '',
                              ),
                            );
                          },
                        );
                      })
                      .toList(),
                );
              },
            ),
          ),

        ],
      ),
      ) 
    );
  }
}
