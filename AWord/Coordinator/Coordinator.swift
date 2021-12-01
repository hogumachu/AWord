import UIKit
class Coordinator {
    
    // MARK: Dependency
    
    struct Dependency {
        let window: UIWindow
        let storage: WordSetStorageType
    }
    
    let window: UIWindow
    let storage: WordSetStorageType
    
    // MARK: Scene Dependency
    
    struct SceneDependency {
        let wordSetViewControllerFactory: (WordSetViewController.Dependency) -> WordSetViewController
        let wordSetCreateViewControllerFactory: (WordSetCreateViewController.Dependency) -> WordSetCreateViewController
        let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController
        let wordListCreateViewControllerFactory: (WordListCreateViewController.Dependency) -> WordListCreateViewController
    }
    
    let mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    lazy var currentViewController: UIViewController? = mainNavigationController.topViewController
    let wordSetViewControllerFactory: (WordSetViewController.Dependency) -> WordSetViewController
    let wordSetCreateViewControllerFactory: (WordSetCreateViewController.Dependency) -> WordSetCreateViewController
    let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController
    let wordListCreateViewControllerFactory: (WordListCreateViewController.Dependency) -> WordListCreateViewController
    
    // MARK: Init
    
    init(dependency: Dependency, sceneDependency: SceneDependency) {
        self.window = dependency.window
        self.storage = dependency.storage
        
        self.wordSetViewControllerFactory = sceneDependency.wordSetViewControllerFactory
        self.wordSetCreateViewControllerFactory = sceneDependency.wordSetCreateViewControllerFactory
        self.wordListViewControllerFactory = sceneDependency.wordListViewControllerFactory
        self.wordListCreateViewControllerFactory = sceneDependency.wordListCreateViewControllerFactory
    }
    
}

// MARK: Scene Transition

extension Coordinator {
    private func sceneFactory(scene: Scene) -> UIViewController {
        switch scene {
        case .set:
            let setVC = wordSetViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setVC
        case .setCreate:
            let setCreateVC = wordSetCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setCreateVC
        case .list:
            return UIViewController()
        case .listCreate:
            return UIViewController()
        }
    }
    
    private func sceneFactory(scene: Scene, model: Int) -> UIViewController {
        switch scene {
        case .set:
            let setVC = wordSetViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setVC
        case .setCreate:
            let setCreateVC = wordSetCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setCreateVC
        case .list:
            let coredataStorage = CoreDataWordStorage(dependency: .init(modelName: "AWord", title: "코어데이터"))
            let listVC = wordListViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: coredataStorage, model: 0))))
            return listVC
        case .listCreate:
            let wordSet = storage.sectionModel(model: WordSet(title: "abc"))
            let listStorage = MemoryStorage(dependency: .init(title: wordSet.title, setStorage: storage))
            let listCreateVC = wordListCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: listStorage))))
            return listCreateVC
        }
    }
    
    private func sceneFactory(scene: Scene, sectionStorage: WordStorageType) -> UIViewController {
        switch scene {
        case .listCreate:
            let listCreateVC = wordListCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: sectionStorage))))
            return listCreateVC
        default:
            return UIViewController()
        }
    }
    
    
    func root(scene: Scene, animated: Bool) {
        let viewController = sceneFactory(scene: scene)
        
        mainNavigationController.setViewControllers([viewController], animated: animated)
        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
    }
    
    func push(at navigation: NavigationScene, scene: Scene, animated: Bool) {
        let viewController = sceneFactory(scene: scene)
        
        switch navigation {
        case .main:
            mainNavigationController.pushViewController(viewController, animated: animated)
        }
        
    }
    
    func push(at navigation: NavigationScene, scene: Scene, model: Int, animated: Bool) {
        let viewController = sceneFactory(scene: scene, model: model)
        
        switch navigation {
        case .main:
            mainNavigationController.pushViewController(viewController, animated: animated)
        }
        
    }
    
    func modal(at parentViewController: UIViewController, scene: Scene, animated: Bool) {
        let viewController = sceneFactory(scene: scene)
        
        parentViewController.present(viewController, animated: animated, completion: nil)
    }
    
    func modal(at parentViewController: UIViewController, scene: Scene, sectionStorage: WordStorageType, animated: Bool) {
        let viewController = sceneFactory(scene: scene, sectionStorage: sectionStorage)
        
        parentViewController.present(viewController, animated: animated, completion: nil)
    }
    
    func pop(from navigation: NavigationScene, animated: Bool) {
        switch navigation {
        case .main:
            mainNavigationController.popViewController(animated: animated)
        }
    }
    
    func dismiss(viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

enum Scene {
    case set
    case setCreate
    case list
    case listCreate
}

enum Transition {
    case root
    case push
    case modal
}

enum BackTransition {
    case pop
    case dismiss
}

enum NavigationScene {
    case main
}

extension UIViewController {
    var firstChildren: UIViewController {
        return self.children.first ?? self
    }
}
