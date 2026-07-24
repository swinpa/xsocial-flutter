import 'dart:async';
import 'package:flutter/material.dart';
import 'room_card.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({super.key});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  int _subtabIndex = 1;

  // Banner 轮播
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerPage = 0;

  // Top Stars 垂直轮播
  Timer? _starsTimer;
  int _currentStarPage = 0;

  static const _bannerItems = [
    _BannerData(color: Color(0xFFB3E5FC), label: 'Event · Summer Party'),
    _BannerData(color: Color(0xFFD1C4E9), label: 'SVIP · Exclusive Perks'),
    _BannerData(color: Color(0xFFC8E6C9), label: 'Top Stars · This Week'),
  ];

  // Top Stars 模拟数据
  static const _stars = [
    _StarData(name: 'Luna Sky', followers: '128k'),
    _StarData(name: 'Max Wave', followers: '96k'),
    _StarData(name: 'Aria Song', followers: '84k'),
    _StarData(name: 'Zara Moon', followers: '72k'),
    _StarData(name: 'Jake Fire', followers: '61k'),
    _StarData(name: 'Mia Star', followers: '55k'),
  ];

  // 房间数据
  static final _rooms = [
    RoomData(name: 'Chill Vibes Zone', description: "Don't seek happiness-create it...", tagLabel: '游戏', tagColor: const Color.fromRGBO(70, 114, 255, 1), memberCount: 4, isLive: true),
    RoomData(name: 'Night Owl Squad', description: "Don't seek happiness-create it...", tagLabel: '朋友', tagColor: const Color.fromRGBO(255, 191, 0, 1), memberCount: 3, isLive: true),
    RoomData(name: 'Gaming Corner', description: "Don't seek happiness-create it...", tagLabel: '游戏', tagColor: const Color.fromRGBO(70, 114, 255, 1), memberCount: 4, isLive: true),
    RoomData(name: 'Friends Hangout', description: "Don't seek happiness-create it...", tagLabel: '游戏', tagColor: const Color.fromRGBO(70, 114, 255, 1), memberCount: 2, isLive: false),
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBannerPage + 1) % _bannerItems.length;
      _bannerController.animateToPage(next, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    });
    _starsTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() => _currentStarPage = (_currentStarPage + 1) % _stars.length);
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _starsTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildBanner(),
              _buildTopStars(),
              ...List.generate(_rooms.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RoomCard(data: _rooms[i]),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _SubTab(label: 'Me', isActive: _subtabIndex == 0, onTap: () => setState(() => _subtabIndex = 0)),
          const SizedBox(width: 16),
          _SubTab(label: 'Recommend', isActive: _subtabIndex == 1, onTap: () => setState(() => _subtabIndex = 1)),
          const SizedBox(width: 16),
          _SubTab(label: 'Hot', isActive: _subtabIndex == 2, onTap: () => setState(() => _subtabIndex = 2)),
          const Spacer(),
          GestureDetector(onTap: () {}, child: const Icon(Icons.search, size: 24, color: Color.fromRGBO(11, 17, 20, 1))),
          const SizedBox(width: 16),
          GestureDetector(onTap: () {}, child: const Icon(Icons.notifications_none, size: 24, color: Color.fromRGBO(11, 17, 20, 1))),
        ],
      ),
    );
  }

  /// Banner: PageView 横向轮播 + 圆点指示器
  /// 设计: height:95dp, 圆角12dp, 自动3秒切页
  Widget _buildBanner() {
    return SizedBox(
      height: 95,
      child: Stack(
        children: [
          PageView.builder(
            controller: _bannerController,
            itemCount: _bannerItems.length,
            onPageChanged: (i) => setState(() => _currentBannerPage = i),
            itemBuilder: (context, i) {
              final item = _bannerItems[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: item.color,
                    child: Center(
                      child: Text(
                        item.label,
                        style: const TextStyle(fontSize: 14, color: Color.fromRGBO(11, 17, 20, 1)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // 圆点指示器
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_bannerItems.length, (i) {
                final isActive = i == _currentBannerPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isActive ? 14 : 6,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color.fromRGBO(17, 216, 195, 1)
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Top Stars: 固定高度容器 + 垂直方向 PageView 自动轮播
  /// 每2秒自动上翻一条，循环播放
  Widget _buildTopStars() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.star_rounded, size: 16, color: Color.fromRGBO(255, 191, 0, 1)),
          const SizedBox(width: 6),
          const Text(
            'Top Stars',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color.fromRGBO(11, 17, 20, 1)),
          ),
          const SizedBox(width: 12),
          // 垂直分隔线
          Container(width: 0.5, height: 16, color: const Color(0xFFE0E0E0)),
          const SizedBox(width: 12),
          // 垂直轮播区域
          Expanded(
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
                child: _buildStarItem(_stars[_currentStarPage]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarItem(_StarData star) {
    return Row(
      key: ValueKey(star.name),
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFBDBDBD)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            star.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromRGBO(11, 17, 20, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          star.followers,
          style: const TextStyle(fontSize: 11, color: Color.fromRGBO(134, 139, 148, 1)),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────
// 数据模型
// ──────────────────────────────────────────────────────

class _BannerData {
  const _BannerData({required this.color, required this.label});
  final Color color;
  final String label;
}

class _StarData {
  const _StarData({required this.name, required this.followers});
  final String name;
  final String followers;
}

// ──────────────────────────────────────────────────────
// 子组件
// ──────────────────────────────────────────────────────


/// 顶部子 tab
class _SubTab extends StatelessWidget {
  const _SubTab({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? const Color.fromRGBO(11, 17, 20, 1) : const Color.fromRGBO(134, 139, 148, 1),
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 3),
            Container(
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(17, 216, 195, 1),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
