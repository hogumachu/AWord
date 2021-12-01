import RxSwift

protocol WordSetStorageType {
    @discardableResult
    func createSet(title: String) -> Bool
    
    @discardableResult
    func setList() -> Observable<[WordSet]>
    
    @discardableResult
    func update(set: WordSet, title: String) -> Observable<WordSet>
    func append(at: String, word: Word)
    
    @discardableResult
    func delete(set: WordSet) -> Observable<WordSet>
    func delete(at: Int)
    
    func move(source: Int, destination: Int)
    
    func sectionModel(model: WordSet) -> WordSet
}
