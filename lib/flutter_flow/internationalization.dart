import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'tl'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? tlText = '',
  }) =>
      [enText, tlText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // login
  {
    'loe9uree': {
      'en': 'Quanby Geotagging',
      'tl': 'PCIC Geotagging',
    },
    '4okdmfv6': {
      'en': 'Welcome Back',
      'tl': 'Maligayang Pagbabalik',
    },
    'wd51ceym': {
      'en': 'Please sign in to continue',
      'tl': 'Mangyaring mag-sign in upang magpatuloy',
    },
    'dfm6pibp': {
      'en': 'Email Address',
      'tl': 'Email Address',
    },
    'ie3newb4': {
      'en': 'Enter your email address...',
      'tl': 'Ilagay ang iyong email address...',
    },
    's13svqys': {
      'en': '',
      'tl': '',
    },
    'ates91zw': {
      'en': 'Password',
      'tl': 'Password',
    },
    '0vxezk07': {
      'en': 'Enter your password...',
      'tl': 'Ilagay ang iyong password...',
    },
    'twjqjyyn': {
      'en': '',
      'tl': '',
    },
    'lvomy5y7': {
      'en': 'Log in',
      'tl': 'Mag-log in',
    },
    'jldei9fa': {
      'en': 'DON\'T DELETE Mar TESTING!',
      'tl': '',
    },
    'ze2n4vlq': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'cxwcjult': {
      'en': 'Email must be valid',
      'tl': 'Dapat valid ang email',
    },
    'bzdqtdr8': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'bi8ton4q': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'j7dhgc8q': {
      'en': 'Password must be atleast 8 characters',
      'tl': 'Dapat na hindi bababa sa 8 character ang password',
    },
    '9aqb52if': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'wg8l5x4u': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // settings
  {
    'xqwyoxrh': {
      'en': 'Settings',
      'tl': 'Mga setting',
    },
    '00if4ta7': {
      'en': 'Dark Mode',
      'tl': 'Dark Mode',
    },
    '10h4gixp': {
      'en': 'Light Mode',
      'tl': 'Light Mode',
    },
    'q6imwgsn': {
      'en': 'Edit Profile',
      'tl': 'I-edit ang Profile',
    },
    'n0xjnlm2': {
      'en': 'Change Password',
      'tl': 'Baguhin ang Password',
    },
    'i23guhwp': {
      'en': 'Support',
      'tl': 'Suporta',
    },
    '3r8ompzr': {
      'en': 'Download Maps',
      'tl': 'I-download ang Maps',
    },
    'xliyfzs6': {
      'en': 'Sync FTP',
      'tl': 'Nandito si Mar - Nagsi-sync Mula sa FTP',
    },
    'yttqc4w2': {
      'en': 'Sign Out',
      'tl': 'Mag-sign Out',
    },
    'kcupitz3': {
      'en': 'Settings',
      'tl': 'Mga setting',
    },
  },
  // chats
  {
    'pue7zwxs': {
      'en': 'Messages',
      'tl': 'Mga mensahe',
    },
    '0ovitz68': {
      'en': 'Conversations',
      'tl': 'Mga pag-uusap',
    },
    'i2p6e78d': {
      'en': 'You are offline.',
      'tl': 'Offline ka.',
    },
    'ks6c14gr': {
      'en': 'Compose',
      'tl': 'Mag-compose',
    },
    'qjs4iqx3': {
      'en': 'Messages',
      'tl': 'Mga mensahe',
    },
  },
  // editPassword
  {
    'gvf2mmiy': {
      'en': 'Change Password',
      'tl': 'Baguhin ang Password',
    },
    'zo0cddz7': {
      'en':
          'We will reset your password. Please enter the password and confirmation password below, and then confirm.',
      'tl':
          'Ire-reset namin ang iyong password. Mangyaring ipasok ang password at password sa pagkumpirma sa ibaba, at pagkatapos ay kumpirmahin.',
    },
    'jsat8wzg': {
      'en': 'Old Password',
      'tl': 'Lumang Password',
    },
    '9qdzutxx': {
      'en': 'Enter Old Password...',
      'tl': 'Ilagay ang Lumang Password...',
    },
    'tazvk7pb': {
      'en': '',
      'tl': '',
    },
    '6i3l397c': {
      'en': 'New Password',
      'tl': 'Bagong Password',
    },
    'h4q8epxo': {
      'en': 'Enter New Password...',
      'tl': 'Maglagay ng Bagong Password...',
    },
    'jyov0g3q': {
      'en': '',
      'tl': '',
    },
    'gfj61loc': {
      'en': 'Confirm Password',
      'tl': 'Kumpirmahin ang Password',
    },
    'h1tl8jic': {
      'en': 'Confirm New Password...',
      'tl': 'Kumpirmahin ang Bagong Password...',
    },
    'dj4grxau': {
      'en': '',
      'tl': '',
    },
    'mjwnfucf': {
      'en': 'Confirm Changes',
      'tl': 'Kumpirmahin ang Mga Pagbabago',
    },
    'c2yh7kit': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'jldhk7m2': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    '1ey470jp': {
      'en': 'Field is required',
      'tl': '',
    },
    'sdtn0uw3': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'idz4ks80': {
      'en': 'Field is required',
      'tl': '',
    },
    'qyls0mpf': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'i10lphec': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // editProfile
  {
    '23dohx91': {
      'en': 'Edit Profile',
      'tl': 'I-edit ang Profile',
    },
    'r9vm5mt1': {
      'en': 'Name',
      'tl': 'Pangalan',
    },
    '8kwpczkh': {
      'en': '',
      'tl': '',
    },
    'ntj2ozhk': {
      'en': 'Save Changes',
      'tl': 'I-save ang Mga Pagbabago',
    },
    'gg4hbnhb': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'k90ss0sh': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
  },
  // messages
  {
    '6z1j9pzp': {
      'en': 'Message..',
      'tl': '',
    },
    'd1j92j9g': {
      'en': 'Type your message here',
      'tl': '',
    },
    'e855r75w': {
      'en': '',
      'tl': '',
    },
    'zxojetjq': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // taskDetails
  {
    'mdd6huf5': {
      'en': 'ACI Form Details',
      'tl': '',
    },
    '50bcfk9g': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'x8d6g468': {
      'en': 'Farmer Name',
      'tl': 'Pangalan ng Magsasaka',
    },
    'webbx3lh': {
      'en': 'Address',
      'tl': 'Address',
    },
    'qfage2ic': {
      'en': 'Insurance Id',
      'tl': 'Insurance Id',
    },
    'ezx6meo9': {
      'en': 'Mobile Number',
      'tl': 'Numero ng Mobile',
    },
    'gvdbo0h6': {
      'en': 'Farmer Type',
      'tl': 'Uri ng Magsasaka',
    },
    '0blfogwv': {
      'en': 'Group Name',
      'tl': 'Pangalan ng Grupo',
    },
    'lst6ktx6': {
      'en': 'Group Address',
      'tl': 'Address ng Grupo',
    },
    'zv71woqo': {
      'en': 'Lender Name',
      'tl': 'Pangalan ng nagpapahiram',
    },
    'jl733wsk': {
      'en': 'Lender Address',
      'tl': 'Address ng nagpapahiram',
    },
    'zop5kb93': {
      'en': 'Region',
      'tl': 'Rehiyon',
    },
    'b12iqcln': {
      'en': 'CIC Number',
      'tl': 'Numero ng CIC',
    },
    'p1282pce': {
      'en': 'Farm Location',
      'tl': 'Lokasyon ng Bukid',
    },
    'hvb7985g': {
      'en': 'ACI Location Sketch Plan',
      'tl': 'Plano ng Sketch ng Lokasyon',
    },
    'cat2uvtb': {
      'en': 'North',
      'tl': 'Hilaga',
    },
    'hytwamsl': {
      'en': 'East',
      'tl': 'Silangan',
    },
    'qtzirwg5': {
      'en': 'South',
      'tl': 'Timog',
    },
    'gmqdadav': {
      'en': 'West',
      'tl': 'Kanluran',
    },
    'tsu0lxo2': {
      'en': 'ACI Form Details',
      'tl': 'Plano ng Sketch ng Lokasyon',
    },
    '792xrz3k': {
      'en': 'ACI Area',
      'tl': 'Lugar na Nakatanim',
    },
    'zxmreuh1': {
      'en': 'ACI - Date of Planting (DS)',
      'tl': 'Petsa ng Pagtanim (DS)',
    },
    'ncrtgoe1': {
      'en': 'ACI - Date of Planting (TP)',
      'tl': 'Petsa ng Pagtatanim (TP)',
    },
    'nzua63mv': {
      'en': 'ACI Variety',
      'tl': 'Iba\'t-ibang Binhi na Nakatanim',
    },
    'x4kj8jn6': {
      'en': 'Captured Area',
      'tl': '',
    },
    'yesr8tfi': {
      'en': 'Geotag',
      'tl': '',
    },
    'dgbzqn0h': {
      'en': 'Completed Actual  Details',
      'tl': 'Mga Detalye ng Nakumpletong Gawain',
    },
    'nd1fqdu9': {
      'en': 'Tracking Details',
      'tl': 'Mga Detalye sa Pagsubaybay',
    },
    'uxt6f9xl': {
      'en': 'Last Coordinates',
      'tl': 'Mga Huling Coordinate',
    },
    'or3srkkk': {
      'en': 'Track Date',
      'tl': 'Petsa ng Pagsubaybay',
    },
    '01tvwwxt': {
      'en': 'Total Area (ha)',
      'tl': 'Kabuuang Lugar (ha)',
    },
    'vp2u9vxf': {
      'en': 'Total Distance',
      'tl': 'Kabuuang Distansya',
    },
    'ho7vbock': {
      'en': 'Seed Details',
      'tl': '',
    },
    '762mtpey': {
      'en': 'Actual Variety',
      'tl': 'Uri',
    },
    'veh8acpl': {
      'en': 'Actual Seed Variety Planted\n(Corn/Rice)',
      'tl': 'Iba\'t-ibang',
    },
    'lnj6pjl7': {
      'en': 'Date Details',
      'tl': 'Kumpirmasyon ng Ahente',
    },
    '4s2psn11': {
      'en': 'Actual Area Planted',
      'tl': '',
    },
    'n91720z3': {
      'en': 'Actual - Date of Planting (DS)',
      'tl': '',
    },
    '3zj0x11r': {
      'en': 'Actual - Date of Planting (TP)',
      'tl': 'Petsa ng Pagtatanim (TP)',
    },
    'q51vy5pn': {
      'en': 'Agent Confirmation',
      'tl': '',
    },
    '966yfol9': {
      'en': 'Remarks',
      'tl': 'Remarks',
    },
    '7ftdujb6': {
      'en': 'Farmer Full Name:',
      'tl': 'Kinumpirma ni',
    },
    '8bdkh9n1': {
      'en': 'Inspector Full Name:',
      'tl': 'Inihanda Ni',
    },
    '65kky15n': {
      'en': 'Geotag',
      'tl': 'Geotag',
    },
    '7qj8fid9': {
      'en': 'Continue Form',
      'tl': 'Ipagpatuloy ang Form',
    },
    'auvo0ea6': {
      'en': 'Resubmit',
      'tl': 'Muling isumite',
    },
    '4jnx5njc': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // formSuccess
  {
    '0g4vu9er': {
      'en': 'Congrats!',
      'tl': 'Congrats!',
    },
    '4pa6ldza': {
      'en': 'Task ',
      'tl': 'Gawain',
    },
    'fa57m321': {
      'en': 'Well Done!',
      'tl': 'Magaling!',
    },
    'z6rup7cd': {
      'en': 'Go Home',
      'tl': 'Umuwi ka na',
    },
    'tg07lnkp': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // fail
  {
    'v6ssh8ir': {
      'en': 'Fail!',
      'tl': 'Nabigo!',
    },
    'jv3aqrf6': {
      'en': 'Continue',
      'tl': 'Magpatuloy',
    },
    'qki1g985': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // dashboard
  {
    '5q4it2k3': {
      'en': 'Task Overview',
      'tl': 'Pangkalahatang-ideya ng Gawain',
    },
    'j8akb40n': {
      'en': 'For Dispatch',
      'tl': 'Para sa Dispatch',
    },
    'qvw65nm7': {
      'en': 'Ongoing',
      'tl': 'Patuloy',
    },
    'gtnjyr06': {
      'en': 'Completed',
      'tl': 'Nakumpleto',
    },
    'ba2q7w08': {
      'en': 'For Dispatch',
      'tl': 'Para sa Dispatch',
    },
    'rtv7xf2z': {
      'en': 'View All',
      'tl': '',
    },
    'nxy1vlhk': {
      'en': 'Ongoing',
      'tl': 'Patuloy',
    },
    'qkt2eqsh': {
      'en': 'View All',
      'tl': '',
    },
    'c0a56ui1': {
      'en': 'Completed',
      'tl': 'Nakumpleto',
    },
    't3rlbw2l': {
      'en': 'View All',
      'tl': '',
    },
    '67jgj8w9': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // successProfile
  {
    'e2bluypq': {
      'en': 'Success!',
      'tl': 'Tagumpay!',
    },
    'ioe9pmrx': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // geotagging
  {
    'qx4ly86s': {
      'en': 'Address: ',
      'tl': 'Address:',
    },
    'lvzg53kl': {
      'en': 'Lng: ',
      'tl': 'Lng:',
    },
    'zuoev2f9': {
      'en': 'Lat: ',
      'tl': 'Lat:',
    },
    'cmxtd6yw': {
      'en': 'Finish',
      'tl': 'Tapusin',
    },
    '0o8w3vlv': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // mapTest
  {
    'yigfujp5': {
      'en': 'Offline Map',
      'tl': 'Offline na Mapa',
    },
    'p5v52glk': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // pcicMap
  {
    'hopzh8rp': {
      'en': 'Map Search',
      'tl': 'Paghahanap sa Mapa',
    },
    'xg5zqtpy': {
      'en': 'Downloaded',
      'tl': 'Na-download',
    },
    'idur2ho8': {
      'en': 'Map Download',
      'tl': 'Pag-download ng Mapa',
    },
    '8n2rvzxw': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // onboarding
  {
    '1sqjo09d': {
      'en': 'Welcome Agent!',
      'tl': 'Welcome Agent!',
    },
    'p9sqnvj6': {
      'en': 'to Quanby Geotagging Application!',
      'tl': 'sa PCIC Geotagging Application!',
    },
    'ip5y7sxk': {
      'en': 'Get Started',
      'tl': 'Magsimula',
    },
    'vy3o8pvi': {
      'en': 'Powered by ',
      'tl': 'Pinapatakbo ng',
    },
    'ei4kaehl': {
      'en': 'Quanby Solutions Inc.',
      'tl': 'Quanby Solutions Inc.',
    },
    's10teuws': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // sync
  {
    '2algl1qt': {
      'en': 'Sync Success',
      'tl': '',
    },
    'nzwziy9t': {
      'en': 'Dashboard',
      'tl': 'Dashboard',
    },
    'v3jq6q5p': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // ppirForm
  {
    'oco9wa86': {
      'en': 'Geotag',
      'tl': 'Geotag',
    },
    'vlpe8yky': {
      'en': 'Repeat Geotag',
      'tl': 'Ulitin ang Geotag',
    },
    '0er41e9i': {
      'en': 'Download',
      'tl': 'I-download',
    },
    'riev7l1c': {
      'en': 'Geotag Information',
      'tl': 'Impormasyon sa Geotag',
    },
    'si0nigj1': {
      'en': 'Last Coordinates',
      'tl': 'Mga Huling Coordinate',
    },
    'j4k9ydv4': {
      'en': 'Total Area (ha)',
      'tl': 'Kabuuang Lugar (ha)',
    },
    'bcn0bfjf': {
      'en': 'Date Time',
      'tl': 'Petsa Oras',
    },
    'wr9xhmty': {
      'en': 'Total Distance',
      'tl': 'Kabuuang Distansya',
    },
    'opc4bpk1': {
      'en': 'Farm Location',
      'tl': 'Lokasyon ng Bukid',
    },
    'l6pbtiio': {
      'en': 'Seed Variety',
      'tl': 'Iba\'t-ibang Binhi',
    },
    'n2eymfb9': {
      'en': 'rice',
      'tl': 'kanin',
    },
    '2fy8z531': {
      'en': 'corn',
      'tl': 'mais',
    },
    'fd5vtp4q': {
      'en': 'Select the Type of Rice ',
      'tl': 'Piliin ang Uri ng Bigas',
    },
    '9vpclvfb': {
      'en': 'Option 1',
      'tl': 'Opsyon 1',
    },
    'svwg4lfn': {
      'en': 'Please select...',
      'tl': 'Mangyaring pumili...',
    },
    'wx9ezblr': {
      'en': 'Search for an item...',
      'tl': 'Maghanap ng item...',
    },
    'aqzhnbj5': {
      'en': 'Select the Type of Corn ',
      'tl': 'Piliin ang Uri ng Mais',
    },
    'kyt3fdec': {
      'en': 'Option 1',
      'tl': 'Opsyon 1',
    },
    'frfbun0t': {
      'en': 'Please select...',
      'tl': 'Mangyaring pumili...',
    },
    'vkwu56pa': {
      'en': 'Search for an item...',
      'tl': 'Maghanap ng item...',
    },
    'n872ktx2': {
      'en': 'Area',
      'tl': 'Lugar',
    },
    'nuiqbq4u': {
      'en': 'Actual Area Planted',
      'tl': 'Aktwal na Lugar na Nakatanim',
    },
    'of9zu2fh': {
      'en': 'Actual Date of Planting (DS)',
      'tl': 'Aktwal na Petsa ng Pagtatanim (DS)',
    },
    'a0a2mg8u': {
      'en': 'Actual Date of Planting (TP)',
      'tl': 'Aktwal na Petsa ng Pagtatanim (TP)',
    },
    'g6bs1u02': {
      'en': 'Area',
      'tl': '',
    },
    'w9s8lti0': {
      'en': 'Base 64 (debug only)',
      'tl': '',
    },
    'f5is9k8s': {
      'en': 'Report Confirmation',
      'tl': 'Pagkumpirma ng Ulat',
    },
    'xd5quvbx': {
      'en': 'Remarks',
      'tl': 'Remarks',
    },
    '2slf6a8t': {
      'en': 'Farmer Full Name',
      'tl': 'Inihanda ni',
    },
    '0wibdp4s': {
      'en': 'Inspector Full Name',
      'tl': '',
    },
    'aae0jxzm': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'lgxphrlo': {
      'en': 'Save',
      'tl': 'I-save',
    },
    'wrod6how': {
      'en': 'Submit',
      'tl': 'Isumite',
    },
    'o22az3b7': {
      'en': 'Field is required',
      'tl': '',
    },
    'oq3mhjm9': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'n9qxzlnc': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'lyo38v9p': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    '1g01x7w4': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'p39e5zyx': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'qewwk8ln': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    '02h37snd': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'pj4tf8fn': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'wdmzq07s': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'vr769179': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    '7b8oy9gn': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'f7d4dwme': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'd2ckb6qg': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'x8h9ctg8': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'wb0thrhr': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'g73iojeh': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'p8ha20p3': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'q79tvmns': {
      'en': 'Must have a captured Image',
      'tl': 'Kinakailangan ang field',
    },
    '7uv8ljni': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'rny5ce43': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    '8ak57euk': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'hxfm3oxy': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    '39yrep96': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'gug2f3ir': {
      'en': 'Field is required',
      'tl': '',
    },
    'x5yedns4': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    '6k4ph13p': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // supportPage
  {
    'uj32qsjg': {
      'en': 'Welcome to support',
      'tl': 'Maligayang pagdating sa suporta',
    },
    't4e1n2ku': {
      'en': 'How can we help you?',
      'tl': 'Paano ka namin matutulungan?',
    },
    'jxxssi5q': {
      'en': 'Call Us',
      'tl': 'Tawagan Kami',
    },
    'cb36qij3': {
      'en': 'Feedback',
      'tl': 'Feedback',
    },
    'a7g4fvh0': {
      'en': 'Review FAQ\'s below',
      'tl': 'Suriin ang FAQ sa ibaba',
    },
    '6fkaz1l6': {
      'en': 'What is the PCIC Geotagging Mobile Application?',
      'tl': 'Ano ang PCIC Geotagging Mobile Application?',
    },
    'p1oe42iv': {
      'en':
          'The PCIC Geotagging Mobile Application is a tool designed to assist farmers and PCIC field officers in accurately geotagging and documenting agricultural lands. It helps in streamlining the process of insurance claims by providing precise geographical data of the insured crops. To ensure the most accurate geotagging results, we advise users to walk slowly while geotagging.',
      'tl':
          'Ang PCIC Geotagging Mobile Application ay isang tool na idinisenyo upang tulungan ang mga magsasaka at PCIC field officers sa tumpak na pag-geotagging at pagdodokumento ng mga lupang pang-agrikultura. Nakakatulong ito sa pag-streamline ng proseso ng mga claim sa insurance sa pamamagitan ng pagbibigay ng tumpak na heograpikal na data ng mga nakasegurong pananim. Upang matiyak ang pinakatumpak na resulta ng pag-geotagging, pinapayuhan namin ang mga user na maglakad nang dahan-dahan habang nagge-geotagging.',
    },
    'n4gust3z': {
      'en': 'Who can use the PCIC Geotagging Mobile Application?',
      'tl': 'Sino ang maaaring gumamit ng PCIC Geotagging Mobile Application?',
    },
    'zsw3n6yw': {
      'en':
          'The app is intended for use by PCIC field officers, accredited agents, and farmers who are involved in the crop insurance program.',
      'tl':
          'Ang app ay inilaan para sa paggamit ng PCIC field officers, accredited agent, at mga magsasaka na kasangkot sa crop insurance program.',
    },
    'racl5rk4': {
      'en': 'Can I use the application offline?',
      'tl': 'Maaari ko bang gamitin ang application nang offline?',
    },
    '54dme8do': {
      'en':
          'Yes, you can geotag locations offline. However, an internet connection is required to sync the data with the PCIC server once you are back online.',
      'tl':
          'Oo, maaari mong i-geotag ang mga lokasyon offline. Gayunpaman, kailangan ng koneksyon sa internet upang i-sync ang data sa PCIC server sa sandaling online ka na.',
    },
    '0s4k66lp': {
      'en': 'What to do if data error occurs?',
      'tl': '',
    },
    '8gbqahjo': {
      'en':
          'You can reset the tasks by going to the settings and clickign the Sync to FTP, then sync the tasks again. This way you will get the initial tasks fresh from the database.',
      'tl': '',
    },
    'iaed2gmv': {
      'en': 'Powered by:',
      'tl': 'Pinapatakbo ng:',
    },
    '7ytbdnzb': {
      'en': 'Quanby Solutions Inc.',
      'tl': 'Quanby Solutions Inc.',
    },
    'lg67t3sj': {
      'en': 'Get support',
      'tl': 'Kumuha ng suporta',
    },
    '9s1xr77j': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // callUs
  {
    'nupfvz8w': {
      'en': 'Call Us',
      'tl': 'Tawagan Kami',
    },
    'lrfdphye': {
      'en': 'Call us through our phone number',
      'tl': 'Tawagan kami sa pamamagitan ng aming numero ng telepono',
    },
    'voantubs': {
      'en': 'Phone Number:',
      'tl': 'Numero ng Telepono:',
    },
    'l24tzpzw': {
      'en': '0524311169',
      'tl': '0524311169',
    },
    'x1l0pduf': {
      'en': 'Support',
      'tl': 'Suporta',
    },
    'kgq160zz': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // sendFeedback
  {
    'u6v8cxw1': {
      'en': 'Send us your feedback',
      'tl': 'Ipadala sa amin ang iyong feedback',
    },
    'bwb2aldx': {
      'en': 'What is your Purpose?',
      'tl': 'Ano ang iyong Layunin?',
    },
    'bv7yxnab': {
      'en': 'Feedback',
      'tl': 'Feedback',
    },
    'ps8o96jz': {
      'en': 'Feedback',
      'tl': 'Feedback',
    },
    '6yihtdbo': {
      'en': 'Inquiry',
      'tl': 'Pagtatanong',
    },
    'nmsj2mj6': {
      'en': 'Comment',
      'tl': 'Magkomento',
    },
    'hfdktwd5': {
      'en': 'Suggestion',
      'tl': 'Mungkahi',
    },
    'z3u9d6fz': {
      'en': 'Bug Encountered',
      'tl': 'Ulat ng Bug',
    },
    'msi4fo1j': {
      'en': 'Choose the type of purpose',
      'tl': 'Piliin ang uri ng layunin',
    },
    'd9wispbd': {
      'en': 'Search for an item...',
      'tl': 'Maghanap ng item...',
    },
    'gd6lp3vu': {
      'en': 'Message',
      'tl': 'Mensahe',
    },
    '1ovjjhqy': {
      'en': 'Input your message here...',
      'tl': 'Ilagay ang iyong mensahe dito...',
    },
    'e112gj5d': {
      'en': 'Submit',
      'tl': 'Isumite',
    },
    'woi12gmx': {
      'en': 'Field is required',
      'tl': '',
    },
    'ty8qr8zr': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'deunldpx': {
      'en': 'Support',
      'tl': '',
    },
    'o65xm4kk': {
      'en': 'Home',
      'tl': '',
    },
  },
  // gpxSuccess
  {
    'v5pcnl69': {
      'en': 'Success!',
      'tl': '',
    },
    'dce7nls1': {
      'en': 'Home',
      'tl': '',
    },
  },
  // allTasks
  {
    'flnyt26u': {
      'en': 'Home',
      'tl': '',
    },
  },
  // mapTestTest
  {
    'seuh16v7': {
      'en': 'Offline Map K',
      'tl': '',
    },
    'tg8n88l3': {
      'en': 'Home',
      'tl': '',
    },
  },
  // tasks
  {
    '83q8pggh': {
      'en': 'Assignment Id',
      'tl': 'Assignment Id',
    },
    '0869xbo0': {
      'en': 'Address',
      'tl': 'Address',
    },
  },
  // chat
  {
    'fti6qnj7': {
      'en': 'Type here to respond...',
      'tl': 'Mag-type dito para tumugon...',
    },
  },
  // emptyLists
  {
    'qc74sp6j': {
      'en': 'No ',
      'tl': 'Hindi',
    },
    'hh1zsrbx': {
      'en': 'It seems that you don\'t have any recent activity.',
      'tl': 'Mukhang wala kang anumang kamakailang aktibidad.',
    },
  },
  // changePhoto
  {
    'n5sjoaqa': {
      'en': 'Change Photo',
      'tl': 'Baguhin ang Larawan',
    },
    'yjbcio9o': {
      'en':
          'Upload a new photo below in order to change your avatar seen by others.',
      'tl':
          'Mag-upload ng bagong larawan sa ibaba upang mapalitan ang iyong avatar na nakita ng iba.',
    },
    'wr32c2ky': {
      'en': 'Upload Image',
      'tl': 'Mag-upload ng Larawan',
    },
  },
  // signature
  {
    'nsefvndz': {
      'en': 'Signature',
      'tl': 'Lagda',
    },
  },
  // backupTasks
  {
    'd4vy1q7s': {
      'en': 'North: ',
      'tl': 'Hilaga:',
    },
    'c3uh2jd8': {
      'en': 'West: ',
      'tl': 'Kanluran:',
    },
    'fav0lit3': {
      'en': 'South: ',
      'tl': 'Timog:',
    },
    'c46yhefm': {
      'en': 'East: ',
      'tl': 'Silangan:',
    },
    '6ov3yzwq': {
      'en': 'Assignment Id',
      'tl': 'Assignment Id',
    },
    'ftz1qs3j': {
      'en': 'Address',
      'tl': 'Address',
    },
  },
  // signoutDialog
  {
    'pd2yz8ne': {
      'en': 'Confirm Sign Out',
      'tl': 'Kumpirmahin ang Pag-sign Out',
    },
    'q15wq9be': {
      'en': 'Are you sure you want to sign out?',
      'tl': 'Sigurado ka bang gusto mong mag-sign out?',
    },
    'm2zyxgem': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'quqrp02y': {
      'en': 'Sign Out',
      'tl': 'Mag-sign Out',
    },
  },
  // userChats
  {
    'gb6dx75i': {
      'en': 'Select User',
      'tl': 'Piliin ang User',
    },
    'hjf1n0gp': {
      'en': 'Randy Peterson',
      'tl': 'Randy Peterson',
    },
    'umnwo680': {
      'en': 'name@domainname.com',
      'tl': 'name@domainname.com',
    },
    '6770atir': {
      'en': 'Randy Peterson',
      'tl': 'Randy Peterson',
    },
    'ifqnarpx': {
      'en': 'name@domainname.com',
      'tl': 'name@domainname.com',
    },
    '7t4vwu9u': {
      'en': 'Randy Peterson',
      'tl': 'Randy Peterson',
    },
    'trqe09c9': {
      'en': 'name@domainname.com',
      'tl': 'name@domainname.com',
    },
  },
  // alertContinueDialog
  {
    '4poy7kn4': {
      'en': 'Alert',
      'tl': 'Alerto',
    },
    '5w0hrwzw': {
      'en':
          'The current gpx file will be deleted. \nAre you sure you want to continue?',
      'tl':
          'Ang kasalukuyang gpx file ay tatanggalin. \nSigurado ka bang gusto mong magpatuloy?',
    },
    '9nbvgmc2': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    '6qtpudw1': {
      'en': 'Sign Out',
      'tl': 'Mag-sign Out',
    },
  },
  // noInternetDialog
  {
    'm2d8uxk3': {
      'en': 'Info',
      'tl': 'Impormasyon',
    },
    'wreq3f64': {
      'en':
          'You have no current internet connection. To download a map, please connect to the internet.',
      'tl':
          'Wala kang kasalukuyang koneksyon sa internet. Upang mag-download ng mapa, mangyaring kumonekta sa internet.',
    },
    'x2kr3ijp': {
      'en': 'Dismiss',
      'tl': 'Kumonekta muli',
    },
  },
  // permissionDialog
  {
    'vsbe3eji': {
      'en': 'Notice',
      'tl': 'Pansinin',
    },
    'bsqylrb4': {
      'en':
          'You must be Online and the Location permission must be enabled to proceed.',
      'tl':
          'Dapat kang Online at dapat na pinagana ang pahintulot sa Lokasyon upang magpatuloy.',
    },
    'ighw54es': {
      'en': 'Okay',
      'tl': 'Okay',
    },
  },
  // continueReGeotagDialog
  {
    'txdl513w': {
      'en': 'Alert',
      'tl': 'Alerto',
    },
    'aevwr0vt': {
      'en':
          'The current gpx file will be deleted. \nAre you sure you want to continue?',
      'tl':
          'Ang kasalukuyang gpx file ay tatanggalin. \nSigurado ka bang gusto mong magpatuloy?',
    },
    'pol5d0m3': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'xhp3rkfj': {
      'en': 'Continue',
      'tl': 'Magpatuloy',
    },
  },
  // continueGoBackDialog
  {
    '6fpxyw60': {
      'en': 'Warning',
      'tl': 'Babala',
    },
    'zoypq20i': {
      'en':
          'This will cancel the current progress of geotagging. Do you want to continue?',
      'tl':
          'Kakanselahin nito ang kasalukuyang pag-usad ng geotagging. Gusto mo bang magpatuloy?',
    },
    '4m3l8rlv': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    '2temga0h': {
      'en': 'Continue',
      'tl': 'Magpatuloy',
    },
  },
  // continueSubmitDialog
  {
    '2gqa0lrn': {
      'en': 'For Confirmation',
      'tl': 'Impormasyon',
    },
    'x6p50a5s': {
      'en': 'Do you want to Submit all the data above?',
      'tl': 'Gusto mo bang Isumite ang lahat ng data sa itaas?',
    },
    '30viluzv': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'w7005adq': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // continueSaveDialog
  {
    'n8g6v3fj': {
      'en': 'Info',
      'tl': 'Impormasyon',
    },
    '8a42qjb7': {
      'en': 'Do you want to Save the data above?',
      'tl': 'Gusto mo bang I-save ang data sa itaas?',
    },
    'clidangu': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'nsdqb1mh': {
      'en': 'Continue',
      'tl': 'Magpatuloy',
    },
  },
  // continueCancelDialog
  {
    '4i07fax8': {
      'en': 'Warning',
      'tl': 'Babala',
    },
    'hg3q7i0o': {
      'en':
          'This will cancel your current progress in the tasks. Are you sure you want to cancel?',
      'tl':
          'Kakanselahin nito ang iyong kasalukuyang pag-unlad sa mga gawain. Sigurado ka bang gusto mong kanselahin?',
    },
    '7ytcjqdh': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'c75bzs2e': {
      'en': 'Continue',
      'tl': 'Magpatuloy',
    },
  },
  // fillOutAllFieldsDialog
  {
    'nfddva3z': {
      'en': 'Alert',
      'tl': 'Alerto',
    },
    'ctq3a7as': {
      'en': 'Please fill out all fields.',
      'tl': 'Mangyaring punan ang lahat ng mga patlang.',
    },
    'nzt0dax8': {
      'en': 'Okay',
      'tl': 'Okay',
    },
  },
  // uploadFailedDialog
  {
    'v46c8giv': {
      'en': 'Failed',
      'tl': 'Nabigo',
    },
    '014tcrks': {
      'en': 'Failed to upload to FTP.',
      'tl': 'Nabigong mag-upload sa FTP.',
    },
    'gn2n1vua': {
      'en': 'Okay',
      'tl': 'Okay',
    },
  },
  // continueSaveGeotag
  {
    'tvpwf4wx': {
      'en': 'Confirmation',
      'tl': '',
    },
    '0d8bu1tl': {
      'en': 'Are you want to save the geotagged area?',
      'tl': '',
    },
    'kiaksd3h': {
      'en': 'Cancel',
      'tl': '',
    },
    'y0pshty8': {
      'en': 'Confirm',
      'tl': '',
    },
  },
  // noGpxDialog
  {
    '4sv8tytx': {
      'en': 'Info',
      'tl': '',
    },
    '5pkk2ssu': {
      'en': 'No GPX Found!',
      'tl': '',
    },
    'kbahfjhr': {
      'en': 'Re-Geotag',
      'tl': '',
    },
  },
  // warningForSync
  {
    'bj5fwdr1': {
      'en': 'Warning',
      'tl': '',
    },
    'j12qx5tg': {
      'en': 'Cancel',
      'tl': '',
    },
    'mcwvr395': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // profileContainer
  {
    'yv0llftg': {
      'en': 'Welcome',
      'tl': '',
    },
    '5ds1p06s': {
      'en': 'Good morning ',
      'tl': '',
    },
    'um1b1tjj': {
      'en': '!',
      'tl': '',
    },
  },
  // tasksRow
  {
    'ows2z6ni': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'pw7ohr2y': {
      'en': 'Address',
      'tl': '',
    },
  },
  // Miscellaneous
  {
    '0ftylq1b': {
      'en':
          '\"PCIC Mobile Application requires access to your camera to enable geotagging. This feature will allow us to accurately tag photos with your current location, improving service delivery and documentation. Please grant camera access to continue.\"',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong camera upang paganahin ang geotagging. Ang tampok na ito ay magbibigay-daan sa amin upang tumpak na i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ang camera ng access upang magpatuloy.\"',
    },
    '2kgfkeu0': {
      'en':
          '\"PCIC Mobile Application requires access to your photo library to enable geotagging. This will help us select and tag photos with your current location, improving service delivery and documentation. Please grant photo library access to continue.\"',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong library ng larawan upang paganahin ang geotagging. Makakatulong ito sa amin na piliin at i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ng access sa library ng larawan upang magpatuloy.\"',
    },
    '9xlvkb3u': {
      'en':
          '\"PCIC Mobile Application requires access to your location to enable geotagging. This will allow us to accurately obtain GPX data with your current location, improving our service. Please grant location access to continue.\"',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong lokasyon upang paganahin ang geotagging. Ito ay magbibigay-daan sa amin na tumpak na makakuha ng data ng GPX sa iyong kasalukuyang lokasyon, pagpapabuti ng aming serbisyo. Mangyaring bigyan ng access sa lokasyon upang magpatuloy.\"',
    },
    'klzb3gt7': {
      'en': '',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong library ng larawan upang paganahin ang geotagging. Makakatulong ito sa amin na piliin at i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ng access sa library ng larawan upang magpatuloy.\"',
    },
    'wibvpqn3': {
      'en': '',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong camera upang paganahin ang geotagging. Ang tampok na ito ay magbibigay-daan sa amin upang tumpak na i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ang camera ng access upang magpatuloy.\"',
    },
    'hs555eff': {
      'en':
          'PCIC Mobile Application needs access to your location to enable Geotagging. This will help us accurately tag photos with your current location for better service delivery and documentation. Please grant location access to continue.',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong camera upang paganahin ang geotagging. Ang tampok na ito ay magbibigay-daan sa amin upang tumpak na i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ang camera ng access upang magpatuloy.\"',
    },
    'bzztgqlw': {
      'en': '',
      'tl': '',
    },
    'krsmb8tl': {
      'en': '',
      'tl': '',
    },
    'f4jve0im': {
      'en': '',
      'tl': '',
    },
    'ewy589yo': {
      'en': '',
      'tl': '',
    },
    'gnfsybzi': {
      'en': '',
      'tl': '',
    },
    'ukvuy6cu': {
      'en': '',
      'tl': '',
    },
    'gtbp0v1t': {
      'en': '',
      'tl': '',
    },
    'jcgvyvtj': {
      'en': '',
      'tl': '',
    },
    'fudyyijm': {
      'en': '',
      'tl': '',
    },
    '6belcyg0': {
      'en': '',
      'tl': '',
    },
    'suw462ve': {
      'en': '',
      'tl': '',
    },
    'lyghfiui': {
      'en': '',
      'tl': '',
    },
    '8ulvwwkv': {
      'en': '',
      'tl': '',
    },
    'sz6shdxb': {
      'en': '',
      'tl': '',
    },
    'klsd2ugc': {
      'en': '',
      'tl': '',
    },
    'ud5jbo3g': {
      'en': '',
      'tl': '',
    },
    'lrllsiiu': {
      'en': '',
      'tl': '',
    },
    'ut26nd9a': {
      'en': '',
      'tl': '',
    },
    'fmc974s7': {
      'en': '',
      'tl': '',
    },
    'b0js4q72': {
      'en': '',
      'tl': '',
    },
    'zl1r319i': {
      'en': '',
      'tl': '',
    },
    '43jzgspj': {
      'en': '',
      'tl': '',
    },
    'djw9fayn': {
      'en': '',
      'tl': '',
    },
    'hjnako4z': {
      'en': '',
      'tl': '',
    },
    'yciz7fe5': {
      'en': '',
      'tl': '',
    },
    'fybxjr1q': {
      'en': 'login',
      'tl': '',
    },
  },
].reduce((a, b) => a..addAll(b));
