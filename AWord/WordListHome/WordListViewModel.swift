import UIKit
import RxSwift
import RxDataSources

typealias WordSectionModel = AnimatableSectionModel<Int, Word>

class WordListViewModel {
    struct Dependency {
        let storage: WordStorageType
    }
    
    let storage: WordStorageType
    
    init(dependency: Dependency) {
        self.storage = dependency.storage
    }
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<WordSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<WordSectionModel> { _, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: WordListTableViewCell.identifier, for: indexPath) as! WordListTableViewCell
            cell.setItem(item: item)
            return cell
        }
        ds.canEditRowAtIndexPath = { _, _ in return true }
        return ds
    }()
    
    var wordList: Observable<[WordSectionModel]> {
        return storage.wordList()
    }
    
    func itemSelected(tableView: UITableView, at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? WordListTableViewCell
        cell?.flip()
    }
}
