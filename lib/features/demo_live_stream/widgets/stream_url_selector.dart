// lib/features/demo_live_stream/widgets/stream_url_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../live_stream_provider.dart';

class StreamUrlSelector extends ConsumerStatefulWidget {
  const StreamUrlSelector({super.key});

  @override
  ConsumerState<StreamUrlSelector> createState() => _StreamUrlSelectorState();
}

class _StreamUrlSelectorState extends ConsumerState<StreamUrlSelector> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testStreams = ref.watch(testStreamUrlsProvider);
    final streamNotifier = ref.read(liveStreamProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '选择直播流',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 预设流列表
          const Text(
            '测试流',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...testStreams.map((stream) => _buildStreamOption(
                context,
                stream,
                () {
                  streamNotifier.playStream(stream.url);
                  Navigator.pop(context);
                },
              )),

          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),

          // 自定义URL输入
          const Text(
            '自定义流地址',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '输入 RTMP/HLS/HTTP-FLV 地址',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  if (_urlController.text.isNotEmpty) {
                    streamNotifier.playStream(_urlController.text);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStreamOption(
    BuildContext context,
    StreamOption stream,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getIconForStreamType(stream.type),
          color: Colors.white,
        ),
        title: Text(
          stream.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          stream.url,
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.play_circle_outline, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconForStreamType(StreamType type) {
    switch (type) {
      case StreamType.hls:
        return Icons.stream;
      case StreamType.rtmp:
        return Icons.live_tv;
      case StreamType.flv:
        return Icons.video_library;
    }
  }
}
