import UIKit
import RxSwift
import RxDataSources

class TestResultViewModel: ViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let rightWords: [Word]
        let wrongWords: [Word]
    }
    
    let coordinator: Coordinator
    let rightWords: [Word]
    let wrongWords: [Word]
    lazy var total = rightWords.count + wrongWords.count
    
    var wordList: Observable<[WordSectionModel]> {
        let wrongWordsSectionModel = WordSectionModel(model: 0, items: wrongWords)
        let rightWordsSectionModel = WordSectionModel(model: 1, items: rightWords)
        return Observable<[WordSectionModel]>.just([wrongWordsSectionModel, rightWordsSectionModel])
    }
    let dataSource: RxCollectionViewSectionedAnimatedDataSource<WordSectionModel> = {
        let ds = RxCollectionViewSectionedAnimatedDataSource<WordSectionModel> { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestResultCollectionViewCell.identifier, for: indexPath) as! TestResultCollectionViewCell
            cell.setItem(item: item, indexPath.section)
            return cell
        }
        return ds
    }()
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.rightWords = dependency.rightWords
        self.wrongWords = dependency.wrongWords
    }
    
    func back(_ viewController: UIViewController) {
        coordinator.dismiss(viewController: viewController, animated: true)
    }
}
