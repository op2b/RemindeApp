
import UIKit

class ReminderTableViewController: UITableViewController {
    //описываем сво1ства
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    var isDone = [Bool](repeating: false, count: 200)
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //задаем еще настройки dateFormat
       dateFormatter.locale = locale
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .short
        
        //загрузка напоминалок
        if let savedReminders = loadReminders() {
            reminders += savedReminders
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       return reminders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        // конфигурация ячейки
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: reminder.time as Date)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.7002705932, green: 0.7271060348, blue: 0.9297530651, alpha: 1)
        self.tableView.backgroundColor = #colorLiteral(red: 0.7002705932, green: 0.7271060348, blue: 0.9297530651, alpha: 1)
        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
       
        cell.accessoryType = self.isDone[indexPath.row] ? .checkmark : .none
        
       
        return cell
    }
    //создаем сам алертконтролер (всплывающее окно)
    
    
    //создаем возсожность выводить по тапу на целл алертконтролер
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "got a question", message: "Is this done?" , preferredStyle: .actionSheet)
        
        let isDoneTitel = self.isDone[indexPath.row] ? "didnt done" : "done"
        let isDone = UIAlertAction(title: isDoneTitel, style: .default) { (action) in
            let cell = tableView.cellForRow(at: indexPath)
            //меняем значение на обратгное в кнопке
            self.isDone[indexPath.row] = !self.isDone[indexPath.row]
            cell?.accessoryType = self.isDone[indexPath.row] ? .checkmark : .none
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(isDone)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
        //избавляемся от оставшейся анимации тапа
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = reminders.remove(at: indexPath.row)
           
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
           saveReminders()
        } 
    }
   
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        if let sourceView =  sender.source as? AddReminderViewController, let reminder = sourceView.reminder {
            let newIndexPath = NSIndexPath(row: reminders.count, section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            saveReminders()
            tableView.reloadData()
        }
    }
    
    
    
    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path)
        if (isSuccessfulSave) {
            print ("Save Reminders Successfully")
        } else {
            print("False to save reminder 😿")
        }
    }
    func loadReminders() -> [Reminder]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.ArchiveURL.path) as? [Reminder]
    }
}
