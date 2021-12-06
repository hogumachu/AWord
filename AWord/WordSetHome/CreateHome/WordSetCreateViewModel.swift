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
            if !storage.createSet(title: title) {
                AlertView.showXMark("동일한 제목으로 생성할 수 없습니다")
            }
        } else {
            AlertView.showXMark("빈 제목으로 생성할 수 없습니다")
        }
        
        coordinator.dismiss(viewController: viewController, animated: true)
    }
    
    func cancel(_ viewController: UIViewController) {
        coordinator.dismiss(viewController: viewController, animated: true)
    }
}
