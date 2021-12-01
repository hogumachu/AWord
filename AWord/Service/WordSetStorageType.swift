import RxSwift

protocol WordSetStorageType {
    @discardableResult
    func createSet(title: String) -> Bool
    
    @discardableResult
    func setList() -> Observable<[WordSet]>
    
    @discardableResult
    func update(set: WordSet, title: String) -> Observable<WordSet>
    
    @discardableResult
    func delete(set: WordSet) -> Observable<WordSet>
    
    func move(source: Int, destination: Int)
   
}
