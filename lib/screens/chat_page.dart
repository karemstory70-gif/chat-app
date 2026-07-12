import 'package:chatapp_task/Services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String reciverId;
  final String reciverEmail;
  const ChatPage({
    super.key,
    required this.reciverId,
    required this.reciverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();

  final auth = AuthServices();
  void sendMessage() async {
    if (messageController.text.trim().isEmpty){
    return;
    }
    String currentUserId = auth.currentUser!.uid;
    List<String> ids = [currentUserId, widget.reciverId];
    ids.sort();
    String chatid = ids.join("_");
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatid)
        .collection("message")
        .add({
          "senderId": currentUserId,
          "receiverId": widget.reciverId,
          "message": messageController.text.trim(),
          "timestamp": FieldValue.serverTimestamp(),
        });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = auth.currentUser!.uid;
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return SizedBox();
    List<String> ids = [currentUserId, widget.reciverId];
    ids.sort();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection("users")
        .doc(widget.reciverId)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Text("Loading...");
      }

      var data = snapshot.data!.data() as Map<String, dynamic>;
      return Text(data['name'] ?? "",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),);
      },
    ),
    actions: [
    IconButton(
      icon: Icon(Icons.search, color: Colors.black),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.menu, color: Colors.black),
      onPressed: () {},
    ),
    ],
    ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(ids.join("_"))
                  .collection("message")
                  .orderBy("timestamp",descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: snapshot.data!.docs.map((doc){
                    bool isMe = doc['senderId'] == currentUserId;
                    return Align(alignment: isMe ?Alignment.centerRight:Alignment.centerLeft,
                    child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                      color: isMe? Color(0xffE8E9EB):Color(0xffD84D4D),
                      borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(doc['message'],
                      style:  TextStyle(
                        color: isMe? Color(0xff595F69):Color(0xffFFFFFF),
                        fontSize: 18,
                        ),
                              ),
                    ),
                    ),
                    );
                  }).toList()
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.grey,size: 24,),
                ),

                Expanded(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    minLines: 1,  
                    decoration: const InputDecoration(
                      hintText: "اكتب رسالة...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send_rounded, 
                    color: Color(0xffD84D4D),
                    size: 24,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
