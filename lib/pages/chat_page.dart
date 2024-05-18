// // import 'dart:js_interop';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:whisper/consts.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// // import '../consts.dart';
//
// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//
//   final _openAI = OpenAI.instance.build(
//     token: OPENAI_API_KEY,
//     baseOption: HttpSetup(
//       receiveTimeout: const Duration(seconds: 5),
//     ),
//     enableLog: true,
//   );
//
//   final ChatUser _currentUser =
//       ChatUser(id: '1', firstName: 'Nousher', lastName: 'Murtaza');
//
//   final ChatUser _gptChatUser =
//       ChatUser(id: '2', firstName: 'Whisper', lastName: 'GPT');
//
//   List<ChatMessage> _messages = <ChatMessage>[];
//
//   List<ChatUser> _typingUsers = <ChatUser>[];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: const Color.fromRGBO(
//           18,
//           53,
//           35,
//           1,
//         ),
//         title: Text(
//           'Whisper AI',
//           style: GoogleFonts.lato(
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: DashChat(
//           currentUser: _currentUser,
//           typingUsers: _typingUsers,
//           messageOptions: const MessageOptions(
//             currentUserContainerColor: Colors.black,
//             containerColor: Color.fromRGBO(0, 166, 126, 1),
//             textColor: Colors.white,
//           ),
//           onSend: (ChatMessage m) {
//             getChatResponse(m);
//           },
//           messages: _messages),
//     );
//   }
//
//   Future<void> getChatResponse(ChatMessage m) async {
//     setState(() {
//       _messages.insert(0, m);
//       _typingUsers.add(_gptChatUser);
//     });
//     List<Map<String, dynamic>> messagesHistory =
//     _messages.reversed.toList().map((m) {
//       if (m.user == _currentUser) {
//         return Messages(role: Role.user, content: m.text).toJson();
//       } else {
//         return Messages(role: Role.assistant, content: m.text).toJson();
//       }
//     }).toList();
//     final request = ChatCompleteText(
//       messages: messagesHistory,
//       maxToken: 200,
//       model: GptTurbo0301ChatModel(),
//     );
//     final response = await _openAI.onChatCompletion(request: request);
//     for (var element in response!.choices) {
//       if (element.message != null) {
//         setState(() {
//           _messages.insert(
//               0,
//               ChatMessage(
//                   user: _gptChatUser,
//                   createdAt: DateTime.now(),
//                   text: element.message!.content));
//         });
//       }
//     }
//     setState(() {
//       _typingUsers.remove(_gptChatUser);
//     });
//   }
// }




























import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: 'sk-proj-LqIryIQdNoISfsQKr7YWT3BlbkFJJZp91bhUjKM3nbVzZe2z',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Nousher', lastName: 'Murtaza');

  final ChatUser _gptChatUser =
  ChatUser(id: '2', firstName: 'Whisper', lastName: 'GPT');

  List<ChatMessage> _messages = <ChatMessage>[];

  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(
          18,
          53,
          35,
          1,
        ),
        title: Text(
          'Whisper AI',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(0, 166, 126, 1),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });
    List<Map<String, dynamic>> messagesHistory =
    _messages.reversed.toList().map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text).toJson();
      } else {
        return Messages(role: Role.assistant, content: m.text).toJson();
      }
    }).toList();
    final request = ChatCompleteText(
      messages: messagesHistory,
      maxToken: 200,
      model: GptTurbo0301ChatModel(),
    );
    try {
      final response = await _openAI.onChatCompletion(request: request);
      print('API response: $response');
      for (var element in response!.choices) {
        if (element.message != null) {
          setState(() {
            _messages.insert(
                0,
                ChatMessage(
                    user: _gptChatUser,
                    createdAt: DateTime.now(),
                    text: element.message!.content));
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}