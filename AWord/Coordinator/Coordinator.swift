import UIKit
import RxSwift

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
        
        let testViewControllerFactory: (TestViewController.Dependency) -> TestViewController
        let testResultViewControllerFactory: (TestResultViewController.Dependency) -> TestResultViewController
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
    
    let testViewControllerFactory: (TestViewController.Dependency) -> TestViewController
    let testResultViewControllerFactory: (TestResultViewController.Dependency) -> TestResultViewController
    
    // MARK: Init
    
    init(dependency: Dependency, sceneDependency: SceneDependency) {
        self.window = dependency.window
        self.storage = dependency.storage
        
        self.wordSetViewControllerFactory = sceneDependency.wordSetViewControllerFactory
        self.wordSetCreateViewControllerFactory = sceneDependency.wordSetCreateViewControllerFactory
        self.wordListViewControllerFactory = sceneDependency.wordListViewControllerFactory
        self.wordListCreateViewControllerFactory = sceneDependency.wordListCreateViewControllerFactory
        
        self.testViewControllerFactory = sceneDependency.testViewControllerFactory
        self.testResultViewControllerFactory = sceneDependency.testResultViewControllerFactory
    }
    
}

// MARK: Scene Transition

extension Coordinator {
    
    // MARK: - Create Scene
    
    private func sceneFactory(scene: Scene) -> UIViewController {
        switch scene {
        case .set:
            let setVC = wordSetViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setVC
        case .setCreate:
            let setCreateVC = wordSetCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setCreateVC
        default:
            return UIViewController()
        }
    }
    
    private func sceneFactory(scene: Scene, title: String, model: String) -> UIViewController {
        switch scene {
        case .set:
            let setVC = wordSetViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setVC
        case .setCreate:
            let setCreateVC = wordSetCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: storage))))
            return setCreateVC
        case .list:
            let coredataStorage = WordStorage(dependency: .init(modelName: "AWord", title: title, parentIdentity: model))
            let listVC = wordListViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: coredataStorage, model: 0))))
            return listVC
        case .listCreate:
            let listStorage = WordStorage(dependency: .init(modelName: "AWord", title: title, parentIdentity: model))
            let listCreateVC = wordListCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: listStorage))))
            return listCreateVC
        default:
            return UIViewController()
        }
    }
    
    private func sceneFactory(scene: Scene, sectionStorage: WordStorageType) -> UIViewController {
        switch scene {
        case .listCreate:
            let listCreateVC = wordListCreateViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: sectionStorage))))
            return listCreateVC
        case .test:
            let testVC = testViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, storage: sectionStorage))))
            return testVC
        default:
            return UIViewController()
        }
    }
    
    private func sceneFactory(scene: Scene, rightWords: [Word], wrongWords: [Word], animated: Bool) -> UIViewController {
        switch scene {
        case .testResult:
            let testResultVC = testResultViewControllerFactory(.init(viewModel: .init(dependency: .init(coordinator: self, rightWords: rightWords, wrongWords: wrongWords))))
            return testResultVC
        default:
            return UIViewController()
        }
    }
    
    // MARK: - Scene Transition
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
    
    func push(at navigation: NavigationScene, scene: Scene, title: String, model: String, animated: Bool) {
        let viewController = sceneFactory(scene: scene, title: title, model: model)
        
        switch navigation {
        case .main:
            mainNavigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    func push(at navigation: NavigationScene, scene: Scene, sectionStorage: WordStorageType, animated: Bool) {
        let viewController = sceneFactory(scene: scene, sectionStorage: sectionStorage)
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
    
    func modal(at parentViewController: UIViewController, scene: Scene, rightWords: [Word], wrongWords: [Word], animated: Bool) {
        let viewController = sceneFactory(scene: scene, rightWords: rightWords, wrongWords: wrongWords, animated: animated)
        
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
