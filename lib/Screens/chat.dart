import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class GroupChatApp extends StatelessWidget {
  const GroupChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MessageScreen(),
    );
  }
}

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override  // ignore: library_private_types_in_public_api
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _messagesStream = _firestore
        .collection('group_chat')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _signIn() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      setState(() {
        _user = user;
      });
    } catch (e) {
      log('Failed to sign in: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _user = null;
      });
    } catch (e) {
      log('Failed to sign out: $e');
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      await _firestore.collection('group_chat').add({
        'message': message,
        'sender': _user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    } catch (e) {
      log('Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: _signIn,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final sender = message['sender'];
                    final isCurrentUser = sender == _user!.uid;

                    return ListTile(
                      title: Text(
                        message['message'],
                        style: TextStyle(
                          fontWeight: isCurrentUser
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(isCurrentUser ? 'You' : sender),
                      trailing: isCurrentUser ? null : const Icon(Icons.person),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
