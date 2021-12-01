import RxDataSources
import CoreData

struct Word: Equatable, IdentifiableType {
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var definition: String
    var meaning: String
    var insertDate: Date
    var identity: String
    
    init(definition: String, meaning: String, insertDate: Date = Date()) {
        self.definition = definition
        self.meaning = meaning
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: Word, definition: String, meaning: String) {
        self = original
        self.definition = definition
        self.meaning = meaning
    }
}

extension Word {
    public static var entityName: String {
        return "Word"
    }
    
    init(entity: NSManagedObject) {
        definition = (entity.value(forKey: "definition") as! String)
        meaning = (entity.value(forKey: "meaning") as! String)
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(definition, forKey: "definition")
        entity.setValue(identity, forKey: "identity")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue(meaning, forKey: "meaning")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
