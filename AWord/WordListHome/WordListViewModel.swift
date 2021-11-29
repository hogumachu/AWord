import RxDataSources

typealias WordSectionModel = AnimatableSectionModel<Int, Word>

class WordListViewModel {
    struct Dependency {
        let storage: WordStorageType
    }
    
    let storage: WordStorageType
    
    init(dependency: Dependency) {
        self.storage = dependency.storage
    }
}
