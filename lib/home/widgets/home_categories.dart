import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sayarti/home/models/brand_model.dart';

class HomeCategories extends StatelessWidget {
  final List<BrandModel> brands;
  final bool loading;
  final String? error;
  final void Function(BrandModel brand)? onBrandTap;

  const HomeCategories({
    super.key,
    required this.brands,
    required this.loading,
    this.error,
    this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    // ===== LOADING =====
    if (loading) {
      return SizedBox(
        height: 72,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, __) => Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemCount: 6,
        ),
      );
    }

    // ===== ERROR =====
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    // ===== EMPTY =====
    if (brands.isEmpty) {
      return const SizedBox.shrink();
    }

    // ===== DATA =====
    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final brand = brands[i];

          return GestureDetector(
            onTap: () => onBrandTap?.call(brand),
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: CachedNetworkImage(
                  imageUrl: brand.imagePath,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Icon(Icons.directions_car, size: 22, color: Colors.black26),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
