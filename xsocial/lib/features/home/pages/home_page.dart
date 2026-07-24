import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/room_list_view.dart';

/*
设计稿: 蓝湖 hiplay社交2 / 首页-推荐 (image_id=9447353a)
设计帧 187.5×406px @0.5x → 实际dp = CSS值 × 2
颜色标记:
  主色青绿: Color.fromRGBO(17, 216, 195, 1)
  游戏标签: Color.fromRGBO(70, 114, 255, 1)
  朋友标签: Color.fromRGBO(255, 191, 0, 1)
  文字主色: Color.fromRGBO(11, 17, 20, 1)
  文字灰色: Color.fromRGBO(134, 139, 148, 1)
  Tab未选中: Color.fromRGBO(153, 153, 153, 1)
  底栏阴影: box-shadow 0 -2px 6px rgba(0,0,0,0.05)
*/
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedTab = 1; // 默认 Room tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedTab,
          children: const [
            _PlaceholderPage(label: 'HiPlay'),
            RoomListView(),
            _PlaceholderPage(label: 'Message'),
            _PlaceholderPage(label: 'Profile'),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedTab,
        onChanged: (i) => setState(() => _selectedTab = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onChanged});
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(icon: Icons.home_outlined, label: 'HiPlay', index: 0, selected: selectedIndex, onTap: onChanged),
              _NavItem(icon: Icons.headphones_outlined, label: 'Room', index: 1, selected: selectedIndex, onTap: onChanged),
              _NavItem(icon: Icons.chat_bubble_outline, label: 'Message', index: 2, selected: selectedIndex, onTap: onChanged),
              _NavItem(icon: Icons.person_outline, label: 'Profile', index: 3, selected: selectedIndex, onTap: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;

  static const _activeColor = Color.fromRGBO(17, 216, 195, 1);
  static const _inactiveColor = Color.fromRGBO(153, 153, 153, 1);

  @override
  Widget build(BuildContext context) {
    final isActive = index == selected;
    final color = isActive ? _activeColor : _inactiveColor;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Color.fromRGBO(134, 139, 148, 1)),
      ),
    );
  }
}
