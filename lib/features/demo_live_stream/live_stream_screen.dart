// lib/features/demo_live_stream/live_stream_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'live_stream_provider.dart';
import 'widgets/player_controls.dart';
import 'widgets/stream_url_selector.dart';

class LiveStreamScreen extends ConsumerStatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  ConsumerState<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends ConsumerState<LiveStreamScreen> {
  bool _showControls = true;
  late final VideoController _videoController;

  @override
  void initState() {
    super.initState();
    // 设置全屏模式
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // 初始化视频控制器
    final player = ref.read(mediaKitPlayerProvider);
    _videoController = VideoController(player);
  }

  @override
  void dispose() {
    // 停止播放器
    ref.read(liveStreamProvider.notifier).stop();
    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _showStreamSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const StreamUrlSelector(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streamState = ref.watch(liveStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // 视频播放器
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Video(
                  controller: _videoController,
                  controls: NoVideoControls,
                ),
              ),
            ),

            // 状态覆盖层
            _buildStatusOverlay(streamState),

            // 控制层
            if (_showControls) _buildControlsOverlay(streamState),

            // 顶部信息栏
            if (_showControls) _buildTopBar(streamState),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverlay(LiveStreamState state) {
    Widget? content;

    switch (state.status) {
      case PlayerStatus.idle:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.live_tv, size: 80, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              '点击下方按钮选择直播流',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showStreamSelector,
              icon: const Icon(Icons.play_arrow),
              label: const Text('选择直播流'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        );
        break;

      case PlayerStatus.loading:
        content = const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              '正在加载直播流...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        );
        break;

      case PlayerStatus.error:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? '播放失败',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showStreamSelector,
              icon: const Icon(Icons.refresh),
              label: const Text('重新选择'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
        break;

      default:
        break;
    }

    if (content == null) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(child: content),
    );
  }

  Widget _buildControlsOverlay(LiveStreamState state) {
    if (state.status != PlayerStatus.playing &&
        state.status != PlayerStatus.paused) {
      return const SizedBox.shrink();
    }

    return const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: PlayerControls(),
    );
  }

  Widget _buildTopBar(LiveStreamState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // 返回按钮
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),

              // 直播标识
              if (state.status == PlayerStatus.playing ||
                  state.status == PlayerStatus.paused)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // 切换流按钮
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: _showStreamSelector,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
