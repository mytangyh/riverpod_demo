// lib/features/demo_live_stream/widgets/live_chat.dart
import 'package:flutter/material.dart';
import 'dart:async';

class ChatMessage {
  final String username;
  final String message;
  final bool isVip;

  const ChatMessage({
    required this.username,
    required this.message,
    this.isVip = false,
  });
}

class LiveChat extends StatefulWidget {
  final List<ChatMessage> initialMessages;

  const LiveChat({
    super.key,
    this.initialMessages = const [],
  });

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  Timer? _simulationTimer;
  int _messageIndex = 0;

  // 模拟弹幕数据
  static const List<ChatMessage> _mockMessages = [
    ChatMessage(username: '追光少年', message: '主播太厉害了！👏'),
    ChatMessage(username: 'VIP用户', message: '来了来了！', isVip: true),
    ChatMessage(username: '小明同学', message: '666666'),
    ChatMessage(username: '快乐星球', message: '欢迎新来的朋友'),
    ChatMessage(username: 'SuperFan', message: '第一次看直播，好激动', isVip: true),
    ChatMessage(username: '阳光灿烂', message: '主播加油！'),
    ChatMessage(username: '代码达人', message: 'Flutter真香'),
    ChatMessage(username: '夜猫子', message: '刚下班就来看你'),
    ChatMessage(username: '技术宅', message: '学到了学到了'),
    ChatMessage(username: '小白兔', message: '主播声音好好听'),
    ChatMessage(username: '漫步云端', message: '直播效果不错'),
    ChatMessage(username: '热爱生活', message: '送上小心心❤️'),
  ];

  @override
  void initState() {
    super.initState();
    _messages.addAll(widget.initialMessages);
    // 模拟实时弹幕
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _messages.add(_mockMessages[_messageIndex % _mockMessages.length]);
          _messageIndex++;
          // 保持最多显示20条
          if (_messages.length > 20) {
            _messages.removeAt(0);
          }
        });
        // 滚动到底部
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.white, Colors.white],
            stops: [0.0, 0.3, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final msg = _messages[index];
            return _buildChatItem(msg);
          },
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    // VIP 标识
                    if (msg.isVip)
                      WidgetSpan(
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.orange, Colors.pink],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'VIP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // 用户名
                    TextSpan(
                      text: '${msg.username}: ',
                      style: TextStyle(
                        color: msg.isVip ? Colors.orange : Colors.cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // 消息内容
                    TextSpan(
                      text: msg.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
