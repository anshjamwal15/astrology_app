import 'package:astrology_app/models/chat_list_messages.dart';
import 'package:astrology_app/models/chat_messages.dart';
import 'package:astrology_app/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getOrCreateChatId(List<String> members) async {
    if (members.length == 2) {
      members.sort();
      String chatId = members.join('_');
      DocumentSnapshot chatDoc = await FirebaseFirestore.instance
          .collection('chat_messages')
          .doc(chatId)
          .get();

      if (chatDoc.exists) {
        return chatId;
      } else {
        await FirebaseFirestore.instance
            .collection('chat_messages')
            .doc(chatId)
            .set({
          'members': members,
          'created_at': Timestamp.now(),
        });
        return chatId;
      }
    } else {
      return await _createNewChatRoom(members);
    }
  }

  Future<String> _createNewChatRoom(List<String> members) async {
    DocumentReference chatDocRef =
        FirebaseFirestore.instance.collection('chat_messages').doc();
    String chatId = chatDocRef.id;
    await chatDocRef.set({
      'members': members,
      'date_time': Timestamp.now(),
    });
    return chatId;
  }

  Stream<List<ChatMessages>> getChatMessagesStream(String chatId) {
    return _firestore
        .collection('chat_messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('date_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessages.fromFirestore(doc))
            .toList());
  }

  Future<void> sendMessage(String chatId, ChatMessages message) async {
    await _firestore
        .collection('chat_messages')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<List<ChatListMessages>> getUsersWhoMessaged(String userId) async {
    // Step 1: Query the 'messages' collection group to find the most recent messages
    QuerySnapshot messagesSnapshot = await _firestore
        .collectionGroup('messages')
        .where('members', arrayContains: userId)
        .orderBy('date_time', descending: true)
        .get();

    // Step 2: Collect the last message for each unique user in the 'members' list
    Map<String, ChatListMessages> latestMessages = {};

    for (var messageDoc in messagesSnapshot.docs) {
      var messageData = messageDoc.data() as Map<String, dynamic>;
      Timestamp messageTimestamp = messageData['date_time'] as Timestamp;
      List<dynamic> members = messageData['members'] as List<dynamic>;

      // Iterate through all members in the message
      for (var memberId in members) {
        if (memberId != userId && !latestMessages.containsKey(memberId)) {
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(memberId).get();
          if (userDoc.exists) {
            String userName = userDoc['name'] as String;
            bool isRead = (messageData['is_read'] as bool?) ?? false;
            latestMessages[memberId] = ChatListMessages(
              dateTime: messageTimestamp,
              userName: userName,
              message: messageData['message'] as String,
              senderId: memberId,
              isRead: isRead
            );
          }
        }
      }
    }
    return latestMessages.values.toList();
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final batch = _firestore.batch();
    final query = _firestore
        .collection('chat_messages')
        .doc(chatId)
        .collection('messages')
        .where('members', arrayContains: userId)
        .where('is_read', isEqualTo: false);

    final snapshot = await query.get();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'is_read': true});
    }
    await batch.commit();
  }

  Future<int> getUnreadMessageCount(String userId) async {
    final query = _firestore
        .collectionGroup('messages')
        .where('members', arrayContains: userId)
        .where('is_read', isEqualTo: false);

    final snapshot = await query.get();
    return snapshot.docs.length;
  }
}
