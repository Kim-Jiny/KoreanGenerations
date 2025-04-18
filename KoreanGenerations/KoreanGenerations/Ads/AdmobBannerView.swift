//
//  AdmobBannerView.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/18/25.
//

import Foundation
import SwiftUI
import GoogleMobileAds

enum AdType {
    case mainBN, test
    
    var key: String {
        switch self {
        case .mainBN:
            return "ca-app-pub-2707874353926722/1085169737"
        case .test:
            return "ca-app-pub-3940256099942544/2934735716"
        }
    }
}

struct AdmobBannerView: UIViewControllerRepresentable {
    @Binding var isAdLoaded: Bool  // 광고 로딩 여부를 전달받기 위한 바인딩
    let adType: AdType
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isAdLoaded: $isAdLoaded)
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        let view = BannerView(adSize: AdSizeBanner)
        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = AdType.test.key
        #else
        view.adUnitID = adType.key
        #endif
        view.rootViewController = viewController
        view.delegate = context.coordinator
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: AdSizeBanner.size)
        view.load(Request())
        return viewController
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {

    }
    
    class Coordinator: NSObject, BannerViewDelegate {
        @Binding var isAdLoaded: Bool
        
        init(isAdLoaded: Binding<Bool>) {
            _isAdLoaded = isAdLoaded
        }
        
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("✅ bannerViewDidReceiveAd")
            isAdLoaded = true
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ bannerView didFailToReceiveAdWithError: \(error.localizedDescription)")
            isAdLoaded = false
        }

        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
          print("bannerViewDidDismissScreen")
        }
      }
}
