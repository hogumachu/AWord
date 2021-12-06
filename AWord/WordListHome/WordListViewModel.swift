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
    
    func words() -> Observable<[Word]> {
        return wordList
            .map {
                $0[0].items
            }
    }
    
    func itemSelected(tableView: UITableView, at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? WordListTableViewCell
        cell?.flip()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func create(_ viewController: UIViewController) {
        coordinator.modal(at: viewController, scene: .listCreate, sectionStorage: storage, animated: true)
    }
    
    func delete(word: Word) {
        storage.delete(word: word)
    }
    
    func test() {
        words()
            .bind(with: self) { vm, words in
                if words.count >= 5 {
                    vm.coordinator.push(at: .main, scene: .test, sectionStorage: vm.storage, animated: true)
                } else {
                    AlertView.showXMark("단어 5 개 이상부터 가능합니다")
                }
            }
            .dispose()
        
    }
}
