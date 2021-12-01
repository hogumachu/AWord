import Foundation
import RxSwift

class MemorySetStorage: WordSetStorageType {
    
    private var MOCK = [
        WordSet(
            title: "Day 1"
        ),
        WordSet(
            title: "Day 2"
        ),
        WordSet(
            title: "Day 3"
        ),
    ]
    
    private lazy var sectionModels = MOCK
    private lazy var store = BehaviorSubject<[WordSet]>(value: sectionModels)
    
    @discardableResult
    func setList() -> Observable<[WordSet]> {
        return store
    }
    
    @discardableResult
    func createSet(title: String) -> Bool {
        if sectionModels.contains(where: { $0.identity == title }) {
            return false
        }
        
        let wordSet = WordSet(title: title)
        
        sectionModels.append(wordSet)
        store.onNext(sectionModels)
        
        return true
    }
    
    @discardableResult
    func update(set: WordSet, title: String) -> Observable<WordSet> {
        
        if let index = sectionModels.firstIndex(where: { $0 == set }) {
            sectionModels[index].title = title
            store.onNext(sectionModels)
        }
        
        return Observable.just(set)
    }
    
    func append(at title: String, word: Word) {
        if let index = sectionModels.firstIndex(where: { $0.identity == title }) {
            store.onNext(sectionModels)
        }
    }
    
    @discardableResult
    func delete(set: WordSet) -> Observable<WordSet> {
        if let index = sectionModels.firstIndex(where: { $0 == set }) {
            sectionModels.remove(at: index)
            store.onNext(sectionModels)
        }
        
        return Observable.just(set)
    }
    
    func delete(at index: Int) {
        if index < sectionModels.count {
            sectionModels.remove(at: index)
        }
        
        store.onNext(sectionModels)
    }
    
    func move(source: Int, destination: Int) {
        let tmp = sectionModels[source]
        sectionModels.remove(at: source)
        sectionModels.insert(tmp, at: destination)
        
        store.onNext(sectionModels)
    }
    
    func sectionModel(model: WordSet) -> WordSet {
        return model
    }
}
