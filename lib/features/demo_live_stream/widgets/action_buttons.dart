// lib/features/demo_live_stream/widgets/action_buttons.dart
import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final String avatarUrl;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onGiftTap;

  const ActionButtons({
    super.key,
    required this.avatarUrl,
    required this.likeCount,
    required this.commentCount,
    this.isLiked = false,
    this.onAvatarTap,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
    this.onGiftTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主播头像
        _buildAvatarButton(),
        const SizedBox(height: 20),
        // 点赞
        _buildActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.white,
          label: _formatCount(likeCount),
          onTap: onLikeTap,
        ),
        const SizedBox(height: 20),
        // 评论
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: _formatCount(commentCount),
          onTap: onCommentTap,
        ),
        const SizedBox(height: 20),
        // 分享
        _buildActionButton(
          icon: Icons.share,
          label: '分享',
          onTap: onShareTap,
        ),
        const SizedBox(height: 20),
        // 礼物
        _buildGiftButton(),
      ],
    );
  }

  Widget _buildAvatarButton() {
    return GestureDetector(
      onTap: onAvatarTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
          // + 关注标识
          Positioned(
            bottom: -6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftButton() {
    return GestureDetector(
      onTap: onGiftTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.card_giftcard, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 4),
          const Text(
            '礼物',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
