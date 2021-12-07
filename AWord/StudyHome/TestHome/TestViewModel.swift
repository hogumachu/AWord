import Foundation
import RxSwift
import RxCocoa
import UIKit
import AVFoundation

class TestViewModel: WordStorableViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let storage: WordStorageType
    }
    
    let coordinator: Coordinator
    let storage: WordStorageType
    
    var wordList: Observable<[WordSectionModel]> {
        return storage.wordList()
    }
    
    func words() -> Observable<[Word]> {
        return wordList
            .map {
                $0[0].items
            }
    }
    private var testWords: [TestWord] = []
    private var page: Int = 1
    lazy var testObservable = BehaviorSubject<TestWord?>(value: nil)
    lazy var hasNext = BehaviorSubject<Bool>(value: false)
    lazy var isRight = BehaviorSubject<TestResult>(value: .normal)
    lazy var title = BehaviorSubject<String>(value: "")
    private var testRightWords: [Word] = []
    private var testWrongWords: [Word] = []
//    private let synthesizer = AVSpeechSynthesizer()
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.storage = dependency.storage
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
    
    private func updateComplete() {
        testRightWords
            .forEach {
                storage.updateComplete(word: $0, complete: true)
            }
        
        testWrongWords
            .forEach {
                storage.updateComplete(word: $0, complete: false)
            }
    }
    
    func next(_ viewController: UIViewController) {
        AudioImpl.shared.stop()
        
        if page != 0 && page == testWords.count {
            updateComplete()
            coordinator.modal(at: viewController, scene: .testResult, rightWords: testRightWords, wrongWords: testWrongWords, animated: true)
            coordinator.pop(from: .main, animated: false)
            return
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
            testRightWords.append(testWords[page - 1].problem)
            isRight.onNext(.right)
        } else {
            testWrongWords.append(testWords[page - 1].problem)
            isRight.onNext(.wrong)
        }
    }
    
    func testResultAlert(_ viewController: UIViewController, testReuslt: TestResult) {
        switch testReuslt {
        case .normal:
            return
        case .right:
            if !(page != 0 && page == testWords.count) {
                AlertView.showCheckMark(
                    "정답입니다",
                    """
                    \(testWords[page - 1].problem.definition)
                    \(testWords[page - 1].problem.meaning)
                    """
                )
            }
        case .wrong:
            if !(page != 0 && page == testWords.count) {
                AlertView.showXMark(
                    "오답입니다",
                    """
                    \(testWords[page - 1].problem.definition)
                    \(testWords[page - 1].problem.meaning)
                    """
                )
            }
        }
        
        next(viewController)
    }
    
    func speak() {
        AudioImpl.shared.speak(text: testWords[page - 1].problem.definition)
    }
}

enum TestResult {
    case normal
    case right
    case wrong
}
