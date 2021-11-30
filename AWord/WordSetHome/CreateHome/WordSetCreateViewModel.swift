class WordSetCreateViewModel: WordSetStorableViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let storage: WordSetStorageType
    }
    
    let coordinator: Coordinator
    let storage: WordSetStorageType
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.storage = dependency.storage
    }
    
    func create(title: String?) {
        if let title = title, !title.isEmpty {
            storage.createSet(title: title)
        }
        
        coordinator.backTransition(transition: .dismiss, animated: true)
    }
    
    func cancel() {
        coordinator.backTransition(transition: .dismiss, animated: true)
    }
}
