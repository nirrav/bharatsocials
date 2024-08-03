import 'package:flutter/material.dart';

class DomainChat extends StatefulWidget {
  final String domainId;
  final bool
      isVolunteer; // Add a boolean flag to check if the current user is a volunteer

  const DomainChat(
      {super.key, required this.domainId, required this.isVolunteer});

  @override
  State<DomainChat> createState() => _DomainChatState();
}

class _DomainChatState extends State<DomainChat> {
  List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  String? _domainName;
  String? _ngoName;

  @override
  void initState() {
    super.initState();
    _loadDomainName();
    _loadNgoName();
    _loadMessages();
    _initMessage();
  }

  Future<void> _loadDomainName() async {
    // Fetch domain name from database based on domainId
    _domainName = await DatabaseService().getDomainName(widget.domainId);
    setState(() {});
  }

  Future<void> _loadNgoName() async {
    // Fetch ngo name from database based on domainId
    _ngoName = await DatabaseService().getNgoName(widget.domainId);
    setState(() {});
  }

  Future<void> _loadMessages() async {
    // Fetch messages from database based on domainId
    _messages = await DatabaseService().getMessages(widget.domainId);
    setState(() {});
  }

  Future<void> _sendMessage() async {
    // Send message logic here
    await DatabaseService().sendMessage(widget.domainId, _textController.text);
    _textController.clear();
    _loadMessages();
  }

  void _initMessage() {
    _textController.text = '''
NGO Name: $_ngoName
Event Name: 
Location: 
Date & Time: 
Cause: 
More Info: 
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _domainName ?? 'Loading...',
        ),
        titleTextStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black,),
        backgroundColor: const Color(0xFFCDEBF7),
        elevation: 0, // Remove shadow for a cleaner look
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the border
          child: Container(
            color: Colors.black, // Color of the border
            height: 1.0, // Thickness of the border
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/texture.jpg'), // replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Adjust the width to 80% of the screen width
                    margin: const EdgeInsets.only(
                        left: 20, right: 80, top: 20, bottom: 30),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),

                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(_messages[index].message),
                          subtitle: Text(_messages[index].sender),
                        ),
                        Positioned(
                          top: 0,
                          right: 0, // Adjust the position of the info button
                          child: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Message Info'),
                                    content: Text(
                                      'Date: ${_messages[index].sentOn.split(' ')[0]}\nTime: ${_messages[index].sentOn.split(' ')[1]}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        widget.isVolunteer
                            ? Positioned(
                                bottom: 10,
                                right:
                                    0, // Position the bookmark button at the top right corner
                                child: IconButton(
                                  icon: const Icon(Icons.bookmark_border),
                                  onPressed: () {
                                    // Add functionality here
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
            // const Divider(
            //   color: Colors.black,
            //   height: 2,
            // ),
            widget.isVolunteer
                ? Container(
                    // margin: EdgeInsets.only(bottom: 50),
                    ) // Show an empty container if the user is a volunteer
                : Container(
                    padding: const EdgeInsets.only(
                        left: 10, bottom: 10, right: 10, top: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFCDEBF7), // add this line
                      // borderRadius: BorderRadius.circular(
                      //     10), // optional, adds a slight curve to the container
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Type a message...',
                              filled: true, // add this line
                              fillColor: Colors.white, // add this line
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _sendMessage,
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  String message;
  String sender;
  String sentOn;

  ChatMessage(
      {required this.message, required this.sender, required this.sentOn});
}

class DatabaseService {
  // Replace with your actual database logic
  Future<String> getDomainName(String domainId) async {
    // Fetch domain name from database
    return 'Dummy Domain';
  }

  Future<String> getNgoName(String domainId) async {
    // Fetch ngo name from database
    return 'Dummy NGO';
  }

  Future<List<ChatMessage>> getMessages(String domainId) async {
    // Fetch messages from database
    return [
      ChatMessage(
        message: '''
NGO Name: Dummy NGO
Event Name: Dummy Event
Location: Dummy Location
Date & Time: Dummy Date & Time
Cause: Dummy Cause
More Info: Dummy More Info
''',
        sender: 'Dummy volunteer name',
        sentOn: '2023-02-20 14:30:00',
      ),
      ChatMessage(
        message: '''
NGO Name: Dummy NGO
Event Name: Dummy Event
Location: Dummy Location
Date & Time: Dummy Date & Time
Cause: Dummy Cause
More Info: Dummy More Info
''',
        sender: 'Dummy volunteer name',
        sentOn: '2023-02-20 14:30:00',
      ),
      ChatMessage(
        message: '''
NGO Name: Dummy NGO
Event Name: Dummy Event
Location: Dummy Location
Date & Time: Dummy Date & Time
Cause: Dummy Cause
More Info: Dummy More Info
''',
        sender: 'Dummy volunteer name',
        sentOn: '2023-02-20 14:30:00',
      ),
      ChatMessage(
        message: '''
NGO Name: Dummy NGO
Event Name: Dummy Event
Location: Dummy Location
Date & Time: Dummy Date & Time
Cause: Dummy Cause
More Info: Dummy More Info
''',
        sender: 'Dummy volunteer name',
        sentOn: '2023-02-20 14:30:00',
      ),
    ];
  }

  Future<void> sendMessage(String domainId, String message) async {
    // Send message logic here
    print('Message sent: $message');
  }
}
