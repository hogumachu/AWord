import RxSwift

protocol WordSetStorageType {
    @discardableResult
    func createSet(title: String) -> Observable<WordSet?>
    
    @discardableResult
    func setList() -> Observable<[WordSet]>
    
    @discardableResult
    func update(set: WordSet, title: String) -> Observable<WordSet>
    
    func append(at: String, word: Word)
    
    @discardableResult
    func delete(set: WordSet) -> Observable<WordSet>
    
    func sectionModel(model: Int) -> WordSet
}
