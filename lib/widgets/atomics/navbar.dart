import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavbar extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool showNavBar;

  const BottomNavbar({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onTap,
    this.showNavBar = true,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color activeColor = theme.colorScheme.primary;
    final Color inactiveColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          widget.child,

          if (_isExpanded)
            Positioned(
              bottom: 110,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  _buildActionItem(
                    MingCute.calendar_fill,
                    'Mahlzeitenplan anlegen',
                    () {},
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem(
                    MingCute.fork_knife_fill,
                    'Rezept anlegen',
                    () {},
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem(
                    MingCute.shopping_cart_2_fill,
                    'Einkaufsliste anlegen',
                    () {},
                    theme,
                  ),
                ],
              ),
            ),
        ],
      ),

      bottomNavigationBar:
          widget.showNavBar
              ? SafeArea(
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: MingCute.calendar_fill,
                        label: 'Plan',
                        index: 0,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                      _buildNavItem(
                        icon: MingCute.fork_knife_fill,
                        label: 'Rezepte',
                        index: 1,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: FloatingActionButton(
                          onPressed: _toggleExpanded,
                          backgroundColor: activeColor,
                          elevation: 2,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildNavItem(
                        icon: MingCute.shopping_cart_2_fill,
                        label: 'Einkauf',
                        index: 2,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                      _buildNavItem(
                        icon: MingCute.user_2_fill,
                        label: 'Profil',
                        index: 3,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ],
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = widget.selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: activeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        _toggleExpanded();
        onTap();
      },
      child: Container(
        height: 64,
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            // ✅ Added border here
            color: theme.colorScheme.surfaceBright,
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceBright,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
