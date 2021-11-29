import RxSwift
import Foundation

class MemoryStorage: WordStorageType {
    
    private var MOCK = [
        Word(definition: "Hi", meaning: "안녕하세요", insertDate: Date().addingTimeInterval(-10)),
        Word(definition: "Bye", meaning: "안녕히계세요", insertDate: Date().addingTimeInterval(-20)),
        Word(definition: "Happy", meaning: "행복한", insertDate: Date().addingTimeInterval(-30))
    ]
    
    private lazy var sectionModel = WordSectionModel(model: 0, items: MOCK)
    
    private lazy var store = BehaviorSubject<[WordSectionModel]>(value: [sectionModel])
    
    @discardableResult
    func createWord(definition: String, meaning: String) -> Observable<Word> {
        let word = Word(definition: definition, meaning: meaning)
        sectionModel.items.insert(word, at: 0)
        store.onNext([sectionModel])
        
        return Observable.just(word)
    }
    
    @discardableResult
    func wordList() -> Observable<[WordSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(word: Word, definition: String, meaning: String) -> Observable<Word> {
        let updated = Word(original: word, definition: definition, meaning: meaning)
        
        if let index = sectionModel.items.firstIndex(where: { $0 == word }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(word: Word) -> Observable<Word> {
        if let index = sectionModel.items.firstIndex(where: { $0 == word }) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(word)
    }
}
