import UIKit

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
    
    func create(_ viewControoer: UIViewController, definition: String?, meaning: String?) {
        if let definition = definition, let meaning = meaning, !definition.isEmpty, !meaning.isEmpty {
            storage.createWord(definition: definition, meaning: meaning)
        }
        coordinator.dismiss(viewController: viewControoer, animated: true)
    }
    
    func cancel(_ viewController: UIViewController) {
        coordinator.dismiss(viewController: viewController, animated: true)
    }
}
