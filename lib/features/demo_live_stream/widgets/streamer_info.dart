// lib/features/demo_live_stream/widgets/streamer_info.dart
import 'package:flutter/material.dart';

class StreamerInfo extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final int followerCount;
  final bool isFollowing;
  final VoidCallback? onFollowTap;

  const StreamerInfo({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.followerCount,
    this.isFollowing = false,
    this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 头像
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[800],
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(width: 10),
          // 昵称和粉丝数
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_formatCount(followerCount)} 粉丝',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // 关注按钮
          GestureDetector(
            onTap: onFollowTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isFollowing ? Colors.grey[700] : Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                isFollowing ? '已关注' : '+关注',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    }
    return count.toString();
  }
}
