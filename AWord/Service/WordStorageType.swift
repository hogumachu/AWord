import RxSwift

protocol WordStorageType {
    var title: String { get }
    
    @discardableResult
    func createWord(definition: String, meaning: String) -> Bool
    
    @discardableResult
    func wordList() -> Observable<[WordSectionModel]>
    
    @discardableResult
    func update(word: Word, definition: String, meaning: String) -> Observable<Word>
    
    @discardableResult
    func delete(word: Word) -> Observable<Word>
    
    func delete(at: Int)
}
