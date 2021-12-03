import RxSwift

class TestViewModel: ViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let words: Observable<[Word]>
    }
    
    let coordinator: Coordinator
    let words: Observable<[Word]>
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.words = dependency.words
    }
    
    func generateTestWords(words: [Word]) -> [TestWord] {
        if words.count >= 4 {
            var testWords: [TestWord] = []
            let shuffledWords = words.shuffled()
            
            let count = min(shuffledWords.count, 20)
            
            for i in 0..<count {
                var randomWords: [Word] = []
                
                while randomWords.count < 4 {
                    let randomNum = Int.random(in: 0..<count)
                    
                    if randomNum != i {
                        randomWords.append(shuffledWords[randomNum])
                    }
                }
                
                let testWord = TestWord(problem: shuffledWords[i], examples: randomWords)
                testWords.append(testWord)
            }
            
            return testWords
        } else {
            return []
        }
    }
}
