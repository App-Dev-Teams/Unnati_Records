import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @youAre.
  ///
  /// In en, this message translates to:
  /// **'You are'**
  String get youAre;

  /// No description provided for @volunteer.
  ///
  /// In en, this message translates to:
  /// **'volunteer'**
  String get volunteer;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get dontHaveAnAccount;

  /// No description provided for @oopessomethingwentwrong.
  ///
  /// In en, this message translates to:
  /// **'Oopes something went wrong'**
  String get oopessomethingwentwrong;

  /// No description provided for @nointernet.
  ///
  /// In en, this message translates to:
  /// **'No Internet'**
  String get nointernet;

  /// No description provided for @unnatisociety.
  ///
  /// In en, this message translates to:
  /// **'Unnati Society'**
  String get unnatisociety;

  /// No description provided for @socialoutreachinitiative.
  ///
  /// In en, this message translates to:
  /// **'Social Outreach Initiative'**
  String get socialoutreachinitiative;

  /// No description provided for @clickonanyprogramcardtoexploreindetail.
  ///
  /// In en, this message translates to:
  /// **'Click on any program card to explore in detail'**
  String get clickonanyprogramcardtoexploreindetail;

  /// No description provided for @whatisunnati.
  ///
  /// In en, this message translates to:
  /// **'What is Unnati?'**
  String get whatisunnati;

  /// No description provided for @unnatisocietyisaninstituteoutreachactivityandsocialoutreachinitiativeassociatedwithiIITbhagalpurfocusedonempoweringunderprivilegedcommunitiesthrougheducationmentorshipliteracyanddigitalinclusion.
  ///
  /// In en, this message translates to:
  /// **'Unnati Society is an Institute Outreach Activity and social outreach initiative associated with IIIT Bhagalpur, focused on empowering underprivileged communities through education, mentorship, literacy, and digital inclusion.'**
  String get unnatisocietyisaninstituteoutreachactivityandsocialoutreachinitiativeassociatedwithiIITbhagalpurfocusedonempoweringunderprivilegedcommunitiesthrougheducationmentorshipliteracyanddigitalinclusion;

  /// No description provided for @iIITbhagalpur.
  ///
  /// In en, this message translates to:
  /// **'IIIT Bhagalpur'**
  String get iIITbhagalpur;

  /// No description provided for @aninstituteofnationalimportance.
  ///
  /// In en, this message translates to:
  /// **'An Institute of National Importance'**
  String get aninstituteofnationalimportance;

  /// No description provided for @sabourbhagalpurbihar813210india.
  ///
  /// In en, this message translates to:
  /// **'Sabour, Bhagalpur, Bihar 813210, India'**
  String get sabourbhagalpurbihar813210india;

  /// No description provided for @taptoexplore.
  ///
  /// In en, this message translates to:
  /// **'Tap to explore'**
  String get taptoexplore;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @educationalempowerment.
  ///
  /// In en, this message translates to:
  /// **'Educational Empowerment'**
  String get educationalempowerment;

  /// No description provided for @socialempowerment.
  ///
  /// In en, this message translates to:
  /// **'Social Empowerment'**
  String get socialempowerment;

  /// No description provided for @youthdevelopment.
  ///
  /// In en, this message translates to:
  /// **'Youth Development'**
  String get youthdevelopment;

  /// No description provided for @communityimpact.
  ///
  /// In en, this message translates to:
  /// **'Community Impact'**
  String get communityimpact;

  /// No description provided for @mEEToURdEVELOPERS.
  ///
  /// In en, this message translates to:
  /// **' MEET OUR DEVELOPERS'**
  String get mEEToURdEVELOPERS;

  /// No description provided for @mentor.
  ///
  /// In en, this message translates to:
  /// **'Mentor'**
  String get mentor;

  /// No description provided for @backenddevelopers.
  ///
  /// In en, this message translates to:
  /// **'Backend Developers'**
  String get backenddevelopers;

  /// No description provided for @frontenddevelopers.
  ///
  /// In en, this message translates to:
  /// **'Frontend Developers'**
  String get frontenddevelopers;

  /// No description provided for @linkedIn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedIn;

  /// No description provided for @enteryouremailaddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enteryouremailaddress;

  /// No description provided for @pleaseenteryouremail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseenteryouremail;

  /// No description provided for @sendoTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendoTP;

  /// No description provided for @enteroTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enteroTP;

  /// No description provided for @pleaseentera6digitoTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 6-digit OTP'**
  String get pleaseentera6digitoTP;

  /// No description provided for @verifyoTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyoTP;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @enternewpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enternewpassword;

  /// No description provided for @reenternewpassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reenternewpassword;

  /// No description provided for @pleasefillbothpasswordfields.
  ///
  /// In en, this message translates to:
  /// **'Please fill both password fields'**
  String get pleasefillbothpasswordfields;

  /// No description provided for @passwordsdonotmatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsdonotmatch;

  /// No description provided for @changepassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changepassword;

  /// No description provided for @notallowed.
  ///
  /// In en, this message translates to:
  /// **'Not allowed'**
  String get notallowed;

  /// No description provided for @onlystudentscancreatedoubts.
  ///
  /// In en, this message translates to:
  /// **'Only students can create doubts.'**
  String get onlystudentscancreatedoubts;

  /// No description provided for @oK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get oK;

  /// No description provided for @doubtcreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Doubt created successfully.'**
  String get doubtcreatedsuccessfully;

  /// No description provided for @createdoubt.
  ///
  /// In en, this message translates to:
  /// **'Create Doubt'**
  String get createdoubt;

  /// No description provided for @submitdoubt.
  ///
  /// In en, this message translates to:
  /// **'Submit Doubt'**
  String get submitdoubt;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @adddoubt.
  ///
  /// In en, this message translates to:
  /// **'Add Doubt'**
  String get adddoubt;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @permissionrevoked.
  ///
  /// In en, this message translates to:
  /// **'Permission revoked.'**
  String get permissionrevoked;

  /// No description provided for @messagemustbebetween5and300characters.
  ///
  /// In en, this message translates to:
  /// **'Message must be between 5 and 300 characters.'**
  String get messagemustbebetween5and300characters;

  /// No description provided for @doubtresolvedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Doubt resolved successfully.'**
  String get doubtresolvedsuccessfully;

  /// No description provided for @doubtthread.
  ///
  /// In en, this message translates to:
  /// **'Doubt Thread'**
  String get doubtthread;

  /// No description provided for @youdonothavepermissiontoviewthisdoubt.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this doubt.'**
  String get youdonothavepermissiontoviewthisdoubt;

  /// No description provided for @goback.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goback;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @typeyourmessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get typeyourmessage;

  /// No description provided for @helpsupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpsupport;

  /// No description provided for @doubtsupport.
  ///
  /// In en, this message translates to:
  /// **'Doubt Support'**
  String get doubtsupport;

  /// No description provided for @asktrackandresolvelearningdoubtsfromoneplace.
  ///
  /// In en, this message translates to:
  /// **'Ask, track, and resolve learning doubts from one place.'**
  String get asktrackandresolvelearningdoubtsfromoneplace;

  /// No description provided for @mydoubts.
  ///
  /// In en, this message translates to:
  /// **'My Doubts'**
  String get mydoubts;

  /// No description provided for @createandtrackyourdoubtthreads.
  ///
  /// In en, this message translates to:
  /// **'Create and track your doubt threads.'**
  String get createandtrackyourdoubtthreads;

  /// No description provided for @opendoubts.
  ///
  /// In en, this message translates to:
  /// **'Open Doubts'**
  String get opendoubts;

  /// No description provided for @closeddoubts.
  ///
  /// In en, this message translates to:
  /// **'Closed Doubts'**
  String get closeddoubts;

  /// No description provided for @viewresolveddoubtthreads.
  ///
  /// In en, this message translates to:
  /// **'View resolved doubt threads.'**
  String get viewresolveddoubtthreads;

  /// No description provided for @akshar.
  ///
  /// In en, this message translates to:
  /// **'Akshar'**
  String get akshar;

  /// No description provided for @empoweringyoungmindswiththeskillsoftomorrow.
  ///
  /// In en, this message translates to:
  /// **'Empowering young minds with the skills of tomorrow'**
  String get empoweringyoungmindswiththeskillsoftomorrow;

  /// No description provided for @digiXplore.
  ///
  /// In en, this message translates to:
  /// **'DigiXplore'**
  String get digiXplore;

  /// No description provided for @netritva.
  ///
  /// In en, this message translates to:
  /// **'Netritva'**
  String get netritva;

  /// No description provided for @careerguidancementorshipprogram.
  ///
  /// In en, this message translates to:
  /// **'Career Guidance & Mentorship Program'**
  String get careerguidancementorshipprogram;

  /// No description provided for @askyourdoubthere.
  ///
  /// In en, this message translates to:
  /// **'Ask your doubt here...'**
  String get askyourdoubthere;

  /// No description provided for @noassignmentsavailable.
  ///
  /// In en, this message translates to:
  /// **'No assignments available'**
  String get noassignmentsavailable;

  /// No description provided for @invalidfilelink.
  ///
  /// In en, this message translates to:
  /// **'Invalid file link'**
  String get invalidfilelink;

  /// No description provided for @taptoopenthepDF.
  ///
  /// In en, this message translates to:
  /// **'Tap to open the PDF'**
  String get taptoopenthepDF;

  /// No description provided for @nofilesuploadedinthisfolderyet.
  ///
  /// In en, this message translates to:
  /// **'No files uploaded in this folder yet'**
  String get nofilesuploadedinthisfolderyet;

  /// No description provided for @digiXploresyllabus.
  ///
  /// In en, this message translates to:
  /// **'DigiXplore Syllabus'**
  String get digiXploresyllabus;

  /// No description provided for @browsefoldersandopenuploadedstudypDFs.
  ///
  /// In en, this message translates to:
  /// **'Browse folders and open uploaded study PDFs'**
  String get browsefoldersandopenuploadedstudypDFs;

  /// No description provided for @nofoldersavailableyet.
  ///
  /// In en, this message translates to:
  /// **'No folders available yet'**
  String get nofoldersavailableyet;

  /// No description provided for @uploadedpDFswillappearherewhenadminaddsthem.
  ///
  /// In en, this message translates to:
  /// **'Uploaded PDFs will appear here when admin adds them.'**
  String get uploadedpDFswillappearherewhenadminaddsthem;

  /// No description provided for @assignmentsbooklets.
  ///
  /// In en, this message translates to:
  /// **'Assignments Booklets'**
  String get assignmentsbooklets;

  /// No description provided for @previousquizpdfs.
  ///
  /// In en, this message translates to:
  /// **'Previous Quiz Pdfs'**
  String get previousquizpdfs;

  /// No description provided for @mydownloads.
  ///
  /// In en, this message translates to:
  /// **'My Downloads'**
  String get mydownloads;

  /// No description provided for @commentyourdoubts.
  ///
  /// In en, this message translates to:
  /// **'Comment Your Doubts!'**
  String get commentyourdoubts;

  /// No description provided for @nodownloadsyet.
  ///
  /// In en, this message translates to:
  /// **'No downloads yet'**
  String get nodownloadsyet;

  /// No description provided for @deletedownload.
  ///
  /// In en, this message translates to:
  /// **'Delete Download?'**
  String get deletedownload;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @youhaventtakenanyquizzesyet.
  ///
  /// In en, this message translates to:
  /// **'You haven’t taken any quizzes yet'**
  String get youhaventtakenanyquizzesyet;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @notespDFs.
  ///
  /// In en, this message translates to:
  /// **'Notes •  PDFs'**
  String get notespDFs;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @challengeyourknowledge.
  ///
  /// In en, this message translates to:
  /// **'Challenge Your Knowledge'**
  String get challengeyourknowledge;

  /// No description provided for @assistanceatyourfingertips.
  ///
  /// In en, this message translates to:
  /// **'Assistance at your fingertips'**
  String get assistanceatyourfingertips;

  /// No description provided for @developers.
  ///
  /// In en, this message translates to:
  /// **'Developers'**
  String get developers;

  /// No description provided for @meetourdevelopers.
  ///
  /// In en, this message translates to:
  /// **'Meet our developers'**
  String get meetourdevelopers;

  /// No description provided for @aboutus.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutus;

  /// No description provided for @ourstoryandvision.
  ///
  /// In en, this message translates to:
  /// **'Our story and vision'**
  String get ourstoryandvision;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editprofile;

  /// No description provided for @updateyourpersonalinformation.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updateyourpersonalinformation;

  /// No description provided for @profileupdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileupdated;

  /// No description provided for @savechanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get savechanges;

  /// No description provided for @confirmlogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmlogout;

  /// No description provided for @areyousureyouwanttologout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areyousureyouwanttologout;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @contactinformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactinformation;

  /// No description provided for @moredetails.
  ///
  /// In en, this message translates to:
  /// **'More Details'**
  String get moredetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// No description provided for @noquizzesavailable.
  ///
  /// In en, this message translates to:
  /// **'No quizzes available'**
  String get noquizzesavailable;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @selectprogram.
  ///
  /// In en, this message translates to:
  /// **'Select Program'**
  String get selectprogram;

  /// No description provided for @searchvolunteername.
  ///
  /// In en, this message translates to:
  /// **'Search volunteer name'**
  String get searchvolunteername;

  /// No description provided for @myattendance.
  ///
  /// In en, this message translates to:
  /// **'My Attendance'**
  String get myattendance;

  /// No description provided for @attendancesummary.
  ///
  /// In en, this message translates to:
  /// **'Attendance Summary'**
  String get attendancesummary;

  /// No description provided for @monthwisestats.
  ///
  /// In en, this message translates to:
  /// **'Monthwise Stats'**
  String get monthwisestats;

  /// No description provided for @totalworkshopstaken.
  ///
  /// In en, this message translates to:
  /// **'Total Workshops Taken'**
  String get totalworkshopstaken;

  /// No description provided for @totalworkshopsmissed.
  ///
  /// In en, this message translates to:
  /// **'Total Workshops Missed'**
  String get totalworkshopsmissed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @viewyourattendance.
  ///
  /// In en, this message translates to:
  /// **'View Your Attendance'**
  String get viewyourattendance;

  /// No description provided for @oURpROGRAMS.
  ///
  /// In en, this message translates to:
  /// **'OUR PROGRAMS'**
  String get oURpROGRAMS;

  /// No description provided for @openandresolvestudentdoubts.
  ///
  /// In en, this message translates to:
  /// **'Open and resolve student doubts'**
  String get openandresolvestudentdoubts;

  /// No description provided for @studentsnmentored.
  ///
  /// In en, this message translates to:
  /// **'Students mentored'**
  String get studentsnmentored;

  /// No description provided for @text1200.
  ///
  /// In en, this message translates to:
  /// **'4500+'**
  String get text1200;

  /// No description provided for @classestaken.
  ///
  /// In en, this message translates to:
  /// **'Classes taken'**
  String get classestaken;

  /// No description provided for @text500.
  ///
  /// In en, this message translates to:
  /// **'500+'**
  String get text500;

  /// No description provided for @interactiveliveclassesbridgingthedigitalgap.
  ///
  /// In en, this message translates to:
  /// **'Interactive live classes bridging the digital gap'**
  String get interactiveliveclassesbridgingthedigitalgap;

  /// No description provided for @holisticmentorshipdoubtsessionsforholisticgrowth.
  ///
  /// In en, this message translates to:
  /// **'Holistic mentorship & doubt sessions for holistic growth'**
  String get holisticmentorshipdoubtsessionsforholisticgrowth;

  /// No description provided for @nukkadclasses.
  ///
  /// In en, this message translates to:
  /// **'Nukkad classes'**
  String get nukkadclasses;

  /// No description provided for @viewyourattendance2.
  ///
  /// In en, this message translates to:
  /// **'View  Your Attendance'**
  String get viewyourattendance2;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @batchstartyear.
  ///
  /// In en, this message translates to:
  /// **'Batch Start Year'**
  String get batchstartyear;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @uploadfile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadfile;

  /// No description provided for @uploadsuccessful.
  ///
  /// In en, this message translates to:
  /// **'Upload successful'**
  String get uploadsuccessful;

  /// No description provided for @addfile.
  ///
  /// In en, this message translates to:
  /// **'Add File'**
  String get addfile;

  /// No description provided for @couldnotopenfile.
  ///
  /// In en, this message translates to:
  /// **'Could not open file'**
  String get couldnotopenfile;

  /// No description provided for @editfile.
  ///
  /// In en, this message translates to:
  /// **'Edit File'**
  String get editfile;

  /// No description provided for @filerenamedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File renamed successfully.'**
  String get filerenamedsuccessfully;

  /// No description provided for @failedtorenamefile.
  ///
  /// In en, this message translates to:
  /// **'Failed to rename file.'**
  String get failedtorenamefile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deletefile.
  ///
  /// In en, this message translates to:
  /// **'Delete File'**
  String get deletefile;

  /// No description provided for @filename.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get filename;

  /// No description provided for @addsubject.
  ///
  /// In en, this message translates to:
  /// **'Add Subject'**
  String get addsubject;

  /// No description provided for @class6.
  ///
  /// In en, this message translates to:
  /// **'Class 6'**
  String get class6;

  /// No description provided for @class7.
  ///
  /// In en, this message translates to:
  /// **'Class 7'**
  String get class7;

  /// No description provided for @class8.
  ///
  /// In en, this message translates to:
  /// **'Class 8'**
  String get class8;

  /// No description provided for @class9.
  ///
  /// In en, this message translates to:
  /// **'Class 9'**
  String get class9;

  /// No description provided for @class10.
  ///
  /// In en, this message translates to:
  /// **'Class 10'**
  String get class10;

  /// No description provided for @class11.
  ///
  /// In en, this message translates to:
  /// **'Class 11'**
  String get class11;

  /// No description provided for @class12.
  ///
  /// In en, this message translates to:
  /// **'Class 12'**
  String get class12;

  /// No description provided for @allclasses.
  ///
  /// In en, this message translates to:
  /// **'All Classes'**
  String get allclasses;

  /// No description provided for @subjectwithsameclassalreadyexists.
  ///
  /// In en, this message translates to:
  /// **'Subject with same class already exists'**
  String get subjectwithsameclassalreadyexists;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @nosubjectsaddedyet.
  ///
  /// In en, this message translates to:
  /// **'No subjects added yet'**
  String get nosubjectsaddedyet;

  /// No description provided for @editsubject.
  ///
  /// In en, this message translates to:
  /// **'Edit Subject'**
  String get editsubject;

  /// No description provided for @allclasses2.
  ///
  /// In en, this message translates to:
  /// **'All classes'**
  String get allclasses2;

  /// No description provided for @deletesubject.
  ///
  /// In en, this message translates to:
  /// **'Delete Subject'**
  String get deletesubject;

  /// No description provided for @subjectname.
  ///
  /// In en, this message translates to:
  /// **'Subject Name'**
  String get subjectname;

  /// No description provided for @eMPOWERINGdREAMS.
  ///
  /// In en, this message translates to:
  /// **'EMPOWERING DREAMS'**
  String get eMPOWERINGdREAMS;

  /// No description provided for @jointhejourneyofbridgingthedigitaldividethroughdigiXplorenetritvaakshar.
  ///
  /// In en, this message translates to:
  /// **'Join the journey to bring a positive change through your knowledge'**
  String get jointhejourneyofbridgingthedigitaldividethroughdigiXplorenetritvaakshar;

  /// No description provided for @areyouaproudmember.
  ///
  /// In en, this message translates to:
  /// **'Are you a proud member ?'**
  String get areyouaproudmember;

  /// No description provided for @yES.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yES;

  /// No description provided for @nO.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get nO;

  /// No description provided for @pleaseenteravalidemail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseenteravalidemail;

  /// No description provided for @pleaseenteryourpassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseenteryourpassword;

  /// No description provided for @forgotpassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotpassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseenteravalidiIITBHemail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid IIITBH email'**
  String get pleaseenteravalidiIITBHemail;

  /// No description provided for @signupas.
  ///
  /// In en, this message translates to:
  /// **'Sign Up As '**
  String get signupas;

  /// No description provided for @pleaseenteryourname.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseenteryourname;

  /// No description provided for @namemustbeatleast3characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get namemustbeatleast3characters;

  /// No description provided for @pleaseenterapassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseenterapassword;

  /// No description provided for @passwordmustbeatleast6characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordmustbeatleast6characters;

  /// No description provided for @pleaseenteryourphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseenteryourphonenumber;

  /// No description provided for @phonenumbermustbe10digits.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get phonenumbermustbe10digits;

  /// No description provided for @pleaseselectyourclass.
  ///
  /// In en, this message translates to:
  /// **'Please select your class'**
  String get pleaseselectyourclass;

  /// No description provided for @pleaseenteryourschoolname.
  ///
  /// In en, this message translates to:
  /// **'Please enter your school name'**
  String get pleaseenteryourschoolname;

  /// No description provided for @selectclass.
  ///
  /// In en, this message translates to:
  /// **'Select Class'**
  String get selectclass;

  /// No description provided for @selectschool.
  ///
  /// In en, this message translates to:
  /// **'Select School'**
  String get selectschool;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @phonenumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phonenumber;

  /// No description provided for @pleaseselectaprogram.
  ///
  /// In en, this message translates to:
  /// **'Please select a program'**
  String get pleaseselectaprogram;

  /// No description provided for @downloadprogress.
  ///
  /// In en, this message translates to:
  /// **'Download Progress'**
  String get downloadprogress;

  /// No description provided for @classLabel6.
  ///
  /// In en, this message translates to:
  /// **'Class 6'**
  String get classLabel6;

  /// No description provided for @classLabel7.
  ///
  /// In en, this message translates to:
  /// **'Class 7'**
  String get classLabel7;

  /// No description provided for @classLabel8.
  ///
  /// In en, this message translates to:
  /// **'Class 8'**
  String get classLabel8;

  /// No description provided for @classLabel9.
  ///
  /// In en, this message translates to:
  /// **'Class 9'**
  String get classLabel9;

  /// No description provided for @classLabel10.
  ///
  /// In en, this message translates to:
  /// **'Class 10'**
  String get classLabel10;

  /// No description provided for @classLabel11.
  ///
  /// In en, this message translates to:
  /// **'Class 11'**
  String get classLabel11;

  /// No description provided for @classLabel12.
  ///
  /// In en, this message translates to:
  /// **'Class 12'**
  String get classLabel12;

  /// No description provided for @allClasses.
  ///
  /// In en, this message translates to:
  /// **'All Classes'**
  String get allClasses;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
