//
//  ViewController.swift
//  checklist
//
//  Created by TRUC TRUONG on 15.12.2021.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemViewControllerDelegate {
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        loadChecklistItems()
    }
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // Delete item
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        // 1
        items.remove(at: indexPath.row)
        
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    // MARK: - Table View Delegate
    // Toggling checkmark
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "☑️"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func addItemViewControllerDidCancel(_ controller: ItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: ItemViewController, didFinnishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func addItemViewController(_ controller: ItemViewController, didFinnishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK: - Data persistent
    func documentsDirectory () -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func dataFilePath () -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems () {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems () {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
}

