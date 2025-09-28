import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
	const ChatbotPage({super.key});

	@override
	State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
	final List<Map<String, String>> _messages = [
		{'role': 'bot', 'text': 'Hello! How can I help you today?'},
		{'role': 'user', 'text': 'I want to book an appointment.'},
		{'role': 'bot', 'text': 'Sure! Please provide your preferred date.'},
	];
	final TextEditingController _controller = TextEditingController();

	void _sendMessage() {
		final text = _controller.text.trim();
		if (text.isNotEmpty) {
			setState(() {
				_messages.add({'role': 'user', 'text': text});
				_controller.clear();
			});
			// Here you can add bot response logic
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('AyurSutra Chatbot'),
				foregroundColor: const Color(0xFF0F172A),
				backgroundColor: Colors.white,
				elevation: 1,
			),
			body: Column(
				children: [
					Expanded(
						child: ListView.builder(
							padding: const EdgeInsets.all(16),
							itemCount: _messages.length,
							itemBuilder: (context, index) {
								final msg = _messages[index];
								final isUser = msg['role'] == 'user';
								return Align(
									alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
									child: Container(
										margin: const EdgeInsets.symmetric(vertical: 6),
										padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
										decoration: BoxDecoration(
											color: isUser ? const Color(0xFF90EE90) : const Color(0xFFE0F7FA),
											borderRadius: BorderRadius.circular(16),
										),
										child: Text(
											msg['text'] ?? '',
											style: TextStyle(
												color: isUser ? Colors.black : const Color(0xFF0F172A),
												fontSize: 16,
												fontFamily: 'Poppins',
											),
										),
									),
								);
							},
						),
					),
					Container(
						padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
						color: Colors.white,
						child: Row(
							children: [
								Expanded(
									child: TextField(
										controller: _controller,
										decoration: InputDecoration(
											hintText: 'Type your message...',
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(20),
												borderSide: BorderSide.none,
											),
											filled: true,
											fillColor: Colors.grey[100],
											contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
										),
									),
								),
								const SizedBox(width: 8),
								IconButton(
									icon: const Icon(Icons.send, color: Color(0xFF0F172A)),
									onPressed: _sendMessage,
								),
							],
						),
					),
				],
			),
		);
	}
}
