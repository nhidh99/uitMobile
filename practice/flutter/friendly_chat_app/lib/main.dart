import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(FriendlychatApp());

// IOS Theme
final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
);

// Android Theme
final ThemeData kAndroidTheme = new ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent[400],
);

class FriendlychatApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: "Friendlychat",
            theme: defaultTargetPlatform == TargetPlatform.iOS
                ? kIOSTheme
                : kAndroidTheme,
            home: new ChatScreen(),
        );
    }
}

class ChatScreen extends StatefulWidget {
    @override
    State createState() => new ChatScreenState();
}

// Khung chat chính
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
    final TextEditingController textController = new TextEditingController();
    final List<ChatMessage> messages = <ChatMessage>[];

    // Gửi tin nhắn
    void handleSubmitted(String text) {
        if (text.trim().isEmpty) return;
        textController.clear();
        var message = new ChatMessage(
            text: text.trim(),
            animationController: new AnimationController(
                duration: new Duration(milliseconds: 250), vsync: this));
        setState(() {
            messages.insert(0, message);
        });
        message.animationController.forward();
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("My Messenger"),
                elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
            body: new Column(
                children: <Widget>[
                    new Flexible(
                        child: new ListView.builder(
                            padding: new EdgeInsets.all(15.0),
                            reverse: true,
                            itemBuilder: (_, int index) => messages[index],
                            itemCount: messages.length,
                        ),
                    ),
                    new Divider(height: 1.0),
                    new Container(
                        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
                        child: buildTextComposer(),
                    ),
                ],
            ),
        );
    }

    // Khung soạn tin nhắn
    Widget buildTextComposer() {
        return new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: new Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Row(
                    children: <Widget>[
                        new Flexible(
                            child: new TextField(
                                controller: textController,
                                onSubmitted: (text) => handleSubmitted(text),
                                decoration: new InputDecoration.collapsed(
                                    hintText: "Nhập tin nhắn"),
                            ),
                        ),
                        new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 4.0),
                            child: new IconButton(
                                icon: new Icon(Icons.send),
                                onPressed: () => handleSubmitted(textController.text)),
                        ),
                    ],
                )));
    }

    // Huỷ animation sau khi load xong tin
    @override
    void dispose() {
        for (ChatMessage message in messages) {
            message.animationController.dispose();
        }
        super.dispose();
    }
}

// Tin nhắn (avatar + tên + nội dung)
class ChatMessage extends StatelessWidget {
    ChatMessage({this.text, this.animationController});

    final String text;
    final String name = "Nhi Đinh";
    final AnimationController animationController;

    @override
    Widget build(BuildContext context) {
        return new SizeTransition(
            sizeFactor: new CurvedAnimation(
                parent: animationController, curve: Curves.easeOut),
            axisAlignment: 0.0,
            child: new Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        new Container(
                            margin: const EdgeInsets.only(right: 16.0),
                            child: new CircleAvatar(child: new Text(name[0])),
                        ),
                        new Expanded(
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    new Text(name, style: Theme.of(context).textTheme.subhead),
                                    new Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: new Text(text),
                                    ),
                                ],
                            ),
                        )
                    ],
                ),
            ));
    }
}
