import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  Future<InitializationStatus> initialization;

  AdService(this.initialization);

  String nativeAdId = 'ca-app-pub-3940256099942544/2247696110';

  static NativeAdListener listener = NativeAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onAdImpression: (Ad ad) => print('Ad impression.'),
    onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
  );
}
