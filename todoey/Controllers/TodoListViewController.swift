//
//  ViewController.swift
//  todoey
//
//  Created by Carlos on 10/9/18.
//  Copyright © 2018 Carlos Santillan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
   // let defaults = UserDefaults.standard
   //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
//        let newItem = Item(context: context)
//        newItem.title = "hey"
//
//        itemArray.append(newItem)
//
    
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }

    }

    //MARK - Tableview
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
     
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
      
        
        //Ternary operater
        cell.accessoryType = item.done ? .checkmark : .none
        //ternary operater shorter if statement
        
        
        return cell
    }
    
    //Mark - Tableview delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
         saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }
    
    //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default)/*Closure ->*/ {(action) in
         
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
        
           // self.defaults.set(self.itemArray, forKey: "TodoListArray")
       self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
    }
    
    
    //MARK - Save items
    
    func saveItems(){
        do {
           try self.context.save()
        } catch {
            print(error)
        }
        
        tableView.reloadData()
        
    }
//    func loadItems() {
//       if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//        do {
//        itemArray = try decoder.decode([Item].self, from: data)
//        } catch {
//            print(error)
//        }
//    }
//
// }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
     
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
        itemArray = try context.fetch(request)
        } catch {
            print("Error Fetching context \(error)")
        }
        tableView.reloadData()
    }
   

}
//MARK - Search bar methods
extension TodoListViewController:  UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        let request : NSFetchRequest<Item> = Item.fetchRequest()
      
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}






