//
//  SplashView.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation
import SwiftUI

struct SplashView: View {
@State private var isActive = false

var body: some View {
    ZStack {
        // 전체 배경 색상 지정
        Color(#colorLiteral(red: 0.6101606488, green: 0.4559624195, blue: 0.8276818395, alpha: 1))
            .edgesIgnoringSafeArea(.all)  // 화면 전체에 색상 적용

        VStack {
            if isActive {
                // 2. 메인 화면으로 이동
                ContentView()
            } else {
                // 3. 스플래시 화면 (로고 또는 텍스트 등)
                Image(ImageResource(name: "app.fill", bundle: .main)) // 또는 앱의 로고
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .onAppear {
                        // 4. 타이머로 메인 화면으로 전환
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
    }
}
}
