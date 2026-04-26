import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/search/providers/search_provider.dart';
import 'make_select_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class ModelScreen extends StatefulWidget {
  const ModelScreen({super.key});

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final search = context.read<SearchProvider>();
      if (search.selectedBrand != null) {
        search.loadModels();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.black),
        title: Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx)!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.modelFilter,
                  style: const TextStyle(
                    fontSize: 18.43,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF131313),
                    height: 1.0,
                  ),
                ),
                Text(
                  l10n.multiSelect,
                  style: const TextStyle(
                    fontSize: 12.1,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF5E5F5F),
                    height: 1.0,
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: search.selectedBrand == null
          ? Center(child: _selectMakeFirst(context))
          : _modelsList(search),

      bottomNavigationBar: _bottomBar(search),
    );
  }

  // ================= UI STATES =================

  Widget _selectMakeFirst(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline, size: 28, color: Colors.blue),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.pleaseSelectMakeFirst,
          style: const TextStyle(fontSize: 15.8, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MakeScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0066EE),
            minimumSize: Size(MediaQuery.of(context).size.width - 40, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(AppLocalizations.of(context)!.selectMake, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ],
    );
  }

  Widget _modelsList(SearchProvider search) {
    if (search.isLoadingModels) {
      return SkeletonShimmer(
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEAEAEA)),
          itemBuilder: (_, __) => const ListTile(
            title: SkeletonBox(height: 14, width: double.infinity, borderRadius: 4),
          ),
        ),
      );
    }

    // Deduplicate by name to avoid showing same model multiple times
    final seen = <String>{};
    final uniqueModels = search.models
        .where((m) => seen.add(m.name.trim().toUpperCase()))
        .toList();

    return ListView.separated(
      itemCount: uniqueModels.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, thickness: 0.8, color: Color(0xFFE8E8E8)),
      itemBuilder: (context, index) {
        final model = uniqueModels[index];
        final selected =
            search.selectedModelIds.contains(model.id);

        return ListTile(
          title: Text(
            model.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1B1B1B),
              height: 1.4,
            ),
          ),
          trailing: selected
              ? const Icon(Icons.check, color: Colors.black)
              : null,
          onTap: () {
            search.toggleModel(model);
          },
        );
      },
    );
  }

  Widget _bottomBar(SearchProvider search) {
    final hasSelection = search.selectedModelIds.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: hasSelection ? search.clearModels : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black54,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size(0, 48),
              ),
              child: Text(AppLocalizations.of(context)!.clearFilter),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: hasSelection
                  ? () {
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasSelection
                    ? const Color(0xFF0066EE)
                    : Colors.grey.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size(0, 48),
              ),
              child: Text(
                AppLocalizations.of(context)!.update,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
