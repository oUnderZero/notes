
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var position: Int?
    
    var noteEdit: String?
    
    var notes = [String?]()
    
    var dates = [String?]()
    
    @IBOutlet weak var notesTableView: UITableView!
    
    let defaultsDB = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = notesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        cell.detailTextLabel?.text = dates[indexPath.row]
        return cell
    }
    
    // Delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            dates.remove(at: indexPath.row)
            self.defaultsDB.set(self.notes, forKey: "notes")
            self.defaultsDB.set(self.dates, forKey: "dates")
            notesTableView.reloadData()
        }
    }
    
    // Edit cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
        noteEdit = notes[indexPath.row]
        performSegue(withIdentifier: "edit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let objectEdit = segue.destination as! EditViewController
            objectEdit.getNote = noteEdit
            objectEdit.notes = notes
            objectEdit.dates = dates
            objectEdit.position = position
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.delegate = self
        notesTableView.dataSource = self
        if let notesArray = defaultsDB.array(forKey: "notes") as? [String] {
            notes = notesArray
        }
        
        if let datesArray = defaultsDB.array(forKey: "dates") as? [String] {
            dates = datesArray
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let notesArray = defaultsDB.array(forKey: "notes") as? [String] {
            notes = notesArray
        }
        
        if let datesArray = defaultsDB.array(forKey: "dates") as? [String] {
            dates = datesArray
        }
        
        notesTableView.reloadData()
    }
    
    @IBAction func addNoteButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Note", message: nil, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Create", style: .default) { (_) in
            self.notes.append(textField.text ?? "Empty note")
            self.defaultsDB.set(self.notes, forKey: "notes")
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss"
            let result = formatter.string(from: date)
            self.dates.append(result)
            self.defaultsDB.set(self.dates, forKey: "dates")
            //cell.detailTextLabel?.text = "\(result)"
            self.notesTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
        }
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textFieldAlert) in
            textFieldAlert.placeholder = "Write your note here..."
            textField = textFieldAlert
        }
        present(alert, animated: true, completion: nil)
    }
    
}

