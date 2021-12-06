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
    var parentIdentity: String
    var complete: Int16
    
    init(definition: String, meaning: String, parentIdentity: String, insertDate: Date = Date(), complete: Int16 = 0) {
        self.definition = definition
        self.meaning = meaning
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
        self.parentIdentity = parentIdentity
        self.complete = complete
    }
    
    init(original: Word, definition: String, meaning: String) {
        self = original
        self.definition = definition
        self.meaning = meaning
    }
    
    init(original: Word, complete: Bool) {
        self = original
        self.complete = complete ? 2 : 1
    }
}

// MARK: - CoreData

extension Word {
    public static var entityName: String {
        return "Word"
    }
    
    init(entity: NSManagedObject) {
        definition = (entity.value(forKey: "definition") as! String)
        meaning = (entity.value(forKey: "meaning") as! String)
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
        parentIdentity = (entity.value(forKey: "parentIdentity") as! String)
        complete = entity.value(forKey: "complete") as! Int16
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(definition, forKey: "definition")
        entity.setValue(identity, forKey: "identity")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue(meaning, forKey: "meaning")
        entity.setValue(parentIdentity, forKey: "parentIdentity")
        entity.setValue(complete, forKey: "complete")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
