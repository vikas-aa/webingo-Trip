import 'package:flutter/material.dart';

class TripBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TripBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 26,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: Icons.flight_outlined,
                activeIcon: Icons.flight_rounded,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: Icons.map_outlined,
                activeIcon: Icons.map_rounded,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: Icons.person_outline,
                activeIcon: Icons.person_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.icon,
    required this.activeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: isActive ? 44 : 24,
            height: isActive ? 44 : 24,
          
            child: Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive
                  ? const Color(0xFF0B61FF)
                  : Colors.black.withOpacity(0.35),
            ),
          ),
        ),
      ),
    );
  }
}