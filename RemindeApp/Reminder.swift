
import Foundation
import UIKit
import UserNotifications


class Reminder: NSObject, NSCoding {
    // свойства
    var notification: UILocalNotification
    var name : String
    var time: NSDate
    
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("reminders")
    
    //перечисление свойств ключей
    struct PropertyKey {
    static  let nameKey = "name"
    static let timeKey = "time"
    static let notificationKey = "notification"
    
    }
    
    //Конструктор
     init(name: String, time: NSDate, notification: UILocalNotification) {
        self.name = name
        self.time = time
        self.notification = notification
        
        super.init()
    }
    //разборщик
    deinit {
        //отмена нотификаций
        UIApplication.shared.cancelLocalNotification(self.notification)
    }
    //NSCodingProtocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(time, forKey: PropertyKey.timeKey)
        aCoder.encode(notification, forKey:  PropertyKey.notificationKey)
    }
    required convenience init(coder aDecoder: NSCoder) {
        let  name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! NSDate
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UILocalNotification
        
        self.init(name: name, time:time, notification: notification)
    }
}
