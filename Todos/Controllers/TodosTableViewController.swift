//
//  ViewController.swift
//  Todos
//
//  Created by Mostafa Elshazly on 9/13/18.
//  Copyright © 2018 Mostafa Elshazly. All rights reserved.
//

import UIKit
import CoreData

class TodosTableViewController: UITableViewController {

    var todosItems = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView datasource methods
    
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
        saveItems()
    }
    
    //MARK: - Add items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new Todos Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //what happens when the user clicks add item in uialert
        let newItem = Item(context: self.context)
        newItem.title = textField.text
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        self.todosItems.append(newItem)
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
    func saveItems(){
        do{
            try context.save()
        }
        catch{
        print("Error saving to database: \(error)")
        }
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name matches %@", self.selectedCategory!.name!)
        if let addedPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ categoryPredicate, addedPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        do{
            todosItems = try self.context.fetch(request)
        }
        catch{
            print("Error loading items: \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - Search functionality
extension TodosTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
