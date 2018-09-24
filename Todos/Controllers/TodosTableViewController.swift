//
//  ViewController.swift
//  Todos
//
//  Created by Mostafa Elshazly on 9/13/18.
//  Copyright © 2018 Mostafa Elshazly. All rights reserved.
//

import UIKit
import RealmSwift

class TodosTableViewController: UITableViewController {

    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodosCell", for: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items yet"
        cell.accessoryType = (todoItems?[indexPath.row].done)! ? .checkmark : .none ?? .none
        return cell
    }
    
    //MARK - Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                     item.done = !item.done
                }}
                catch{
                    print("Error updating items:\(error)")
                }
            
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = todoItems![indexPath.row].done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new Todos Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //what happens when the user clicks add item in uialert
        if let currentCategory = self.selectedCategory{
            do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    self.realm.add(newItem)
                }
            }
            catch{
                print("Error saving Item: \(error)")
            }
        }
        self.tableView.reloadData()
        self.saveItems()
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){//
        
    }
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
//MARK: - Search functionality
extension TodosTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title contains[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
