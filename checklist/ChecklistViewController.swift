//
//  ViewController.swift
//  checklist
//
//  Created by TRUC TRUONG on 15.12.2021.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let row0item = ChecklistItem()
        row0item.text = "Clean the table"
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Wash dishes"
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Make breakfast"
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Walk the dog"
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Learn iOS coding"
        items.append(row4item)
    }
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 5
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        let item = items[indexPath.row]
        label.text = item.text
        
        configureCheckmark(for: cell, at: indexPath)
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCheckmark(
        for cell: UITableViewCell,
        at indexPath: IndexPath
    ) {
        
        let item = items[indexPath.row]
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
}

