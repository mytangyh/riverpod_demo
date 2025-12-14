// lib/features/demo_live_stream/live_stream_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'live_stream_provider.dart';
import 'widgets/action_buttons.dart';
import 'widgets/live_chat.dart';
import 'widgets/streamer_info.dart';
import 'widgets/stream_url_selector.dart';

class LiveStreamScreen extends ConsumerStatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  ConsumerState<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends ConsumerState<LiveStreamScreen> {
  late final VideoController _videoController;
  bool _isFollowing = false;
  bool _isLiked = false;
  int _likeCount = 12580;
  final int _viewerCount = 23456;

  // Mock 主播数据
  final _streamerName = '直播达人';
  final _streamerAvatar = '';
  final int _followerCount = 156800;

  @override
  void initState() {
    super.initState();
    // 设置全屏沉浸模式
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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

  void _showStreamSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const StreamUrlSelector(),
    );
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  void _handleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamState = ref.watch(liveStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: _handleLike,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 全屏视频播放器
            _buildVideoPlayer(streamState),

            // 渐变遮罩层
            _buildGradientOverlay(),

            // 顶部状态栏
            _buildTopBar(),

            // 右侧操作按钮
            _buildActionButtons(),

            // 左下角主播信息
            _buildStreamerInfo(),

            // 底部弹幕区
            _buildLiveChat(),

            // 状态提示 (加载中/错误)
            if (streamState.status == PlayerStatus.idle ||
                streamState.status == PlayerStatus.loading ||
                streamState.status == PlayerStatus.error)
              _buildStatusOverlay(streamState),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(LiveStreamState state) {
    return SizedBox.expand(
      child: Video(
        controller: _videoController,
        controls: NoVideoControls,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
              stops: const [0.0, 0.15, 0.7, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // 观看人数
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(_viewerCount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 选择流按钮
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.playlist_play,
                      color: Colors.white, size: 22),
                ),
                onPressed: _showStreamSelector,
              ),
              // 关闭按钮
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      right: 12,
      bottom: 280,
      child: ActionButtons(
        avatarUrl: _streamerAvatar,
        likeCount: _likeCount,
        commentCount: 2345,
        isLiked: _isLiked,
        onAvatarTap: _handleFollow,
        onLikeTap: _handleLike,
        onCommentTap: () {},
        onShareTap: () {},
        onGiftTap: () {},
      ),
    );
  }

  Widget _buildStreamerInfo() {
    return Positioned(
      left: 12,
      bottom: 210,
      child: StreamerInfo(
        name: _streamerName,
        avatarUrl: _streamerAvatar,
        followerCount: _followerCount,
        isFollowing: _isFollowing,
        onFollowTap: _handleFollow,
      ),
    );
  }

  Widget _buildLiveChat() {
    return const Positioned(
      left: 0,
      right: 80,
      bottom: 20,
      child: LiveChat(),
    );
  }

  Widget _buildStatusOverlay(LiveStreamState state) {
    Widget? content;

    switch (state.status) {
      case PlayerStatus.idle:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.live_tv, size: 70, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              '选择一个直播间开始观看',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showStreamSelector,
              icon: const Icon(Icons.play_arrow),
              label: const Text('选择直播'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.pink,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '正在连接直播间...',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        );
        break;

      case PlayerStatus.error:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off, size: 70, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? '直播加载失败',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showStreamSelector,
              icon: const Icon(Icons.refresh),
              label: const Text('重新选择'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
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

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(child: content),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
