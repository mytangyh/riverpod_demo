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
  late final PageController _pageController;

  int _currentIndex = 0;
  bool _isFollowing = false;
  bool _isLiked = false;
  int _likeCount = 12580;

  // Mock 主播数据列表
  final List<StreamerData> _streamers = [
    StreamerData(
      name: '直播达人',
      avatar: '',
      followerCount: 156800,
      viewerCount: 23456,
      streamUrl:
          'https://sf1-cdn-tos.huoshanstatic.com/obj/media-fe/xgplayer_doc_video/hls/xgplayer-demo.m3u8',
    ),
    StreamerData(
      name: '游戏高手',
      avatar: '',
      followerCount: 89600,
      viewerCount: 8765,
      streamUrl:
          'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
    ),
    StreamerData(
      name: '音乐主播',
      avatar: '',
      followerCount: 234500,
      viewerCount: 45678,
      streamUrl: 'rtmp://ns8.indexforce.com/home/mystream',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 设置全屏沉浸模式
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 初始化视频控制器
    final player = ref.read(mediaKitPlayerProvider);
    _videoController = VideoController(player);

    // 初始化 PageController - 使用更流畅的动画参数
    _pageController = PageController(
      viewportFraction: 1.0,
    );

    // 自动播放第一个流
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playStream(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // 停止播放器
    ref.read(liveStreamProvider.notifier).stop();
    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _playStream(int index) {
    final streamer = _streamers[index];
    ref.read(liveStreamProvider.notifier).playStream(streamer.streamUrl);
    setState(() {
      _currentIndex = index;
      _isLiked = false;
      _likeCount = 12580 + index * 1000;
      _isFollowing = false;
    });
  }

  void _onPageChanged(int index) {
    _playStream(index);
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
    final currentStreamer = _streamers[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // PageView 实现上下滑动 - 使用流畅的滑动动画
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: _streamers.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: _handleLike,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 视频播放器 (只在当前页面显示)
                    if (index == _currentIndex)
                      _buildVideoPlayer(streamState)
                    else
                      Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink.withOpacity(0.5),
                          ),
                        ),
                      ),

                    // 渐变遮罩层
                    _buildGradientOverlay(),
                  ],
                ),
              );
            },
          ),

          // 顶部状态栏 (固定)
          _buildTopBar(currentStreamer),

          // 右侧操作按钮 (固定)
          _buildActionButtons(currentStreamer),

          // 左下角主播信息 (固定)
          _buildStreamerInfo(currentStreamer),

          // 底部弹幕区 (固定)
          _buildLiveChat(),

          // 滑动提示
          _buildSwipeHint(),

          // 状态提示 (加载中/错误)
          if (streamState.status == PlayerStatus.loading ||
              streamState.status == PlayerStatus.error)
            _buildStatusOverlay(streamState),
        ],
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

  Widget _buildTopBar(StreamerData streamer) {
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
                      _formatCount(streamer.viewerCount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 当前直播间序号
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_streamers.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
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

  Widget _buildActionButtons(StreamerData streamer) {
    return Positioned(
      right: 12,
      bottom: 280,
      child: ActionButtons(
        avatarUrl: streamer.avatar,
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

  Widget _buildStreamerInfo(StreamerData streamer) {
    return Positioned(
      left: 12,
      bottom: 210,
      child: StreamerInfo(
        name: streamer.name,
        avatarUrl: streamer.avatar,
        followerCount: streamer.followerCount,
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

  Widget _buildSwipeHint() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height / 2 - 30,
      child: Column(
        children: [
          Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white.withOpacity(0.5),
            size: 30,
          ),
          Text(
            '滑动',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
          Text(
            '切换',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withOpacity(0.5),
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOverlay(LiveStreamState state) {
    Widget? content;

    if (state.status == PlayerStatus.loading) {
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
    } else if (state.status == PlayerStatus.error) {
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
          const SizedBox(height: 16),
          const Text(
            '上下滑动切换其他直播间',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      );
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

// 主播数据类
class StreamerData {
  final String name;
  final String avatar;
  final int followerCount;
  final int viewerCount;
  final String streamUrl;

  const StreamerData({
    required this.name,
    required this.avatar,
    required this.followerCount,
    required this.viewerCount,
    required this.streamUrl,
  });
}
