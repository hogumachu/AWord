import AVFoundation

class AudioImpl {
    static let shared = AudioImpl()
    private init() {}
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: text)
            
            utterance.voice = isKR(text: text) ? AVSpeechSynthesisVoice(language: "ko-KR") : AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.4
            synthesizer.speak(utterance)
        }
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    private func isKR(text: String) -> Bool {
        let arr = Array(text)
        
        let pattern = "^[가-힣ㄱ-ㅎㅏ]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count {
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
}
