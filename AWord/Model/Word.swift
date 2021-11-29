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
    var correct: Int16
    var wrong: Int16
    
    init(definition: String, meaning: String, insertDate: Date = Date()) {
        self.definition = definition
        self.meaning = meaning
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
        self.correct = 0
        self.wrong = 0
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
    
    static var primaryAttributeName: String {
        return "identity"
    }
    
    init(entity: NSManagedObject) {
        definition = (entity.value(forKey: "definition") as! String)
        meaning = (entity.value(forKey: "meaning") as! String)
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
        correct = entity.value(forKey: "correct") as! Int16
        wrong = entity.value(forKey: "wrong") as! Int16
    }
}
