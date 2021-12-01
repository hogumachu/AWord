import Foundation
import RxSwift
import RxCocoa
import CoreData

class CoreDataWordSetStorage: WordSetStorageType {
    struct Dependency {
        let modelName: String
    }
    
    let modelName: String
    
    init(depedency: Dependency) {
        self.modelName = depedency.modelName
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private lazy var wordSets: [WordSet] = {
        if let wordSets = try? context.fetch(WordSetEntity.fetchRequest()).map({ WordSet(entity: $0) }) {
            return wordSets
        }
        
        return []
    }()
    
    private lazy var store = BehaviorSubject<[WordSet]>(value: wordSets)
    
    func createSet(title: String) -> Bool {
        let wordSet = WordSet(title: title)
        
        if let entity = NSEntityDescription.entity(forEntityName: "WordSet", in: context) {
            let entityObject = NSManagedObject(entity: entity, insertInto: context)
            wordSet.update(entityObject)
            
            wordSets.append(wordSet)
            store.onNext(wordSets)
            
            return true
        }
        
        return false
    }
    
    func setList() -> Observable<[WordSet]> {
        return store
    }
    
    func update(set: WordSet, title: String) -> Observable<WordSet> {
        let updated = WordSet(original: set, title: title)
        
        if let entity = NSEntityDescription.entity(forEntityName: "WordSet", in: context) {
            let entityObject = NSManagedObject(entity: entity, insertInto: context)
            updated.update(entityObject)
            
            wordSets.append(updated)
            store.onNext(wordSets)
            
            return Observable.just(updated)
        }
        
        return Observable.just(set)
    }
    
    func append(at: String, word: Word) {
        // ??
    }
    
    func delete(set: WordSet) -> Observable<WordSet> {
        do {
            let objects = try context.fetch(WordSetEntity.fetchRequest())
            let wordObjects = try context.fetch(WordEntity.fetchRequest()).filter { $0.identity == set.identity }
        
            if let object = objects.first(where: { $0.identity == set.identity}), let index = wordSets.firstIndex(where: { $0.identity == object.identity }) {
                context.delete(object)
                
                wordObjects.forEach {
                    context.delete($0)
                }
                
                try context.save()
                
                wordSets.remove(at: index)
                store.onNext(wordSets)
            }
            
            return Observable.just(set)
        } catch {
            return Observable.error(error)
        }
    }
    
    func delete(at: Int) {
        // TODO
    }
    
    func move(source: Int, destination: Int) {
        // TODO
    }
    
    func sectionModel(model: WordSet) -> WordSet {
        return WordSet(title: "asdasd")
    }
    
    
}
