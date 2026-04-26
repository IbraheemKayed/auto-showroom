import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/dealer/models/upload_image_model.dart';
import 'package:sayarti/dealer/services and providers/create_car_provider.dart';

class AddPostImagesScreen extends StatelessWidget {
  const AddPostImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final create = context.watch<CreateCarProvider>();

    final UploadingCarImage? cover = create.images.isEmpty
        ? null
        : create.images.firstWhere(
            (e) => e.isCover,
            orElse: () => create.images.first,
          );

    final additional =
        create.images.where((e) => !e.isCover).toList();

    return Scaffold(
      backgroundColor: Colors.white,
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
                      l.question4of5,
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
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.step2,
              style: const TextStyle(
                color: Color(0xFF0066EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.addPhotosOfYourCar,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              l.addPhotosDescription,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),

            /// ================= COVER =================
            Text(l.coverImage,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            _coverImage(context, cover),

            const SizedBox(height: 24),

            /// ================= ADDITIONAL =================
            Row(
              children: [
                Text(l.additionalImages,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text(
                  l.minSixImages,
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _additionalImages(context, additional),

            const SizedBox(height: 12),

            /// ================= CONTINUE =================
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: create.canContinueImages
                    ? () => Navigator.pushNamed(context, '/image_review')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  l.continueBtn,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= COVER =================

  Widget _coverImage(BuildContext context, UploadingCarImage? cover) {
    return GestureDetector(
      onTap: () => _pickImage(context, isCover: true),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            if (cover != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    cover.file,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              _placeholder(context),

            if (cover != null && cover.isUploading)
              _loaderOverlay(cover.progress),
          ],
        ),
      ),
    );
  }

  // ================= GRID =================

  Widget _additionalImages(
    BuildContext context,
    List<UploadingCarImage> images,
  ) {
    final create = context.read<CreateCarProvider>();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, i) {
        if (i == images.length) {
          return GestureDetector(
            onTap: () => _pickImage(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _placeholder(context),
            ),
          );
        }

        final img = images[i];

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onLongPress: () => create.setCover(img),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    img.file,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            if (img.isUploading)
              _loaderOverlay(img.progress),

            if (!img.isUploading)
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () => create.removeImage(img),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.delete,
                        size: 14, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ================= HELPERS =================

  Widget _loaderOverlay(double progress) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: CircularProgressIndicator(
            value: progress > 0 ? progress : null,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 28),
            const SizedBox(height: 8),
            Text(
              l.uploadOrTakeImage,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              l.addImage,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0066EE),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PICK IMAGE =================

  Future<void> _pickImage(BuildContext context,
      {bool isCover = false}) async {
    final picker = ImagePicker();

    final create = context.read<CreateCarProvider>();

    if (isCover) {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      await create.addImage(File(picked.path), isCover: true);
    } else {
      final picked = await picker.pickMultiImage(imageQuality: 85);
      if (picked.isEmpty) return;
      for (final img in picked) {
        create.addImage(File(img.path));
      }
    }
  }
}
