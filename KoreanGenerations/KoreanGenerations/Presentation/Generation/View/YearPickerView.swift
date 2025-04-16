//
//  YearPickerView.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation
import SwiftUI

struct YearPickerView: View {
    @Binding var selectedYear: Int
    @Binding var showYearPicker: Bool
    let years: [Int]
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            List(years, id: \.self) { year in
                Button(action: {
                    selectedYear = year
                    showYearPicker = false // 선택 후 드롭다운 숨기기
                }) {
                    Text("\(year)")
                        .font(.headline) // 폰트 스타일 통일
                        .background(Color.clear)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2) // 테두리 추가
                        )
                }
                .background(Color.clear)
                .padding(.horizontal) // 좌우 여백 추가
                .id(year) // 각 항목에 고유 id 추가
                .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                .listRowBackground(Color.clear) // 항목 사이 간격의 배경 설정
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle()) // 기본 리스트 스타일
            .background(Color.clear)
            .padding(.horizontal) // 전체 뷰의 좌우 여백 추가
            .cornerRadius(12) // 모서리 둥글게
            .padding(.top, 10) // 상단 여백
            .onAppear {
                // 뷰가 처음 나타날 때, 선택된 항목으로 스크롤
                scrollViewProxy.scrollTo(selectedYear, anchor: .center)
            }
        }
        .background(Color.clear)
    }
}
