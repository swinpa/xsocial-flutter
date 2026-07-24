import 'package:flutter/material.dart';

class RoomData {
  const RoomData({
    required this.name,
    required this.description,
    required this.tagLabel,
    required this.tagColor,
    required this.memberCount,
    required this.isLive,
  });

  final String name;
  final String description;
  final Color tagColor;
  final String tagLabel;
  final int memberCount;
  final bool isLive;
}

/// 房间列表卡片
/// 设计尺寸(CSS值×2): 宽343dp, 高88dp, 左右边距16dp
/// 头像: 70×70dp 圆角, 左边距24dp
/// 标签: 宽48dp, 高18dp, 圆角2dp
/// 小头像: 18×18dp 圆形
/// 进入按钮: 宽72dp, 高36dp, 圆角18dp
class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.data});
  final RoomData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 88,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo()),
            _buildEntryButton(),
          ],
        ),
      ),
    );
  }

  /// 头像 + 直播红点 (设计: 35→70dp, live indicator 8→16dp at top-left)
  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 70,
            height: 70,
            color: const Color(0xFFBDBDBD),
            child: const Icon(Icons.image_outlined, size: 32, color: Colors.white),
          ),
        ),
        if (data.isLive)
          Positioned(
            top: -4,
            left: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFF44336),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  /// 房间信息：名称、描述、标签、成员头像
  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 房间名称 (设计: font-size:8→16dp, weight:bold)
        Container(
          height: 16,
          color: const Color(0xFFE0E0E0), // 占位，实际为文字
          child: Text(
            data.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(11, 17, 20, 1),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        // 描述 (设计: font-size:6→12dp, color rgba(134,139,148,1))
        Text(
          data.description,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(134, 139, 148, 1),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildTag(),
            const SizedBox(width: 8),
            _buildMemberAvatars(),
          ],
        ),
      ],
    );
  }

  /// 房间类型标签 (设计: 24→48dp宽, 9→18dp高, 圆角)
  Widget _buildTag() {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: data.tagColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: data.tagColor.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Center(
        child: Text(
          data.tagLabel,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: data.tagColor,
          ),
        ),
      ),
    );
  }

  /// 成员小头像叠加 (设计: 9→18dp圆形, 间距9→18dp)
  Widget _buildMemberAvatars() {
    final count = data.memberCount.clamp(0, 4);
    return SizedBox(
      width: 18.0 + (count - 1) * 12.0,
      height: 18,
      child: Stack(
        children: List.generate(count, (i) => Positioned(
          left: i * 12.0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFBDBDBD),
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),
        )),
      ),
    );
  }

  /// 进入按钮 (设计: Rectangle3465089 18→36dp高)
  Widget _buildEntryButton() {
    return Container(
      width: 72,
      height: 36,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromRGBO(17, 216, 195, 1), Color.fromRGBO(0, 188, 212, 1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: Text(
          'Enter',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
