import UIKit

struct AppDependency {
    let coordinator: Coordinator
}

extension AppDependency {
    static func execute(window: UIWindow) -> AppDependency {
        let storage = WordSetStorage(depedency: .init(modelName: "AWord"))
        
        let wordSetViewControllerFactory: (WordSetViewController.Dependency) -> WordSetViewController = { dependency in
            return .init(dependency: dependency)
        }
        let wordSetCreateViewControllerFactory: (WordSetCreateViewController.Dependency) -> WordSetCreateViewController = { dependency in
            return .init(dependency: dependency)
        }
        let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController = { dependency in
            return .init(dependency: dependency)
        }
        let wordListCreateViewControllerFactory: (WordListCreateViewController.Dependency) -> WordListCreateViewController = { dependency in
            return .init(dependency: dependency)
        }
        let testViewControllerFactory: (TestViewController.Dependency) -> TestViewController = { dependency in
            return .init(dependency: dependency)
        }
        let testResultViewControllerFactory: (TestResultViewController.Dependency) -> TestResultViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        return .init(
            coordinator:
                    .init(
                        dependency: .init(
                            window: window,
                            storage: storage
                        ),
                        sceneDependency: .init(
                            wordSetViewControllerFactory: wordSetViewControllerFactory,
                            wordSetCreateViewControllerFactory: wordSetCreateViewControllerFactory,
                            wordListViewControllerFactory: wordListViewControllerFactory,
                            wordListCreateViewControllerFactory: wordListCreateViewControllerFactory,
                            testViewControllerFactory: testViewControllerFactory,
                            testResultViewControllerFactory: testResultViewControllerFactory
                        )
                    )
        )
    }
}

