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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

