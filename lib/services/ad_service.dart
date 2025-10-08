import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/constants/app_constants.dart';

class AdService {
  static AdService? _instance;
  
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isRewardedAdReady = false;
  bool _isInterstitialAdReady = false;

  AdService._();

  static AdService getInstance() {
    _instance ??= AdService._();
    return _instance!;
  }

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadRewardedAd();
    loadInterstitialAd();
  }

  String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return AppConstants.androidRewardedAdId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AppConstants.androidInterstitialAdId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Rewarded Ad (for extra lives)
  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdReady = false;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedAdReady = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdReady = false;
          // Retry after 5 seconds
          Future.delayed(const Duration(seconds: 5), loadRewardedAd);
        },
      ),
    );
  }

  Future<bool> showRewardedAd(Function onRewarded) async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      return false;
    }

    bool rewarded = false;

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        onRewarded();
      },
    );

    return rewarded;
  }

  bool get isRewardedAdReady => _isRewardedAdReady;

  // Interstitial Ad (between games)
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          Future.delayed(const Duration(seconds: 5), loadInterstitialAd);
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      await _interstitialAd!.show();
    }
  }

  bool get isInterstitialAdReady => _isInterstitialAdReady;

  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
  }
}

