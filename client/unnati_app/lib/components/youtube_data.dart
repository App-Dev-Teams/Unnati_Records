final List<String> youtubeUrls =[ //youtube
"https://youtu.be/6j-y4g2wnjc?si=Tui671KHMa4PSUZm",
"https://youtu.be/n0Y6rMF47MI?si=-Z09_ENMG7hWkuCh",
"https://youtu.be/mRdLUNHWiCU?si=pI3wLwmyOfBi8Zme",
"https://youtu.be/6lMoM77q1AU?si=mCvAUt30mG0oiKiu",
];
String? extractYoutubeVideoId(String url) { //returns the videId
  final RegExp regExp = RegExp(
    r'(?:v=|\/)([0-9A-Za-z_-]{11})',
    caseSensitive: false,
  );
  return regExp.firstMatch(url)?.group(1);
}