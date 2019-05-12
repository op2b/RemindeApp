
import UIKit

class AddReminderViewController: UIViewController, UITextFieldDelegate {
    var reminder: Reminder?
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var reminderTextField: UITextField!
    
    
   
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.reminderTextField.delegate = self
        
        timePicker.minimumDate = NSDate() as Date
        timePicker.locale = NSLocale.current
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func checkName() {
        //лочить кнопку сейф если мы ничего не ввели в текстфилд
        let text = reminderTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func checkDate(){
        // лочить кнопку сэйф когда у нас не установленна дата
        if NSDate().earlierDate(timePicker.date) == timePicker.date {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    @IBAction func timeChanges(_ sender: UIDatePicker) {
        checkDate()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if  saveButton! === sender as AnyObject? {
            let name = reminderTextField.text
            var time = timePicker.date
            let timeInterval = floor(time.timeIntervalSinceReferenceDate/60) * 60
            time = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
            
            //создаем нотификации
            let notification = UILocalNotification()
            notification.alertTitle = "Reminder"
            notification.alertBody = "Don't forget to \(name!)"
            notification.fireDate = time
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
            
            reminder = Reminder(name: name!, time: time as NSDate, notification: notification)
        
        }
    }
    

}
