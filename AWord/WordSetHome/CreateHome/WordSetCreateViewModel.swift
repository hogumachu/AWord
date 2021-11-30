import UIKit

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
    
    func create(_ viewController: UIViewController, title: String?) {
        if let title = title, !title.isEmpty {
            storage.createSet(title: title)
        }
        
        coordinator.dismiss(viewController: viewController, animated: true)
    }
    
    func cancel(_ viewController: UIViewController) {
        coordinator.dismiss(viewController: viewController, animated: true)
    }
}
