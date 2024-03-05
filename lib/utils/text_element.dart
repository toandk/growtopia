enum TextElementType { hashtag, url, phonenumber, tag }

extension Reg on TextElementType {
  RegExp get regex {
    switch (this) {
      case TextElementType.hashtag:
        return RegExp(_hashTagRegex, multiLine: true);
      case TextElementType.url:
        return RegExp(_urlRegex, multiLine: true);
      case TextElementType.phonenumber:
        return RegExp(_phoneNumberRegex, multiLine: true);
      case TextElementType.tag:
        return RegExp(_tagRegex, multiLine: true);
    }
  }
}

const _symbols = '·・ー_';

const _numbers = '0-9０-９';

const _englishLetters = 'a-zA-Zａ-ｚＡ-Ｚ';

const _japaneseLetters = 'ぁ-んァ-ン一-龠';

const _koreanLetters = '\u1100-\u11FF\uAC00-\uD7A3';

const _spanishLetters = 'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ';

const _arabicLetters = '\u0621-\u064A';

const _thaiLetters = '\u0E00-\u0E7F';

const _detectionContentLetters = _symbols +
    _numbers +
    _englishLetters +
    _japaneseLetters +
    _koreanLetters +
    _spanishLetters +
    _arabicLetters +
    _thaiLetters;

const _hashTagRegex = '(?!\\n)(?:^|\\s)(#([$_detectionContentLetters]+))';

const _urlRegex = '((http|https)://)(www.)?'
    '[a-zA-Z0-9@:%._\\+~#?&//=]'
    '{2,256}\\.[a-z]'
    '{2,6}\\b([-a-zA-Z0-9@:%'
    '._\\+~#?&//=]*)';

const _phoneNumberRegex = '\\b[0-9]{8,11}\\b';

const _tagRegex = '(?:^|\\s|\$|[.])@[\\p{L}0-9_]*';
