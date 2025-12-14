// lib/features/demo_live_stream/live_stream_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

// 播放器状态枚举
enum PlayerStatus {
  idle,
  loading,
  playing,
  paused,
  error,
}

// 播放器状态数据类
class LiveStreamState {
  final PlayerStatus status;
  final String? errorMessage;
  final String currentUrl;
  final double volume;
  final bool isFullscreen;

  const LiveStreamState({
    this.status = PlayerStatus.idle,
    this.errorMessage,
    this.currentUrl = '',
    this.volume = 1.0,
    this.isFullscreen = false,
  });

  LiveStreamState copyWith({
    PlayerStatus? status,
    String? errorMessage,
    String? currentUrl,
    double? volume,
    bool? isFullscreen,
  }) {
    return LiveStreamState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentUrl: currentUrl ?? this.currentUrl,
      volume: volume ?? this.volume,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }
}

// 播放器状态管理器
class LiveStreamNotifier extends StateNotifier<LiveStreamState> {
  final Player player;

  LiveStreamNotifier(this.player) : super(const LiveStreamState()) {
    _initPlayer();
  }

  void _initPlayer() {
    // 监听播放器状态变化
    player.stream.playing.listen((isPlaying) {
      if (isPlaying) {
        state =
            state.copyWith(status: PlayerStatus.playing, errorMessage: null);
      } else if (state.status == PlayerStatus.playing) {
        state = state.copyWith(status: PlayerStatus.paused);
      }
    });

    player.stream.buffering.listen((isBuffering) {
      if (isBuffering && state.status != PlayerStatus.playing) {
        state = state.copyWith(status: PlayerStatus.loading);
      }
    });

    player.stream.error.listen((error) {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: '播放失败: $error',
      );
    });

    player.stream.volume.listen((vol) {
      state = state.copyWith(volume: vol / 100.0);
    });
  }

  // 播放指定URL的直播流
  Future<void> playStream(String url) async {
    try {
      state = state.copyWith(
        status: PlayerStatus.loading,
        currentUrl: url,
        errorMessage: null,
      );

      await player.open(Media(url));
      await player.play();
    } catch (e) {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: '无法加载直播流: $e',
      );
    }
  }

  // 暂停播放
  Future<void> pause() async {
    await player.pause();
  }

  // 继续播放
  Future<void> resume() async {
    await player.play();
  }

  // 停止播放
  Future<void> stop() async {
    await player.stop();
    state = state.copyWith(status: PlayerStatus.idle, currentUrl: '');
  }

  // 设置音量 (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    await player.setVolume(volume * 100.0); // media_kit uses 0-100
    state = state.copyWith(volume: volume);
  }

  // 切换全屏
  void toggleFullscreen() {
    state = state.copyWith(isFullscreen: !state.isFullscreen);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

// 创建播放器实例的 Provider
final mediaKitPlayerProvider = Provider<Player>((ref) {
  final player = Player();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
});

// 直播流状态管理 Provider
final liveStreamProvider =
    StateNotifierProvider<LiveStreamNotifier, LiveStreamState>((ref) {
  final player = ref.watch(mediaKitPlayerProvider);
  return LiveStreamNotifier(player);
});

// 预设的测试直播流 URL
final testStreamUrlsProvider = Provider<List<StreamOption>>((ref) {
  return [
    StreamOption(
      name: 'HLS 测试流 (Apple)',
      url: 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
      type: StreamType.hls,
    ),
    StreamOption(
      name: 'HLS 测试流 (Big Buck Bunny)',
      url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      type: StreamType.hls,
    ),
    StreamOption(
      name: 'HLS 测试流 (西瓜)',
      url:
          'https://sf1-cdn-tos.huoshanstatic.com/obj/media-fe/xgplayer_doc_video/hls/xgplayer-demo.m3u8',
      type: StreamType.hls,
    ),
    StreamOption(
      name: 'RTMP 测试流',
      url: 'rtmp://ns8.indexforce.com/home/mystream',
      type: StreamType.rtmp,
    ),
  ];
});

// 流选项数据类
class StreamOption {
  final String name;
  final String url;
  final StreamType type;

  StreamOption({
    required this.name,
    required this.url,
    required this.type,
  });
}

enum StreamType {
  hls,
  rtmp,
  flv,
}
