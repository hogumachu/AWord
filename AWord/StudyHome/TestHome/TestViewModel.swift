import RxSwift
import RxCocoa

class TestViewModel: ViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let words: Observable<[Word]>
    }
    
    let coordinator: Coordinator
    let words: Observable<[Word]>
    private lazy var testWords: [TestWord] = []
    private var page: Int = 1
    lazy var testObservable = BehaviorSubject<TestWord?>(value: nil)
    lazy var hasNext = BehaviorSubject<Bool>(value: false)
    
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
        }
    }
    
    func next() {
        if page < testWords.count {
            testObservable.onNext(testWords[page])
            page += 1
        }
        if page == testWords.count {
            hasNext.onNext(false)
        }
    }
    
}
