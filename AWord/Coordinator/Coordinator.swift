import UIKit
class Coordinator {
    struct Dependency {
        let window: UIWindow
        let storage: WordStorageType
    }
    
    struct SceneDependency {
        let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController
    }
    
    // MARK: Dependency
    
    let window: UIWindow
    let storage: WordStorageType
    
    // MARK: Scene Dependency
    
    let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController
    
    // MARK: Init
    
    init(dependency: Dependency, sceneDependency: SceneDependency) {
        self.window = dependency.window
        self.storage = dependency.storage
        self.wordListViewControllerFactory = sceneDependency.wordListViewControllerFactory
    }
    
}

// MARK: Scene Transition

extension Coordinator {
    func transition(scene: Scene, transition: Transition, animated: Bool) {
        
        let viewController = sceneFactory(scene: scene)
        
        switch transition {
        case .root:
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        case .push:
            return
        case .modal:
            return
        }
    }
    
    private func sceneFactory(scene: Scene) -> UIViewController {
        switch scene {
        case .list:
            let listVC = wordListViewControllerFactory(.init(viewModel: .init(dependency: .init(storage: storage))))
            return listVC
        }
    }
    
}

enum Scene {
    case list
}

enum Transition {
    case root
    case push
    case modal
}

