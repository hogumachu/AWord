import UIKit

struct AppDependency {
    let coordinator: Coordinator
}

extension AppDependency {
    static func execute(window: UIWindow) -> AppDependency {
        let storage = MemoryStorage()
        
        let wordListViewControllerFactory: (WordListViewController.Dependency) -> WordListViewController = { dependency in
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
                            wordListViewControllerFactory: wordListViewControllerFactory
                        )
                    )
        )
    }
}

