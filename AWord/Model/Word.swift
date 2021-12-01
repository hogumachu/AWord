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
    
    init(definition: String, meaning: String, parentIdentity: String, insertDate: Date = Date()) {
        self.definition = definition
        self.meaning = meaning
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
        self.parentIdentity = parentIdentity
    }
    
    init(original: Word, definition: String, meaning: String) {
        self = original
        self.definition = definition
        self.meaning = meaning
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
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(definition, forKey: "definition")
        entity.setValue(identity, forKey: "identity")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue(meaning, forKey: "meaning")
        entity.setValue(parentIdentity, forKey: "parentIdentity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
