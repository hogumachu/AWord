import UIKit
import RxSwift
import RxDataSources

typealias WordSectionModel = AnimatableSectionModel<Int, Word>

class WordListViewModel: WordStorableViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let storage: WordStorageType
        let model: Int
    }
    
    let coordinator: Coordinator
    let storage: WordStorageType
    let model: Int
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.storage = dependency.storage
        self.model = dependency.model
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func create() {
        coordinator.transition(scene: .listCreate, transition: .modal, sectionStorage: storage, animated: true)
    }
    
    func delete(indexPath: IndexPath) {
        storage.delete(at: indexPath.row)
    }
}
