import RxSwift

protocol WordStorageType {
    var title: String { get }
    var parentIdentity: String { get }
    
    @discardableResult
    func createWord(definition: String, meaning: String) -> Bool
    
    @discardableResult
    func wordList() -> Observable<[WordSectionModel]>
    
    @discardableResult
    func update(word: Word, definition: String, meaning: String) -> Observable<Word>
    
    func updateComplete(word: Word, complete: Bool)
    
    @discardableResult
    func delete(word: Word) -> Observable<Word>
}
