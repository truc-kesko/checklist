//
//  ListDetailTableViewController.swift
//  checklist
//
//  Created by TRUC TRUONG on 26.12.2021.
//

import UIKit

protocol ListDetailTableViewControllerDelegate: AnyObject {
    func listDetailTableViewControllerDidCancel(
        _ controller: ListDetailTableViewController
    )
    
    func listDetailTableViewController(
        _ controller: ListDetailTableViewController,
        didFinishAdding checklist: Checklist
    )
    
    func listDetailTableViewController(
        _ controller: ListDetailTableViewController,
        didFinishEditing checklist: Checklist
    )
}

class ListDetailTableViewController: UITableViewController, UITextViewDelegate, IconPickerViewControllerDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarBtn: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!

    
    var iconName = "Folder"
    
    weak var delegate: ListDetailTableViewControllerDelegate?
    var checklistToEdit: Checklist?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarBtn.isEnabled = true
            iconName = checklist.iconName
        }
        self.tableView.separatorStyle = .none
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Icon Picker View Controller Delegate
    func iconPicker(
      _ picker: IconPickerViewController,
      didPick iconName: String
    ) {
      self.iconName = iconName
      iconImage.image = UIImage(named: iconName)
      navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    @IBAction func cancel(){
        delegate?.listDetailTableViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailTableViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailTableViewController(self, didFinishAdding: checklist)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    // MARK: - Textfield Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        if newText.isEmpty {
            doneBarBtn.isEnabled = false
        } else {
            doneBarBtn.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarBtn.isEnabled = false
        return true
    }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
}
