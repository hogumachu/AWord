import RxDataSources
import CoreData

struct WordSet: Equatable, IdentifiableType {
    typealias Identity = String
    
    var identity: String
    var title: String
    var insertDate: Date
    
    init(title: String, insertDate: Date = Date()) {
        self.title = title
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: WordSet, title: String) {
        self = original
        self.title = title
    }
}

extension WordSet {
    public static var entityName: String {
        return "WordSet"
    }
    
    init(entity: NSManagedObject) {
        title = (entity.value(forKey: "title") as! String)
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(title, forKey: "title")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue(identity, forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
