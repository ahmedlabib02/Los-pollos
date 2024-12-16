//
import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/ai_prompt.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/selected_restaurant_provider.dart';
import 'package:los_pollos_hermanos/services/ai_services.dart';
import 'chat_message.dart';
import 'typing_effect.dart';
import 'package:provider/provider.dart';

class ChatOverlay extends StatefulWidget {
  const ChatOverlay({super.key});

  @override
  State<ChatOverlay> createState() => _ChatOverlayState();
}

class _ChatOverlayState extends State<ChatOverlay> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late AiPrompt _prompt;
  bool _isTyping = false;
  bool _isInitialized = false; // Flag to track initialization

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if the chat has been initialized already
    if (!_isInitialized) {
      _initializeChat();
      _isInitialized = true; // Set the flag to true after initialization
    }
  }

  void _initializeChat() {
    // Call database and prepare the prompt
    _prepPrompt().then((_) {
      // Send the first welcome message after preparing the prompt
      _sendWelcomeMessage();
    });
  }

  Future<void> _prepPrompt() async {
    setState(() {
      _isTyping = true; // Disable send button during preparation
    });

    // get the restaurantId from the provider
    String restaurantId = Provider.of<SelectedRestaurantProvider?>(context)
            ?.selectedRestaurantId ??
        '';
    String userId = Provider.of<CustomUser?>(context)!.uid;
    print('Restaurant ID: $restaurantId');
    print('User ID: $userId');
    _prompt = await AiServices.getPrompt(userId, restaurantId);

    setState(() {
      _isTyping = false; // Re-enable send button after preparation
    });
  }

  void _sendWelcomeMessage() {
    const String welcomeMessage =
        "Hi! I’m AI Hermano. How can I assist you today?";
    _addMessage(welcomeMessage, isUser: false);
  }

  void _addMessage(String content, {bool isUser = true}) {
    setState(() {
      _messages.add(ChatMessage(content: content, isUser: isUser));
      if (!isUser) _isTyping = false; // Stop typing when bot responds
    });
  }

  void _handleSend() async {
    if (_controller.text.trim().isEmpty) return;
    String userMessage = _controller.text.trim();
    _controller.clear();
    // Add the user's message
    _addMessage(userMessage);
    setState(() {
      _isTyping = true;
    });
    String response = await AiServices.getResponse(_prompt, userMessage);
    _addMessage(response, isUser: false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "AI Hermano",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            // Chat messages
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: _messages[_messages.length - index - 1],
                  );
                },
              ),
            ),
            if (_isTyping) const TypingEffect(),
            const SizedBox(height: 12),
            // Input field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 194, 48, 1),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isTyping ? null : _handleSend,
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromRGBO(242, 194, 48, 1),
                  ),
                  tooltip: "Send Message",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
