import UIKit
class Coordinator {
    struct Dependency {
        let window: UIWindow
        let storage: WordSetStorageType
    }
    
    struct SceneDependency {
        let wordSetViewControllerFactory: (WordSetViewController.Dependency) -> WordSetViewController
        let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController
    }
    
    // MARK: Dependency
    
    let window: UIWindow
    let storage: WordSetStorageType
    
    // MARK: Scene Dependency
    
    let mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    lazy var currentViewController: UIViewController? = mainNavigationController.topViewController
    let wordSetViewControllerFactory: (WordSetViewController.Dependency) -> WordSetViewController
    let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController
    
    // MARK: Init
    
    init(dependency: Dependency, sceneDependency: SceneDependency) {
        self.window = dependency.window
        self.storage = dependency.storage
        
        self.wordSetViewControllerFactory = sceneDependency.wordSetViewControllerFactory
        self.wordListViewControllerFactory = sceneDependency.wordListViewControllerFactory
    }
    
}

// MARK: Scene Transition

extension Coordinator {
    func transition(scene: Scene, transition: Transition, animated: Bool) {

        let viewController = sceneFactory(scene: scene)

        switch transition {
        case .root:
            mainNavigationController.setViewControllers([viewController], animated: false)
            window.rootViewController = mainNavigationController
            window.makeKeyAndVisible()
        case .push:
            return
        case .modal:
            return
        }
    }
    
    func transition(scene: Scene, transition: Transition, model: Int, animated: Bool) {
        let viewController = sceneFactory(scene: scene, model: model)
        
        switch transition {
        case .root:
            window.rootViewController = viewController
            currentViewController = viewController
            window.makeKeyAndVisible()
        case .push:
            mainNavigationController.pushViewController(viewController, animated: true)
            return
        case .modal:
            currentViewController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func sceneFactory(scene: Scene) -> UIViewController {
        switch scene {
        case .set:
            let setVC = wordSetViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setVC
        case .list:
            return UIViewController()
        }
    }
    
    private func sceneFactory(scene: Scene, model: Int) -> UIViewController {
        switch scene {
        case .set:
            let setVC = wordSetViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setVC
        case .list:
            let wordSet = storage.sectionModel(model: model)
            let listStorage = MemoryStorage(dependency: .init(title: wordSet.title, sectionModel: wordSet.sectionModel, setStorage: storage))
            let listVC = wordListViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: listStorage, model: model))))
            return listVC
        }
    }
    
}

enum Scene {
    case set
    case list
}

enum Transition {
    case root
    case push
    case modal
}

