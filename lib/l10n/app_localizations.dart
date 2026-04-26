import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @clutch.
  ///
  /// In en, this message translates to:
  /// **'Clutch'**
  String get clutch;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @yourPosts.
  ///
  /// In en, this message translates to:
  /// **'Your posts'**
  String get yourPosts;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @exclusiveDeals.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Deals'**
  String get exclusiveDeals;

  /// No description provided for @recentPriceDrops.
  ///
  /// In en, this message translates to:
  /// **'Recent price drops'**
  String get recentPriceDrops;

  /// No description provided for @nearbyCars.
  ///
  /// In en, this message translates to:
  /// **'Nearby Cars'**
  String get nearbyCars;

  /// No description provided for @postYourCar.
  ///
  /// In en, this message translates to:
  /// **'Post your car!'**
  String get postYourCar;

  /// No description provided for @dealerPostDescription.
  ///
  /// In en, this message translates to:
  /// **'Join to be one of the people who rent their best cars here!'**
  String get dealerPostDescription;

  /// No description provided for @userPostDescription.
  ///
  /// In en, this message translates to:
  /// **'Join to be one of the people who sell their best cars here!'**
  String get userPostDescription;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get startNow;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @paymentPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payment & payouts'**
  String get paymentPayouts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacyAndSecurity;

  /// No description provided for @dealer.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get dealer;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @contactSupportCenter.
  ///
  /// In en, this message translates to:
  /// **'Contact support center'**
  String get contactSupportCenter;

  /// No description provided for @giveUsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give us feedback'**
  String get giveUsFeedback;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms Of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @readyToLogout.
  ///
  /// In en, this message translates to:
  /// **'Ready to logout?'**
  String get readyToLogout;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re about to log out from your account.\nDon\'t worry, all your data is safe and you can log back in anytime.'**
  String get logoutConfirmationMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noSavedCarsYet.
  ///
  /// In en, this message translates to:
  /// **'No saved cars yet'**
  String get noSavedCarsYet;

  /// No description provided for @savedCarsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Cars you save will appear here.'**
  String get savedCarsPlaceholder;

  /// No description provided for @preference.
  ///
  /// In en, this message translates to:
  /// **'Preference'**
  String get preference;

  /// No description provided for @whichCarType.
  ///
  /// In en, this message translates to:
  /// **'Which car type catches your eye?'**
  String get whichCarType;

  /// No description provided for @multiSelect.
  ///
  /// In en, this message translates to:
  /// **'Multi-select'**
  String get multiSelect;

  /// No description provided for @perfectForDifferentLifestyles.
  ///
  /// In en, this message translates to:
  /// **'Perfect for different lifestyles'**
  String get perfectForDifferentLifestyles;

  /// No description provided for @whichBrandOrigin.
  ///
  /// In en, this message translates to:
  /// **'Which car brand origin do you prefer?'**
  String get whichBrandOrigin;

  /// No description provided for @noPreference.
  ///
  /// In en, this message translates to:
  /// **'No Preference'**
  String get noPreference;

  /// No description provided for @allOriginsDescription.
  ///
  /// In en, this message translates to:
  /// **'All origins\nShow results from every country'**
  String get allOriginsDescription;

  /// No description provided for @brandsAvailable.
  ///
  /// In en, this message translates to:
  /// **'brands available'**
  String get brandsAvailable;

  /// No description provided for @whatFuelType.
  ///
  /// In en, this message translates to:
  /// **'What fuel type suits your needs?'**
  String get whatFuelType;

  /// No description provided for @chooseYourPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Price Range'**
  String get chooseYourPriceRange;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxPrice;

  /// No description provided for @locationDescription.
  ///
  /// In en, this message translates to:
  /// **'Find cars nearest to you for a tailored experience.'**
  String get locationDescription;

  /// No description provided for @locationHelpText.
  ///
  /// In en, this message translates to:
  /// **'Your location helps us show\nthe most relevant listings.'**
  String get locationHelpText;

  /// No description provided for @chooseYourCity.
  ///
  /// In en, this message translates to:
  /// **'Choose your city'**
  String get chooseYourCity;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @findingRightCar.
  ///
  /// In en, this message translates to:
  /// **'Finding the Right\nCar Starts with\nYou'**
  String get findingRightCar;

  /// No description provided for @findCarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what matters most and\nour AI powered tool will do the\nsearching'**
  String get findCarSubtitle;

  /// No description provided for @findYourPerfectCar.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Car'**
  String get findYourPerfectCar;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching'**
  String get searching;

  /// No description provided for @searchingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are looking for the perfect car\nfor you!'**
  String get searchingSubtitle;

  /// No description provided for @yourResults.
  ///
  /// In en, this message translates to:
  /// **'Your results'**
  String get yourResults;

  /// No description provided for @changeYourAnswers.
  ///
  /// In en, this message translates to:
  /// **'Change your answers'**
  String get changeYourAnswers;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noResultsFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'No cars that match your preferences have been found, please press the button below to change your answers'**
  String get noResultsFoundDescription;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Let us know your car'**
  String get step1Title;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Define your car'**
  String get step2Title;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Let us know your price'**
  String get step3Title;

  /// No description provided for @question1of3.
  ///
  /// In en, this message translates to:
  /// **'Question 1 of 3'**
  String get question1of3;

  /// No description provided for @question2of3.
  ///
  /// In en, this message translates to:
  /// **'Question 2 of 3'**
  String get question2of3;

  /// No description provided for @question3of3.
  ///
  /// In en, this message translates to:
  /// **'Question 3 of 3'**
  String get question3of3;

  /// No description provided for @question1of5.
  ///
  /// In en, this message translates to:
  /// **'Question 1 of 5'**
  String get question1of5;

  /// No description provided for @question2of5.
  ///
  /// In en, this message translates to:
  /// **'Question 2 of 5'**
  String get question2of5;

  /// No description provided for @question3of5.
  ///
  /// In en, this message translates to:
  /// **'Question 3 of 5'**
  String get question3of5;

  /// No description provided for @question4of5.
  ///
  /// In en, this message translates to:
  /// **'Question 4 of 5'**
  String get question4of5;

  /// No description provided for @questions4of5.
  ///
  /// In en, this message translates to:
  /// **'Questions 4 of 5'**
  String get questions4of5;

  /// No description provided for @questions5of5.
  ///
  /// In en, this message translates to:
  /// **'Questions 5 of 5'**
  String get questions5of5;

  /// No description provided for @questions1of1.
  ///
  /// In en, this message translates to:
  /// **'Questions 1 of 1'**
  String get questions1of1;

  /// No description provided for @chooseMakeModel.
  ///
  /// In en, this message translates to:
  /// **'Please choose your car\'s make & model'**
  String get chooseMakeModel;

  /// No description provided for @pleaseChooseMake.
  ///
  /// In en, this message translates to:
  /// **'Please choose the make'**
  String get pleaseChooseMake;

  /// No description provided for @pleaseChooseModel.
  ///
  /// In en, this message translates to:
  /// **'Please choose the Model'**
  String get pleaseChooseModel;

  /// No description provided for @pleaseChooseYear.
  ///
  /// In en, this message translates to:
  /// **'Please choose the Registration Year'**
  String get pleaseChooseYear;

  /// No description provided for @chooseMake.
  ///
  /// In en, this message translates to:
  /// **'Choose Make'**
  String get chooseMake;

  /// No description provided for @chooseModel.
  ///
  /// In en, this message translates to:
  /// **'Choose Model'**
  String get chooseModel;

  /// No description provided for @chooseYear.
  ///
  /// In en, this message translates to:
  /// **'Choose Year'**
  String get chooseYear;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @whatIsBodyStyle.
  ///
  /// In en, this message translates to:
  /// **'What is your car\'s Body Style?'**
  String get whatIsBodyStyle;

  /// No description provided for @pleaseSelectBodyStyle.
  ///
  /// In en, this message translates to:
  /// **'Please select the one that applies'**
  String get pleaseSelectBodyStyle;

  /// No description provided for @whatsYourColor.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Color?'**
  String get whatsYourColor;

  /// No description provided for @selectClosestColor.
  ///
  /// In en, this message translates to:
  /// **'Select the color that is closest to your car.'**
  String get selectClosestColor;

  /// No description provided for @pleaseChooseExteriorColor.
  ///
  /// In en, this message translates to:
  /// **'Please choose the exterior color'**
  String get pleaseChooseExteriorColor;

  /// No description provided for @whatsYourInteriorColor.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Interior Color?'**
  String get whatsYourInteriorColor;

  /// No description provided for @selectClosestInteriorColor.
  ///
  /// In en, this message translates to:
  /// **'Select the interior color that is closest to your car.'**
  String get selectClosestInteriorColor;

  /// No description provided for @pleaseChooseInteriorColor.
  ///
  /// In en, this message translates to:
  /// **'Please choose the interior color'**
  String get pleaseChooseInteriorColor;

  /// No description provided for @exteriorColor.
  ///
  /// In en, this message translates to:
  /// **'Exterior Color'**
  String get exteriorColor;

  /// No description provided for @interiorColor.
  ///
  /// In en, this message translates to:
  /// **'Interior Color'**
  String get interiorColor;

  /// No description provided for @whatsYourEngineSize.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Engine Size?'**
  String get whatsYourEngineSize;

  /// No description provided for @pleaseChooseEngineSize.
  ///
  /// In en, this message translates to:
  /// **'Please choose the engine size'**
  String get pleaseChooseEngineSize;

  /// No description provided for @whatsYourPower.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Power?'**
  String get whatsYourPower;

  /// No description provided for @enterPowerExample.
  ///
  /// In en, this message translates to:
  /// **'Please enter the power (e.g. 335 HP)'**
  String get enterPowerExample;

  /// No description provided for @whatsYourFuelType.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Fuel Type?'**
  String get whatsYourFuelType;

  /// No description provided for @pleaseChooseFuelType.
  ///
  /// In en, this message translates to:
  /// **'Please choose the fuel type'**
  String get pleaseChooseFuelType;

  /// No description provided for @whatsYourTransmission.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Transmission Type?'**
  String get whatsYourTransmission;

  /// No description provided for @pleaseChooseTransmission.
  ///
  /// In en, this message translates to:
  /// **'Please choose the transmission type'**
  String get pleaseChooseTransmission;

  /// No description provided for @whatsYourDriveTrain.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Drive Train?'**
  String get whatsYourDriveTrain;

  /// No description provided for @pleaseChooseDriveTrain.
  ///
  /// In en, this message translates to:
  /// **'Please choose the drive train'**
  String get pleaseChooseDriveTrain;

  /// No description provided for @whatsYourPreviousOwners.
  ///
  /// In en, this message translates to:
  /// **'What\'s your car\'s Previous Owners?'**
  String get whatsYourPreviousOwners;

  /// No description provided for @pleaseInputPreviousOwners.
  ///
  /// In en, this message translates to:
  /// **'Please input number of previous owners'**
  String get pleaseInputPreviousOwners;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @driveTrain.
  ///
  /// In en, this message translates to:
  /// **'Drive Train'**
  String get driveTrain;

  /// No description provided for @addPhotosOfYourCar.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your car.'**
  String get addPhotosOfYourCar;

  /// No description provided for @addPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a cover photo and other supporting photos, whether outdoor, indoor, any photos you have.'**
  String get addPhotosDescription;

  /// No description provided for @coverImage.
  ///
  /// In en, this message translates to:
  /// **'Cover image'**
  String get coverImage;

  /// No description provided for @additionalImages.
  ///
  /// In en, this message translates to:
  /// **'Additional images'**
  String get additionalImages;

  /// No description provided for @minSixImages.
  ///
  /// In en, this message translates to:
  /// **'Min. 6 images'**
  String get minSixImages;

  /// No description provided for @uploadOrTakeImage.
  ///
  /// In en, this message translates to:
  /// **'Upload or take an image'**
  String get uploadOrTakeImage;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'+ Add image'**
  String get addImage;

  /// No description provided for @checkAndConfirmPhotos.
  ///
  /// In en, this message translates to:
  /// **'Check and confirm your photos.'**
  String get checkAndConfirmPhotos;

  /// No description provided for @reviewOrChangeImages.
  ///
  /// In en, this message translates to:
  /// **'Review or change the images you want to modify.'**
  String get reviewOrChangeImages;

  /// No description provided for @totalImages.
  ///
  /// In en, this message translates to:
  /// **'total images'**
  String get totalImages;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Re-order'**
  String get reorder;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @howDoIDo.
  ///
  /// In en, this message translates to:
  /// **'How do I do that?'**
  String get howDoIDo;

  /// No description provided for @dragImageToReposition.
  ///
  /// In en, this message translates to:
  /// **'Simply drag the image you want to reposition'**
  String get dragImageToReposition;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @replaceCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Replace cover image'**
  String get replaceCoverImage;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @setAsCover.
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get setAsCover;

  /// No description provided for @whatFeaturesAvailable.
  ///
  /// In en, this message translates to:
  /// **'What features are available in your car?'**
  String get whatFeaturesAvailable;

  /// No description provided for @selectFeaturesDescription.
  ///
  /// In en, this message translates to:
  /// **'Select all of the features below that apply; you can still add features after publication.'**
  String get selectFeaturesDescription;

  /// No description provided for @provideTitleDescription.
  ///
  /// In en, this message translates to:
  /// **'Provide a title and description\nfor the car you are selling'**
  String get provideTitleDescription;

  /// No description provided for @titleRecommendation.
  ///
  /// In en, this message translates to:
  /// **'We recommend a concise and short title,\nas it is better, but you can adjust it'**
  String get titleRecommendation;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// No description provided for @setYourPrice.
  ///
  /// In en, this message translates to:
  /// **'Set your price'**
  String get setYourPrice;

  /// No description provided for @priceRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Consider setting a competitive price to\nattract customers.'**
  String get priceRecommendation;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTitle;

  /// No description provided for @letsPublishYourCar.
  ///
  /// In en, this message translates to:
  /// **'Let\'s publish your car'**
  String get letsPublishYourCar;

  /// No description provided for @publishDescription.
  ///
  /// In en, this message translates to:
  /// **'Check out the preview below and post your car now! We will let you know once you\'re approved.'**
  String get publishDescription;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @successfullyApplied.
  ///
  /// In en, this message translates to:
  /// **'Successfully applied listing!'**
  String get successfullyApplied;

  /// No description provided for @reviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Our team reviews listings usually in under 24 hours. We will let you know once your listing is approved.'**
  String get reviewMessage;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get goToHome;

  /// No description provided for @yourListings.
  ///
  /// In en, this message translates to:
  /// **'Your Listings'**
  String get yourListings;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @failedToLoadListings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load listings'**
  String get failedToLoadListings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noListingsYet.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get noListingsYet;

  /// No description provided for @addPost.
  ///
  /// In en, this message translates to:
  /// **'Add post'**
  String get addPost;

  /// No description provided for @sortingBy.
  ///
  /// In en, this message translates to:
  /// **'Sorting by'**
  String get sortingBy;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @awaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Approval'**
  String get awaitingApproval;

  /// No description provided for @listedPosts.
  ///
  /// In en, this message translates to:
  /// **'Listed Posts'**
  String get listedPosts;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get nameAZ;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price (High to low)'**
  String get priceHighToLow;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price (Low to high)'**
  String get priceLowToHigh;

  /// No description provided for @listed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get listed;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications!'**
  String get noNotifications;

  /// No description provided for @notificationsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Any notifications, either from the system or cars you\'re interested in will appear here.'**
  String get notificationsPlaceholder;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// No description provided for @premiumDealer.
  ///
  /// In en, this message translates to:
  /// **'Premium Dealer'**
  String get premiumDealer;

  /// No description provided for @aboutDealer.
  ///
  /// In en, this message translates to:
  /// **'About Dealer'**
  String get aboutDealer;

  /// No description provided for @acceptedPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Accepted Payment Methods'**
  String get acceptedPaymentMethods;

  /// No description provided for @registeredSince.
  ///
  /// In en, this message translates to:
  /// **'Registered since'**
  String get registeredSince;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @contactDealer.
  ///
  /// In en, this message translates to:
  /// **'Contact Dealer'**
  String get contactDealer;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// No description provided for @findYourNextCar.
  ///
  /// In en, this message translates to:
  /// **'Find your next car'**
  String get findYourNextCar;

  /// No description provided for @browseTrustedDealers.
  ///
  /// In en, this message translates to:
  /// **'Browse trusted dealers\nand spot great deals.'**
  String get browseTrustedDealers;

  /// No description provided for @whatAreYouLookingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatAreYouLookingFor;

  /// No description provided for @cantFindNextCar.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find your next car?'**
  String get cantFindNextCar;

  /// No description provided for @aiHelpsFind.
  ///
  /// In en, this message translates to:
  /// **'Our AI helps you find your next car by showing the best matches.'**
  String get aiHelpsFind;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @allCars.
  ///
  /// In en, this message translates to:
  /// **'All Cars'**
  String get allCars;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @anyPrice.
  ///
  /// In en, this message translates to:
  /// **'Any price'**
  String get anyPrice;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @veryGoodPrice.
  ///
  /// In en, this message translates to:
  /// **'Very Good Price'**
  String get veryGoodPrice;

  /// No description provided for @goodPrice.
  ///
  /// In en, this message translates to:
  /// **'Good Price'**
  String get goodPrice;

  /// No description provided for @averagePrice.
  ///
  /// In en, this message translates to:
  /// **'Average Price'**
  String get averagePrice;

  /// No description provided for @highPrice.
  ///
  /// In en, this message translates to:
  /// **'High Price'**
  String get highPrice;

  /// No description provided for @veryHighPrice.
  ///
  /// In en, this message translates to:
  /// **'Very High Price'**
  String get veryHighPrice;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'SOLD'**
  String get sold;

  /// No description provided for @noCarData.
  ///
  /// In en, this message translates to:
  /// **'No car data'**
  String get noCarData;

  /// No description provided for @aboutThisCar.
  ///
  /// In en, this message translates to:
  /// **'About this car'**
  String get aboutThisCar;

  /// No description provided for @listingDate.
  ///
  /// In en, this message translates to:
  /// **'Listing date'**
  String get listingDate;

  /// No description provided for @listingTime.
  ///
  /// In en, this message translates to:
  /// **'Listing time'**
  String get listingTime;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// No description provided for @noFeaturesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No features available'**
  String get noFeaturesAvailable;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @viewAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'View All Features'**
  String get viewAllFeatures;

  /// No description provided for @dealerInformation.
  ///
  /// In en, this message translates to:
  /// **'Dealer information'**
  String get dealerInformation;

  /// No description provided for @totalReviews.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average rating'**
  String get averageRating;

  /// No description provided for @responseRate.
  ///
  /// In en, this message translates to:
  /// **'Response rate'**
  String get responseRate;

  /// No description provided for @totalCars.
  ///
  /// In en, this message translates to:
  /// **'Total Cars'**
  String get totalCars;

  /// No description provided for @carListings.
  ///
  /// In en, this message translates to:
  /// **'car listings'**
  String get carListings;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'More about'**
  String get moreAbout;

  /// No description provided for @theLocation.
  ///
  /// In en, this message translates to:
  /// **'The location'**
  String get theLocation;

  /// No description provided for @dealersLocation.
  ///
  /// In en, this message translates to:
  /// **'Dealer\'s location'**
  String get dealersLocation;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on map'**
  String get viewOnMap;

  /// No description provided for @viewMap.
  ///
  /// In en, this message translates to:
  /// **'View map'**
  String get viewMap;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @previousPrices.
  ///
  /// In en, this message translates to:
  /// **'Previous Prices'**
  String get previousPrices;

  /// No description provided for @editPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit price'**
  String get editPrice;

  /// No description provided for @markAsSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as Sold'**
  String get markAsSold;

  /// No description provided for @markAsSoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark As Sold?'**
  String get markAsSoldTitle;

  /// No description provided for @markAsSoldMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re about to mark this car as sold, this car will be hidden from the application except your profile.'**
  String get markAsSoldMessage;

  /// No description provided for @soldBtn.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get soldBtn;

  /// No description provided for @messageDealer.
  ///
  /// In en, this message translates to:
  /// **'Message Dealer'**
  String get messageDealer;

  /// No description provided for @mileageLabel.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileageLabel;

  /// No description provided for @engineSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Engine Size'**
  String get engineSizeLabel;

  /// No description provided for @powerLabel.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get powerLabel;

  /// No description provided for @registrationYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration Year'**
  String get registrationYearLabel;

  /// No description provided for @fuelLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuelLabel;

  /// No description provided for @transmissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmissionLabel;

  /// No description provided for @driveTrainLabel.
  ///
  /// In en, this message translates to:
  /// **'DriveTrain'**
  String get driveTrainLabel;

  /// No description provided for @previousOwnersLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous Owners'**
  String get previousOwnersLabel;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @noCarsFound.
  ///
  /// In en, this message translates to:
  /// **'No cars found'**
  String get noCarsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @locationFilter.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationFilter;

  /// No description provided for @makeFilter.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get makeFilter;

  /// No description provided for @modelFilter.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelFilter;

  /// No description provided for @priceFilter.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceFilter;

  /// No description provided for @yearFilter.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearFilter;

  /// No description provided for @mileageFilter.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileageFilter;

  /// No description provided for @searchDealers.
  ///
  /// In en, this message translates to:
  /// **'Search Dealers'**
  String get searchDealers;

  /// No description provided for @selectMake.
  ///
  /// In en, this message translates to:
  /// **'Select a Make'**
  String get selectMake;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilter;

  /// No description provided for @sortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortByTitle;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get sortByDate;

  /// No description provided for @sortByAmount.
  ///
  /// In en, this message translates to:
  /// **'By amount'**
  String get sortByAmount;

  /// No description provided for @featureAbs.
  ///
  /// In en, this message translates to:
  /// **'ABS'**
  String get featureAbs;

  /// No description provided for @featureTractionControl.
  ///
  /// In en, this message translates to:
  /// **'Traction Control'**
  String get featureTractionControl;

  /// No description provided for @featureTirePressure.
  ///
  /// In en, this message translates to:
  /// **'Tire Pressure'**
  String get featureTirePressure;

  /// No description provided for @featureLaneDeparture.
  ///
  /// In en, this message translates to:
  /// **'Lane Departure'**
  String get featureLaneDeparture;

  /// No description provided for @featureAutoBraking.
  ///
  /// In en, this message translates to:
  /// **'Auto Braking'**
  String get featureAutoBraking;

  /// No description provided for @featureBlindSpot.
  ///
  /// In en, this message translates to:
  /// **'Blind Spot'**
  String get featureBlindSpot;

  /// No description provided for @featureCruiseControl.
  ///
  /// In en, this message translates to:
  /// **'Cruise Control'**
  String get featureCruiseControl;

  /// No description provided for @featureParkingSensors.
  ///
  /// In en, this message translates to:
  /// **'Parking Sensors'**
  String get featureParkingSensors;

  /// No description provided for @featureRearCamera.
  ///
  /// In en, this message translates to:
  /// **'Rear Camera'**
  String get featureRearCamera;

  /// No description provided for @featureFogLights.
  ///
  /// In en, this message translates to:
  /// **'Fog Lights'**
  String get featureFogLights;

  /// No description provided for @featureLedHeadlights.
  ///
  /// In en, this message translates to:
  /// **'LED Headlights'**
  String get featureLedHeadlights;

  /// No description provided for @featureAutoHeadlights.
  ///
  /// In en, this message translates to:
  /// **'Auto Headlights'**
  String get featureAutoHeadlights;

  /// No description provided for @featureRainWipers.
  ///
  /// In en, this message translates to:
  /// **'Rain Wipers'**
  String get featureRainWipers;

  /// No description provided for @featurePanoramicRoof.
  ///
  /// In en, this message translates to:
  /// **'Panoramic Roof'**
  String get featurePanoramicRoof;

  /// No description provided for @featureClimateControl.
  ///
  /// In en, this message translates to:
  /// **'Climate Control'**
  String get featureClimateControl;

  /// No description provided for @featurePowerWindows.
  ///
  /// In en, this message translates to:
  /// **'Power Windows'**
  String get featurePowerWindows;

  /// No description provided for @featurePowerMirrors.
  ///
  /// In en, this message translates to:
  /// **'Power Mirrors'**
  String get featurePowerMirrors;

  /// No description provided for @featureHeatedSeats.
  ///
  /// In en, this message translates to:
  /// **'Heated Seats'**
  String get featureHeatedSeats;

  /// No description provided for @featureVentilatedSeats.
  ///
  /// In en, this message translates to:
  /// **'Ventilated Seats'**
  String get featureVentilatedSeats;

  /// No description provided for @featureKeylessEntry.
  ///
  /// In en, this message translates to:
  /// **'Keyless Entry'**
  String get featureKeylessEntry;

  /// No description provided for @featurePushStart.
  ///
  /// In en, this message translates to:
  /// **'Push Start'**
  String get featurePushStart;

  /// No description provided for @featureElectricBrake.
  ///
  /// In en, this message translates to:
  /// **'Electric Brake'**
  String get featureElectricBrake;

  /// No description provided for @featureMemorySeats.
  ///
  /// In en, this message translates to:
  /// **'Memory Seats'**
  String get featureMemorySeats;

  /// No description provided for @featureRearAcVents.
  ///
  /// In en, this message translates to:
  /// **'Rear AC Vents'**
  String get featureRearAcVents;

  /// No description provided for @featureTouchscreen.
  ///
  /// In en, this message translates to:
  /// **'Touchscreen'**
  String get featureTouchscreen;

  /// No description provided for @featureBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get featureBluetooth;

  /// No description provided for @featureAppleCarplay.
  ///
  /// In en, this message translates to:
  /// **'Apple CarPlay'**
  String get featureAppleCarplay;

  /// No description provided for @featureAndroidAuto.
  ///
  /// In en, this message translates to:
  /// **'Android Auto'**
  String get featureAndroidAuto;

  /// No description provided for @featureUsbPorts.
  ///
  /// In en, this message translates to:
  /// **'USB-C Ports'**
  String get featureUsbPorts;

  /// No description provided for @featureNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get featureNavigation;

  /// No description provided for @featureVoiceControl.
  ///
  /// In en, this message translates to:
  /// **'Voice Control'**
  String get featureVoiceControl;

  /// No description provided for @featureWirelessCharging.
  ///
  /// In en, this message translates to:
  /// **'Wireless Charging'**
  String get featureWirelessCharging;

  /// No description provided for @featurePremiumSound.
  ///
  /// In en, this message translates to:
  /// **'Premium Sound'**
  String get featurePremiumSound;

  /// No description provided for @featureDriveModes.
  ///
  /// In en, this message translates to:
  /// **'Drive Modes'**
  String get featureDriveModes;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @showMoreFilters.
  ///
  /// In en, this message translates to:
  /// **'Show more filters'**
  String get showMoreFilters;

  /// No description provided for @filterSelected.
  ///
  /// In en, this message translates to:
  /// **'filter selected'**
  String get filterSelected;

  /// No description provided for @filtersSelected.
  ///
  /// In en, this message translates to:
  /// **'filters selected'**
  String get filtersSelected;

  /// No description provided for @searchAllCars.
  ///
  /// In en, this message translates to:
  /// **'Search cars'**
  String get searchAllCars;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @noDealersFound.
  ///
  /// In en, this message translates to:
  /// **'No dealers found.'**
  String get noDealersFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get tryDifferentSearch;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @nSelected.
  ///
  /// In en, this message translates to:
  /// **'{n} selected'**
  String nSelected(Object n);

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @relevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get relevance;

  /// No description provided for @datePosted.
  ///
  /// In en, this message translates to:
  /// **'Date Posted'**
  String get datePosted;

  /// No description provided for @anytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get anytime;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @past30Days.
  ///
  /// In en, this message translates to:
  /// **'Past 30 days'**
  String get past30Days;

  /// No description provided for @past90Days.
  ///
  /// In en, this message translates to:
  /// **'Past 90 days'**
  String get past90Days;

  /// No description provided for @past6Months.
  ///
  /// In en, this message translates to:
  /// **'Past 6 months'**
  String get past6Months;

  /// No description provided for @pastYear.
  ///
  /// In en, this message translates to:
  /// **'Past year'**
  String get pastYear;

  /// No description provided for @byDateRange.
  ///
  /// In en, this message translates to:
  /// **'By date range'**
  String get byDateRange;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @toConnector.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get toConnector;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Clutch,\nyou\'re in!'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A premium experience, just for you.'**
  String get welcomeSubtitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover the best car\nmakes & models'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Find the perfect car for you.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Trusted dealers,\nsmooth interactions'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Car buying made simple.'**
  String get onboardingSubtitle2;

  /// No description provided for @enterPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your\nphone number'**
  String get enterPhoneTitle;

  /// No description provided for @phoneVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your phone number helps verify your identity and keep your account secure.'**
  String get phoneVerifySubtitle;

  /// No description provided for @tosAgreement.
  ///
  /// In en, this message translates to:
  /// **'By Signing up you agree to our '**
  String get tosAgreement;

  /// No description provided for @tos.
  ///
  /// In en, this message translates to:
  /// **'TOS'**
  String get tos;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @verifyingCode.
  ///
  /// In en, this message translates to:
  /// **'Verifying\nyour code entry'**
  String get verifyingCode;

  /// No description provided for @enterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter phone\nverification code'**
  String get enterOtpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your phone number {phone}.'**
  String otpSentTo(String phone);

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid Code, please try again'**
  String get invalidOtp;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t Receive Code? '**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your\nname please.'**
  String get enterYourName;

  /// No description provided for @personalizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us create a more personal and\nfriendly experience for you.'**
  String get personalizeSubtitle;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @chooseCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Please Choose\nyour city'**
  String get chooseCityTitle;

  /// No description provided for @selectCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectCityHint;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, try again'**
  String get somethingWentWrong;

  /// No description provided for @editPriceBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit your {carName}\'s Price!'**
  String editPriceBannerTitle(String carName);

  /// No description provided for @editPriceBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each edit will be reviewed by our team for further confirmation.'**
  String get editPriceBannerSubtitle;

  /// No description provided for @savePrice.
  ///
  /// In en, this message translates to:
  /// **'Save Price'**
  String get savePrice;

  /// No description provided for @failedUpdatePrice.
  ///
  /// In en, this message translates to:
  /// **'Failed to update price. Try again.'**
  String get failedUpdatePrice;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeTill.
  ///
  /// In en, this message translates to:
  /// **'Active till'**
  String get activeTill;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get cancelSubscription;

  /// No description provided for @cancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you\nwant to cancel?'**
  String get cancelSubscriptionTitle;

  /// No description provided for @cancelSubscriptionWarning.
  ///
  /// In en, this message translates to:
  /// **'Once canceled, your account will be frozen and all posted cars will be hidden from the marketplace. You will lose access to subscription features until you reactivate.\n\nThis action can be reversed by renewing your subscription.'**
  String get cancelSubscriptionWarning;

  /// No description provided for @writeAReview.
  ///
  /// In en, this message translates to:
  /// **'Write a review...'**
  String get writeAReview;

  /// No description provided for @reviewExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'Tell others of your experience with this dealer...'**
  String get reviewExperienceHint;

  /// No description provided for @tapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate.'**
  String get tapToRate;

  /// No description provided for @ratingAndReviews.
  ///
  /// In en, this message translates to:
  /// **'Rating and reviews'**
  String get ratingAndReviews;

  /// No description provided for @noWrittenReview.
  ///
  /// In en, this message translates to:
  /// **'No written review'**
  String get noWrittenReview;

  /// No description provided for @memberSinceYear.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String memberSinceYear(int year);

  /// No description provided for @setMileageTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your {carTitle}\'s Mileage'**
  String setMileageTitle(String carTitle);

  /// No description provided for @setMileageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please input the real number for mileage, otherwise your listing won\'t be approved.'**
  String get setMileageSubtitle;

  /// No description provided for @kmUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmUnit;

  /// No description provided for @pleaseSelectMakeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a make first'**
  String get pleaseSelectMakeFirst;

  /// No description provided for @maxMileagePlus.
  ///
  /// In en, this message translates to:
  /// **'200,000 km+'**
  String get maxMileagePlus;

  /// No description provided for @maxPricePlus.
  ///
  /// In en, this message translates to:
  /// **'₪500,000+'**
  String get maxPricePlus;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @seatsRange.
  ///
  /// In en, this message translates to:
  /// **'{min} to {max} seats'**
  String seatsRange(int min, int max);

  /// No description provided for @provideTitleDescriptionFor.
  ///
  /// In en, this message translates to:
  /// **'Provide a title and description\nfor the car ({carTitle}) you are selling'**
  String provideTitleDescriptionFor(String carTitle);

  /// No description provided for @titleCharCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/25 characters'**
  String titleCharCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
