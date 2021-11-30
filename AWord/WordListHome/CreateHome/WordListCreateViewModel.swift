class WordListCreateViewModel: WordStorableViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let storage: WordStorageType
    }
    
    let coordinator: Coordinator
    let storage: WordStorageType
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.storage = dependency.storage
    }
    
    func create(definition: String?, meaning: String?) {
        if let definition = definition, let meaning = meaning, !definition.isEmpty, !meaning.isEmpty {
            storage.createWord(definition: definition, meaning: meaning)
        }
        
        coordinator.backTransition(transition: .dismiss, animated: true)
    }
    
    func cancel() {
        coordinator.backTransition(transition: .dismiss, animated: true)
    }
}
