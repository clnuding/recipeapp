import 'package:flutter/material.dart';

class BottomModal extends StatefulWidget {
  final bool isOpen;
  final Widget header;
  final VoidCallback? onDismiss;

  const BottomModal({
    super.key,
    required this.isOpen,
    required this.header,
    this.onDismiss,
  });
  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  bool _hasShown = false;

  @override
  void didUpdateWidget(BottomModal old) {
    super.didUpdateWidget(old);
    // only show once when isOpen flips true
    if (!_hasShown && !old.isOpen && widget.isOpen) {
      _hasShown = true;
      _showSheet();
    }
  }

  Future<void> _showSheet() async {
    await showModalBottomSheet(
      context: context,
      elevation: 10,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // header
                widget.header,
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
    widget.onDismiss?.call();
    _hasShown = false;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
