import 'package:url_launcher/url_launcher.dart';

Future<void> openyoutubeVideo(String videoId) async { //checking that whether the devide has youtube app or not 
//if device have yotube app then open on app
//else open on web
  final Uri url =
      Uri.parse("https://www.youtube.com/watch?v=$videoId");

  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}
