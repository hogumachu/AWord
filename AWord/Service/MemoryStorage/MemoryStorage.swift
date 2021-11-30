import RxSwift
import Foundation

class MemoryStorage: WordStorageType {
    struct Dependency {
        let title: String
        let sectionModel: WordSectionModel
        let setStorage: WordSetStorageType
    }
    
    let title: String
    var sectionModel: WordSectionModel
    let setStorage: WordSetStorageType
    
    init(dependency: Dependency) {
        self.title = dependency.title
        self.sectionModel = dependency.sectionModel
        self.setStorage = dependency.setStorage
    }
    
    private lazy var store = BehaviorSubject<[WordSectionModel]>(value: [sectionModel])
    
    @discardableResult
    func createWord(definition: String, meaning: String) -> Bool {
        let word = Word(definition: definition, meaning: meaning)
        
        sectionModel.items.append(word)
        store.onNext([sectionModel])
        setStorage.append(at: title, word: word)
        
        return true
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
    
    func delete(at index: Int) {
        if sectionModel.items.count > index {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
    }
}
