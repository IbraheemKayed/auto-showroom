import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:svg_flutter/svg.dart';

class CarPhotosScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onMessageDealer;

  const CarPhotosScreen({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onMessageDealer,
  });

  @override
  State<CarPhotosScreen> createState() => _CarPhotosScreenState();
}

class _CarPhotosScreenState extends State<CarPhotosScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _ctrl;
  late int _current;
  late bool _isFavorite;
  late final List<PhotoViewController> _viewControllers;

  // Swipe-to-dismiss state
  double _dragY = 0.0;
  int _pointerCount = 0;
  bool _dismissing = false;
  late final AnimationController _snapCtrl;
  late Animation<double> _snapAnim;

  bool get _isZoomed {
    final s = _viewControllers[_current].scale;
    return s != null && s > 1.05;
  }

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _isFavorite = widget.isFavorite;
    _ctrl = PageController(initialPage: widget.initialIndex);
    _viewControllers = List.generate(
      widget.images.length,
      (_) => PhotoViewController(),
    );
    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    for (final c in _viewControllers) {
      c.dispose();
    }
    _snapCtrl.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent e) => _pointerCount++;

  void _onPointerUp(PointerUpEvent e) {
    _pointerCount = max(0, _pointerCount - 1);
    if (_pointerCount == 0 && !_dismissing) {
      if (_dragY > 130 || (_dragY > 40 && e.delta.dy > 6)) {
        _dismissing = true;
        Navigator.pop(context);
      } else {
        _snapAnim = Tween<double>(begin: _dragY, end: 0).animate(
          CurvedAnimation(parent: _snapCtrl, curve: Curves.easeOut),
        )..addListener(() => setState(() => _dragY = _snapAnim.value));
        _snapCtrl.forward(from: 0);
      }
    }
  }

  void _onPointerCancel(PointerCancelEvent e) {
    _pointerCount = max(0, _pointerCount - 1);
    if (!_dismissing) {
      setState(() => _dragY = 0);
    }
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (_dismissing || _pointerCount != 1 || _isZoomed) return;
    final newY = _dragY + e.delta.dy;
    if (newY > 0) {
      setState(() => _dragY = newY);
    } else if (_dragY > 0) {
      setState(() => _dragY = 0);
    }
  }

  Widget _circleButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0x66000000),
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dismissProgress = (_dragY / 300).clamp(0.0, 1.0);

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      onPointerMove: _onPointerMove,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 1.0 - dismissProgress * 0.6),
        body: Transform.translate(
          offset: Offset(0, _dragY),
          child: Stack(
            children: [
              // ── Gallery ──
              PhotoViewGallery.builder(
                pageController: _ctrl,
                itemCount: widget.images.length,
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 1.0 - dismissProgress * 0.6),
                ),
                onPageChanged: (i) => setState(() => _current = i),
                loadingBuilder: (_, __) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0066EE),
                    strokeWidth: 2.5,
                  ),
                ),
                builder: (context, i) {
                  return PhotoViewGalleryPageOptions(
                    controller: _viewControllers[i],
                    imageProvider: CachedNetworkImageProvider(widget.images[i]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 4,
                    heroAttributes: PhotoViewHeroAttributes(tag: widget.images[i]),
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
                    ),
                  );
                },
              ),

              // ── Top bar ──
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _circleButton(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                      const Spacer(),
                      Text(
                        '${_current + 1}/${widget.images.length}',
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const Spacer(),
                      if (!(context.read<AuthProvider>().user?.isDealer ?? false))
                        _circleButton(
                          onTap: () {
                            widget.onToggleFavorite();
                            setState(() => _isFavorite = !_isFavorite);
                          },
                          child: Center(
                            child: SvgPicture.asset(
                              _isFavorite
                                  ? 'assets/images/heart_on.svg'
                                  : 'assets/images/heart.svg',
                              width: 20,
                              height: 20,
                              colorFilter: _isFavorite
                                  ? null
                                  : const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Dots + Message button ──
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.images.length > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.images.length, (i) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _current == i ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _current == i ? Colors.white : Colors.white38,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: GestureDetector(
                          onTap: widget.onMessageDealer,
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066EE),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 11.91,
                                  offset: const Offset(0, 5.95),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.messageDealer,
                                  style: const TextStyle(
                                    fontFamily: 'FunnelDisplay',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
