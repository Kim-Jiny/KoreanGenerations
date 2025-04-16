//
//  ContactViewModel.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation
import Firebase

class ContactViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var message: String = ""
    
    func sendContact(completion: @escaping (Bool) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd/HH" // "YYYY-MM-DD-HH" 형태로 설정
        let timestamp = dateFormatter.string(from: Date()) // 현재 날짜를 포맷된 문자열로 변환
        
        // Firebase에 데이터 전송
        let db = Database.database().reference()
        let contactRef = db.child("contacts").childByAutoId()
        
        contactRef.setValue([
            "email": email,
            "message": message,
            "timestamp": timestamp
        ]) { error, _ in
            if let error = error {
                print("Error saving contact: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
