//
//  AddItemViewController.swift
//  checklist
//
//  Created by TRUC TRUONG on 25.12.2021.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(
        _ controller: AddItemViewController
    )
    func addItemViewController(
        _ controller: AddItemViewController,
        didFinnishAdding item: ChecklistItem
    )
}


class AddItemViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: AddItemViewControllerDelegate?
    
    @IBOutlet weak var doneBarBtn: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.separatorStyle = .none
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
        let item = ChecklistItem()
        item.text = textField.text!
        
        delegate?.addItemViewController(self, didFinnishAdding: item)
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
