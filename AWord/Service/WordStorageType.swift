import RxSwift

protocol WordStorageType {
    @discardableResult
    func createWord(definition: String, meaning: String) -> Observable<Word>
    
    @discardableResult
    func wordList() -> Observable<[WordSectionModel]>
    
    @discardableResult
    func update(word: Word, definition: String, meaning: String) -> Observable<Word>
    
    @discardableResult
    func delete(word: Word) -> Observable<Word>
}
