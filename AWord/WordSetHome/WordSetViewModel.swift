import UIKit
import RxSwift
import RxDataSources

typealias WordSetSectionModel = AnimatableSectionModel<String, WordSet>

class WordSetViewModel: WordSetStorableViewModelType {
    struct Dependency {
        let coordinator: Coordinator
        let storage: WordSetStorageType
    }
    
    let coordinator: Coordinator
    let storage: WordSetStorageType
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<WordSetSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<WordSetSectionModel> { dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: WordSetTableViewCell.identifier, for: indexPath) as! WordSetTableViewCell
            
            cell.setItem(item: item)
            return cell
        }
        ds.canEditRowAtIndexPath = { _, _ in return true }
        ds.canMoveRowAtIndexPath = { _, _ in return true}
        return ds
    }()
    
    var wordSetList: Observable<[WordSetSectionModel]> {
        return storage.setList()
            .map { wordSetList -> [WordSetSectionModel] in
                var sectionModels: [WordSetSectionModel] = []
                
                wordSetList.forEach { wordSet in
                    let sectionModel = WordSetSectionModel(model: wordSet.title, items: [wordSet])
                    sectionModels.append(sectionModel)
                }
                
                return sectionModels
            }
    }
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.storage = dependency.storage
    }
    
    func itemSelected(tableView: UITableView, indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator.push(at: .main, scene: .list, model: indexPath.section, animated: true)
        
    }
    
    func create(_ viewController: UIViewController) {
        coordinator.modal(at: viewController, scene: .setCreate, animated: true)
    }
    
    func delete(indexPath: IndexPath) {
        storage.delete(at: indexPath.section)
    }
    
    func delete(wordSet: WordSet) {
        storage.delete(set: wordSet)
    }
    
    func move(source: IndexPath, destination: IndexPath) {
        storage.move(source: source.section, destination: destination.section)
    }
}
