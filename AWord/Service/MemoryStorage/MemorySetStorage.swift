import Foundation
import RxSwift

class MemorySetStorage: WordSetStorageType {
    
    private var MOCK = [
        WordSet(
            title: "Day 1",
            sectionModel:
                WordSectionModel(
                    model: 0,
                    items: [
                        Word(definition: "A", meaning: "에이", insertDate: Date().addingTimeInterval(-10)),
                        Word(definition: "B", meaning: "비", insertDate: Date().addingTimeInterval(-20)),
                        Word(definition: "C", meaning: "씨", insertDate: Date().addingTimeInterval(-30)),
                    ]
                )
        ),
        WordSet(
            title: "Day 2",
            sectionModel:
                WordSectionModel(
                    model: 1,
                    items: [
                        Word(definition: "D", meaning: "디", insertDate: Date().addingTimeInterval(-40)),
                        Word(definition: "E", meaning: "이", insertDate: Date().addingTimeInterval(-50)),
                        Word(definition: "F", meaning: "에프", insertDate: Date().addingTimeInterval(-60)),
                    ]
                )
        ),
        WordSet(
            title: "Day 3",
            sectionModel:
                WordSectionModel(
                    model: 2,
                    items: [
                        Word(definition: "G", meaning: "지", insertDate: Date().addingTimeInterval(-70)),
                        Word(definition: "H", meaning: "에이치", insertDate: Date().addingTimeInterval(-80)),
                        Word(definition: "I", meaning: "아이", insertDate: Date().addingTimeInterval(-90)),
                    ]
                )
        ),
    ]
    
    private lazy var sectionModels = MOCK
    private lazy var store = BehaviorSubject<[WordSet]>(value: sectionModels)
    
    @discardableResult
    func setList() -> Observable<[WordSet]> {
        return store
    }
    
    @discardableResult
    func createSet(title: String) -> Observable<WordSet?> {
        if sectionModels.contains(where: { $0.identity == title }) {
            print("title:", title)
            return Observable.just(nil)
        }
        
        let wordSet = WordSet(title: title, sectionModel: WordSectionModel(model: sectionModels.count, items: []))
        
        sectionModels.append(wordSet)
        store.onNext(sectionModels)
        
        return Observable.just(wordSet)
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
            sectionModels[index].sectionModel.items.append(word)
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
    
    func sectionModel(model: Int) -> WordSet {
        return sectionModels[model]
    }
}
