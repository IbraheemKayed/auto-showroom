import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/dealer/models/upload_image_model.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class AddPostImageReviewScreen extends StatefulWidget {
  const AddPostImageReviewScreen({super.key});

  @override
  State<AddPostImageReviewScreen> createState() =>
      _AddPostImageReviewScreenState();
}

class _AddPostImageReviewScreenState extends State<AddPostImageReviewScreen> {
  bool _isReordering = false;

  late List<UploadingCarImage> _additionalImages;

  @override
  void initState() {
    super.initState();
    final create = context.read<CreateCarProvider>();
    _additionalImages =
        create.images.where((e) => !e.isCover).toList();
  }

  void _swapItems(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    setState(() {
      final item = _additionalImages.removeAt(fromIndex);
      _additionalImages.insert(toIndex, item);
    });
  }

  void _confirm() {
    context.read<CreateCarProvider>().applyImageOrder(_additionalImages);
    Navigator.pushNamed(context, '/description');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final create = context.watch<CreateCarProvider>();
    final cover = create.images.isEmpty
        ? null
        : create.images.firstWhere(
            (e) => e.isCover,
            orElse: () => create.images.first,
          );

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== App Bar =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),
                    Text(
                      l.questions4of5,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 4 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066EE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        children: [
          // ===== HEADER =====
          Text(
            l.step2,
            style: const TextStyle(
              color: Color(0xFF0066EE),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.checkAndConfirmPhotos,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l.reviewOrChangeImages,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // ===== COVER IMAGE =====
          Text(
            l.coverImage,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 10),
          _buildCoverImage(cover),

          const SizedBox(height: 20),

          // ===== ADDITIONAL HEADER =====
          Row(
            children: [
              Text(
                l.additionalImages,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(width: 8),
              Text(
                '${_additionalImages.length} ${l.totalImages}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _isReordering = !_isReordering),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isReordering) ...[
                        const Icon(Icons.grid_view_rounded, size: 14),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        _isReordering ? l.done : l.reorder,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ===== INFO BANNER (reorder mode only) =====
          if (_isReordering) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18, color: Colors.black54),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.howDoIDo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.dragImageToReposition,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ===== IMAGE GRID =====
          _isReordering
              ? _buildReorderableGrid()
              : _buildStaticGrid(),

          const SizedBox(height: 20),
        ],
      ),

      // ===== CONFIRM BUTTON =====
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066EE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                l.confirm,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== COVER IMAGE =====
  Widget _buildCoverImage(UploadingCarImage? cover) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: Stack(
        children: [
          if (cover != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(cover.file, fit: BoxFit.cover),
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: _moreButton(
              onTap: () => _showCoverOptions(cover),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STATIC GRID =====
  Widget _buildStaticGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _additionalImages.length,
      itemBuilder: (context, i) {
        final img = _additionalImages[i];
        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(img.file, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: _moreButton(
                onTap: () => _showImageOptions(i),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===== REORDERABLE GRID =====
  Widget _buildReorderableGrid() {
    final itemCount = _additionalImages.length;
    // Build pairs of items as rows
    final rowCount = (itemCount / 2).ceil();

    return Column(
      children: List.generate(rowCount, (row) {
        final leftIndex = row * 2;
        final rightIndex = row * 2 + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: _draggableTile(leftIndex),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: rightIndex < itemCount
                    ? _draggableTile(rightIndex)
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _draggableTile(int index) {
    final img = _additionalImages[index];
    return LongPressDraggable<int>(
      data: index,
      delay: const Duration(milliseconds: 250),
      onDragStarted: () => setState(() {}),
      onDragEnd: (_) => setState(() {}),
      feedback: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          height: (MediaQuery.of(context).size.width - 48) / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(img.file, fit: BoxFit.cover),
          ),
        ),
      ),
      childWhenDragging: Container(
        height: (MediaQuery.of(context).size.width - 48) / 2,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),
      ),
      child: DragTarget<int>(
        onAcceptWithDetails: (details) => _swapItems(details.data, index),
        builder: (context, candidates, _) {
          final isHovered = candidates.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: (MediaQuery.of(context).size.width - 48) / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isHovered
                  ? Border.all(color: const Color(0xFF0066EE), width: 2)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(img.file, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  // ===== MORE OPTIONS BUTTON =====
  Widget _moreButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  // ===== COVER OPTIONS =====
  void _showCoverOptions(UploadingCarImage? cover) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(l.replaceCoverImage),
              onTap: () => Navigator.pop(context),
            ),
            if (cover != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  l.remove,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.read<CreateCarProvider>().removeImage(cover);
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ===== IMAGE OPTIONS =====
  void _showImageOptions(int index) {
    final l = AppLocalizations.of(context)!;
    final img = _additionalImages[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: Text(l.setAsCover),
              onTap: () {
                context.read<CreateCarProvider>().setCover(img);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                l.remove,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                setState(() => _additionalImages.removeAt(index));
                context.read<CreateCarProvider>().removeImage(img);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
