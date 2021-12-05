import Foundation
import RxSwift
import RxCocoa

class TestViewModel: ViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let words: Observable<[Word]>
    }
    
    let coordinator: Coordinator
    let words: Observable<[Word]>
    private var testWords: [TestWord] = []
    private var page: Int = 1
    lazy var testObservable = BehaviorSubject<TestWord?>(value: nil)
    lazy var hasNext = BehaviorSubject<Bool>(value: false)
    lazy var isRight = BehaviorSubject<TestResult>(value: .normal)
    lazy var title = BehaviorSubject<String>(value: "")
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.words = dependency.words
    }
    
    func generateTestWords(words: [Word]) {
        if words.count >= 4 {
            var testWords: [TestWord] = []
            let shuffledWords = words.shuffled()
            
            let count = min(shuffledWords.count, 20)
            
            for i in 0..<count {
                var randomWords: [Word] = []
                
                while randomWords.count < 4 {
                    let randomNum = Int.random(in: 0..<count)
                    
                    if randomNum != i && !randomWords.contains(shuffledWords[randomNum]) {
                        randomWords.append(shuffledWords[randomNum])
                    }
                }
                
                let testWord = TestWord(problem: shuffledWords[i], examples: randomWords)
                testWords.append(testWord)
            }
            
            self.testWords = testWords
            testObservable.onNext(testWords[0])
            hasNext.onNext(true)
            
            title.onNext("1 / \(testWords.count)")
        }
    }
    
    func next() {
        if page != 0 && page == testWords.count {
            // TODO: - Test 결과 화면 출력
        }
        if page < testWords.count {
            testObservable.onNext(testWords[page])
            page += 1
        }
        if page == testWords.count {
            hasNext.onNext(false)
        }
        isRight.onNext(.normal)
        title.onNext("\(page) / \(testWords.count)")
    }
    
    func exampleDidTap(meaning: String?) {
        if let meaning = meaning, meaning == testWords[page - 1].problem.meaning {
            isRight.onNext(.right)
        } else {
            isRight.onNext(.wrong)
        }
    }
    
    func testResultAlert(testReuslt: TestResult) {
        switch testReuslt {
        case .normal:
            return
        case .right:
            AlertView.showCheckMark("정답입니다", "\(testWords[page - 1].problem.definition) - \(testWords[page - 1].problem.meaning)")
        case .wrong:
            AlertView.showXMark("오답입니다", "\(testWords[page - 1].problem.definition) - \(testWords[page - 1].problem.meaning)")
        }
        
        next()
    }
}

enum TestResult {
    case normal
    case right
    case wrong
}
