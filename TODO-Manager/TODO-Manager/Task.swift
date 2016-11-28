import Foundation
import RealmSwift
import Realm


enum TaskPriority: Int {
    case High = 2
    case Average = 1
    case Low = 0
}

class Task: Object {
    dynamic var date = NSDate()
    dynamic var text = ""
    dynamic var priority = 0
    
    init(date: NSDate, text: String, priority: TaskPriority) {
        self.date = date
        self.text = text
        self.priority = priority.rawValue
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
}
