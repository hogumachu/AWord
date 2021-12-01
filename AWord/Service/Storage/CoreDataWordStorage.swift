import Foundation
import RxSwift
import RxCocoa
import CoreData

class CoreDataWordStorage: WordStorageType {
    struct Dependency {
        let modelName: String
        let title: String
    }
    
    let modelName: String
    var title: String
    
    init(dependency: Dependency) {
        self.modelName = dependency.modelName
        self.title = dependency.title
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
    
    func createWord(definition: String, meaning: String) -> Bool {
        let word = Word(definition: definition, meaning: meaning)
        
        if let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) {
            let entityObject = NSManagedObject(entity: entity, insertInto: context)
            word.update(entityObject)
            
            sectionModel.items.append(word)
            store.onNext([sectionModel])
            
            return true
        }
        
        return false
    }
    
    private lazy var sectionModel: WordSectionModel = {
        if let words = try? context.fetch(WordEntity.fetchRequest())
            .map({ Word(entity: $0) }) {
                return WordSectionModel(model: 0, items: words)
            }
        return WordSectionModel(model: 0, items: [])
    }()
    
    private lazy var store = BehaviorSubject<[WordSectionModel]>(value: [sectionModel])
    
    func wordList() -> Observable<[WordSectionModel]> {
        return store
    }
    
    func update(word: Word, definition: String, meaning: String) -> Observable<Word> {
        let updated = Word(original: word, definition: definition, meaning: meaning)
        
        if let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) {
            let entityObject = NSManagedObject(entity: entity, insertInto: context)
            updated.update(entityObject)
            
            sectionModel.items.append(updated)
            store.onNext([sectionModel])
            
            return Observable.just(updated)
        }
        
        return Observable.just(word)
    }
    
    func delete(word: Word) -> Observable<Word> {
        do {
            let objects = try context.fetch(WordEntity.fetchRequest())
            
            if let object = objects.first(where: { $0.identity == word.identity }),
               let index = sectionModel.items.firstIndex(where: { $0.identity == object.identity }) {
                context.delete(object)
                try context.save()
                
                sectionModel.items.remove(at: index)
                store.onNext([sectionModel])
            }
            return Observable.just(word)
        } catch {
            return Observable.error(error)
        }
    }
    
    func delete(at: Int) {
        
    }
    
    
}
