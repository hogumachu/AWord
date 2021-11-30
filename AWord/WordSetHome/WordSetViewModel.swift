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
    
    func itemSelected(indexPath: IndexPath) {
        
        coordinator.transition(scene: .list, transition: .push, model: indexPath.section, animated: true)
    }
    
    func create() {
        storage.createSet(title: "자동 생성")
    }
}
