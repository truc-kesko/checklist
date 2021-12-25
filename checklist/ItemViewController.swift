//
//  AddItemViewController.swift
//  checklist
//
//  Created by TRUC TRUONG on 25.12.2021.
//

import UIKit

protocol ItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(
        _ controller: ItemViewController
    )
    func addItemViewController(
        _ controller: ItemViewController,
        didFinnishAdding item: ChecklistItem
    )
    func addItemViewController(
        _ controller: ItemViewController,
        didFinnishEditing item: ChecklistItem
    )
}


class ItemViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: ItemViewControllerDelegate?
    
    @IBOutlet weak var doneBarBtn: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.separatorStyle = .none
        
        if let item = itemToEdit {
            title = "Edit View"
            textField.text = item.text
            doneBarBtn.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func add() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinnishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinnishAdding: item)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
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
    
}
