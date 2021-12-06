class TestResultViewModel: ViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let rightWords: [Word]
        let wrongWords: [Word]
    }
    
    let coordinator: Coordinator
    let rightWords: [Word]
    let wrongWords: [Word]
    lazy var total = rightWords.count + wrongWords.count

    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.rightWords = dependency.rightWords
        self.wrongWords = dependency.wrongWords
    }
}
