//
//  ViewController.swift
//  todoey
//
//  Created by Carlos on 10/9/18.
//  Copyright © 2018 Carlos Santillan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
        let newItem = Item()
        newItem.title = "hey"
        
        itemArray.append(newItem)
     
        loadItems()
        
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
        
        cell.textLabel?.text = String(itemArray[indexPath.row].title)
     
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
      
        
        //Ternary operater
        cell.accessoryType = item.done ? .checkmark : .none
        //ternary operater shorter if statement
        
        
        return cell
    }
    
    //Mark - Tableview delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
         saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }
    
    //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default)/*Closure ->*/ {(action) in
         
            let newItem = Item()
            newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
        
    }
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
        do {
        itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print(error)
        }
    }
    
 }





}





