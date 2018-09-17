//
//  ViewController.swift
//  Todos
//
//  Created by Mostafa Elshazly on 9/13/18.
//  Copyright © 2018 Mostafa Elshazly. All rights reserved.
//

import UIKit

class TodosTableViewController: UITableViewController {

    var todosItems = [Item]()
    let defaults = UserDefaults.standard
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    //MARK - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodosCell", for: indexPath)
        cell.textLabel?.text = todosItems[indexPath.row].title
        cell.accessoryType = todosItems[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK - Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todosItems[indexPath.row].done = !todosItems[indexPath.row].done
        tableView.cellForRow(at: indexPath)?.accessoryType = todosItems[indexPath.row].done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
        saveDate()
    }
    
    //MARK - Add items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new Todos Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //what happens when the user clicks add item in uialert
        let newItem = Item(newTitle: textField.text!)
        self.todosItems.append(newItem)
        self.tableView.reloadData()
        self.saveDate()
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveDate(){
    let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(todosItems)
            try data.write(to: dataPath!)
        }
        catch{
            print("Error encoding Item array: \(error)")
        }
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataPath!){
            let decoder = PropertyListDecoder()
            do{
            try todosItems = decoder.decode([Item]. self , from: data)
            }
            catch{
                print("Error decoding Items: \(error)")
            }
        }
    }
}

