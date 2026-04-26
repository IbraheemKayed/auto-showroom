import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/dealer/screens/add_post_body_style.dart';
import 'package:sayarti/dealer/screens/add_post_colors_screen.dart';
import 'package:sayarti/dealer/screens/add_post_features.dart';
import 'package:sayarti/dealer/screens/add_post_fule.dart';
import 'package:sayarti/dealer/screens/add_post_image_review.dart';
import 'package:sayarti/dealer/screens/add_post_images_screen.dart';
import 'package:sayarti/dealer/screens/add_post_mileage.dart';
import 'package:sayarti/dealer/screens/add_post_price_screen.dart';
import 'package:sayarti/dealer/screens/add_post_step2.dart';
import 'package:sayarti/dealer/screens/add_post_step2_intro.dart';
import 'package:sayarti/dealer/screens/add_post_step3_intro.dart';
import 'package:sayarti/dealer/screens/add_post_summary_screen.dart';
import 'package:sayarti/dealer/screens/add_post_title_discription_screen.dart';
import 'package:sayarti/dealer/screens/puplish_success_screen.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';

class AddCarFlow extends StatefulWidget {
  const AddCarFlow({super.key});

  @override
  State<AddCarFlow> createState() => _AddCarFlowState();
}

class _AddCarFlowState extends State<AddCarFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final api = context.read<CarApiService>();

    return ChangeNotifierProvider(
      create: (_) => CreateCarProvider(api),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_navigatorKey.currentState?.canPop() ?? false) {
            _navigatorKey.currentState!.pop();
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Material(
          color: Colors.white,
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: _onGenerateRoute,
          ),
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case '/body':
        page = const AddPostBodyStyleScreen();
        break;
      case '/mileage':
        page = const AddPostMileageScreen();
        break;

      case '/step2_intro':
        page = const AddPostStep2Intro();
        break;

      case '/features':
      page = const AddPostFeaturesScreen();
        break;

      case '/colors':
      page = const AddPostColorsScreen();
        break;

        case '/images':
      page = const AddPostImagesScreen();
        break;
      
      case '/image_review':
        page = const AddPostImageReviewScreen();
        break;

      case '/description':
        page = const AddPostTitleDescriptionScreen();
        break;

      case '/step3_intro':
        page = const AddPostStep3Intro();
        break;

      case '/price':
        page = const AddPostPriceScreen();
        break;

      case '/review':
        page = const AddPostSummaryScreen();
        break;

      case '/success':
        page = const PublishSuccessScreen();
        break;

      case '/fuel':
        page = const AddPostFuelType();
        break;

      case '/':
      default:
        page = const AddPostStep2();

    }

    return MaterialPageRoute(builder: (_) => page);
  }
}

