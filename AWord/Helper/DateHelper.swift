import Foundation

class DateHelper {
    static let shared = DateHelper()
    private init() {}
    
    func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 / H시 m분"
        
        return formatter.string(from: date)
    }
}
