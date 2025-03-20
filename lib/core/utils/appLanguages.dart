//by default language of the app

<<<<<<< HEAD
import 'package:eschool_teacher/app/models/appLanguage.dart';
=======
import 'package:madares_app_teacher/app/models/appLanguage.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

const String defaultLanguageCode = "ar";

//Add language code in this list
//visit this to find languageCode for your respective language
//https://developers.google.com/admin-sdk/directory/v1/languages
const List<AppLanguage> appLanguages = [
  //Please add language code here and language name
  AppLanguage(languageCode: "en", languageName: "English"),
  AppLanguage(languageCode: "ar", languageName: "عربي"),

  AppLanguage(languageCode: "hi", languageName: "हिन्दी - Hindi"),
  AppLanguage(languageCode: "ur", languageName: "اردو - Urdu"),
];
