// lib/features/demo_live_stream/widgets/player_controls.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../live_stream_provider.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamState = ref.watch(liveStreamProvider);
    final streamNotifier = ref.read(liveStreamProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 音量控制
          if (streamState.status == PlayerStatus.playing ||
              streamState.status == PlayerStatus.paused)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.white),
                  Expanded(
                    child: Slider(
                      value: streamState.volume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                      onChanged: (value) {
                        streamNotifier.setVolume(value);
                      },
                    ),
                  ),
                ],
              ),
            ),

          // 播放/暂停按钮
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (streamState.status == PlayerStatus.playing)
                  IconButton(
                    icon: const Icon(Icons.pause_circle_filled, size: 64),
                    color: Colors.white,
                    onPressed: () => streamNotifier.pause(),
                  )
                else if (streamState.status == PlayerStatus.paused)
                  IconButton(
                    icon: const Icon(Icons.play_circle_filled, size: 64),
                    color: Colors.white,
                    onPressed: () => streamNotifier.resume(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
