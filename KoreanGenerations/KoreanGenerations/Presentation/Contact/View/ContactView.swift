//
//  ContactView.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//
import Foundation
import SwiftUI

struct ContactView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: ContactViewModel
    @State private var showAlert = false
    @State private var showEmptyMessageAlert = false  // 빈 문의 내용 경고
    
    init() {
        _viewModel = StateObject(wrappedValue: ContactViewModel())
    }

    var body: some View {
        Form {
            Section(header: Text("이메일")) {
                TextField("답변받을 이메일을 입력해주세요.", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }

            Section(header: Text("문의 내용")) {
                TextEditor(text: $viewModel.message)
                    .frame(height: 150)
            }

            Section {
                Button(action: {
                    // 문의 내용이 비어있으면 알림 띄우기
                    if viewModel.message.isEmpty {
                        showEmptyMessageAlert = true
                    } else {
                        // Firebase로 데이터 저장
                        viewModel.sendContact { success in
                            if success {
                                // 성공적인 전송 후 알림 띄우기
                                showAlert = true
                            } else {
                                // 실패 처리 (옵션)
                                showEmptyMessageAlert = true
                            }
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("전송")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .alert("문의 완료", isPresented: $showAlert)  {
                    Button("확인") {
                        dismiss() // ✅ 확인을 누르면 페이지 닫기
                    }
                } message: {
                    Text("성공적으로 전송되었습니다.")
                }
                .alert(isPresented: $showEmptyMessageAlert) {
                    Alert(title: Text("입력 오류"), message: Text("문의 내용을 입력해주세요."), dismissButton: .default(Text("확인")))
                }
            }
        }
        .navigationTitle("문의하기")
    }
}
