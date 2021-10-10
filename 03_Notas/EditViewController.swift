
import UIKit

class EditViewController: UIViewController {
    
    var notes: [String?] = []
    
    var dates: [String?] = []
    
    var position: Int?
    
    var getNote: String?
    
    let defaultsDB = UserDefaults.standard
    
    @IBOutlet weak var editNoteTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editNoteTextField.text = getNote
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        dates.remove(at: position!)
        notes.remove(at: position!)
        
        if let editedNote = editNoteTextField.text {
            notes.append(editedNote)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss"
            let result = formatter.string(from: date)
            dates.append(result)
        }
        
        defaultsDB.set(dates, forKey: "dates")
        defaultsDB.set(notes, forKey: "notes")
        navigationController?.popToRootViewController(animated: true)
    }
    

}
