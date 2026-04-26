import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/dealer/services and providers/create_car_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class AddPostTitleDescriptionScreen extends StatefulWidget {
  const AddPostTitleDescriptionScreen({super.key});

  @override
  State<AddPostTitleDescriptionScreen> createState() =>
      _AddPostTitleDescriptionScreenState();
}

class _AddPostTitleDescriptionScreenState
    extends State<AddPostTitleDescriptionScreen> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final create = context.read<CreateCarProvider>();
    _descriptionController =
        TextEditingController(text: create.draft.description ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final create = context.watch<CreateCarProvider>();
    final title = create.carTitle;

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
                      l.questions5of5,
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
                    widthFactor: 1.0,
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
            // ===== STEP =====
            Text(
              l.step2,
              style: const TextStyle(
                color: Color(0xFF0066EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              l.provideTitleDescriptionFor(title),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),
            Text(
              l.titleRecommendation,
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 24),

            // ================= TITLE (READ ONLY) =================
            Text(
              l.titleLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Container(
              height: 54,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 6),
            Text(
              l.titleCharCount(title.length),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),

            // ================= DESCRIPTION =================
            Text(
              l.descriptionLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: l.enterDescription,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0066EE), width: 2),
                ),
              ),
              onChanged: create.setDescription,
            ),

            const SizedBox(height: 24),

            // ================= CONTINUE =================
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  // final success = await create.publish();

                  // if (!context.mounted) return;

                  // if (success) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Car created successfully ✅'),
                  //     ),
                  //   );
                  //   // Navigator.pushReplacementNamed(context, '/success');
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content:
                  //           Text(create.error ?? 'Something went wrong'),
                  //     ),
                  //   );
                  // }
                  Navigator.pushNamed(context, '/step3_intro');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: create.isCreating
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      )
                    : Text(
                        l.continueBtn,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
