import Foundation
import RxSwift
import RxCocoa
import CoreData

class WordSetStorage: WordSetStorageType {
    struct Dependency {
        let modelName: String
    }
    
    let modelName: String
    
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
        let fetchRequest = NSFetchRequest<WordSetEntity>(entityName: "WordSet")
        let sort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        if let wordSets = try? context
            .fetch(fetchRequest)
            .map({ WordSet(entity: $0) }) {
            return wordSets
        }
        
        return []
    }()
    
    private lazy var store = BehaviorSubject<[WordSet]>(value: wordSets)
    
    func setList() -> Observable<[WordSet]> {
        return store
    }
    
    init(depedency: Dependency) {
        self.modelName = depedency.modelName
    }
    
    func createSet(title: String) -> Bool {
        if wordSets.contains(where: { $0.title == title }) {
            return false
        }
        
        let wordSet = WordSet(title: title)
        
        if let entity = NSEntityDescription.entity(forEntityName: "WordSet", in: context) {
            let entityObject = NSManagedObject(entity: entity, insertInto: context)
            wordSet.update(entityObject)
            
            wordSets.append(wordSet)
            wordSets.sort(by: { $0.title < $1.title })
            store.onNext(wordSets)
            
            return true
        }
        
        return false
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
    
    func move(source: Int, destination: Int) {
        
    }
}
