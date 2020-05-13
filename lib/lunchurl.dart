import 'package:url_launcher/url_launcher.dart';


class Lunch{
 static lunchwatsApp()async {
    String phoneNumber = '+20 1555777347';
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
 static lunchFaceBook()async {
    var faceBookUrl = "https://www.facebook.com/sevenplusclinics/";
    if (await canLaunch(faceBookUrl)) {
      await launch(faceBookUrl);
    } else {
      throw 'Could not launch $faceBookUrl';
    }
  }
 static lunchInsta()async {
    var instaUrl = "https://www.instagram.com/sevenplusclinics/?igshid=m0wad7dfzcek";
    if (await canLaunch(instaUrl)) {
      await launch(instaUrl);
    } else {
      throw 'Could not launch $instaUrl';
    }
  }
}