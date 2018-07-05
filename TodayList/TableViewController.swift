//
//  TableViewController.swift
//  TodayList
//
//  Created by 洪森達 on 2018/6/28.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController{


  
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        
        didSet{
            
            print(selectedCategory?.name)
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      
        return itemArray.count
     

 
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text = itemArray[indexPath.row].title

        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
    
        return cell
 
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
            self.context.delete(self.itemArray[index.row])
            self.itemArray.remove(at: index.row)
            self.saveItems()
            self.tableView.reloadData()
        }
        return [deleteAction]
        
    }
    
    
    @IBAction func add(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add something!", message: "", preferredStyle: .alert)
       
        alert.addTextField { (addTextFeild) in
            
            addTextFeild.borderStyle = .roundedRect
            addTextFeild.placeholder = "Add something!"
            textField = addTextFeild
            
     
            
        }
        
        
        let add = UIAlertAction(title: "ADD", style: .default) { (ACTION) in
            
            if textField.text != "" {
                
             
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parantCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
              
            }
            
            
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
 
        
        do {
            try context.save()
          
        }catch{
            
       print("Error saving context with \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request:  NSFetchRequest<Item> = Item.fetchRequest() ,predicate:NSPredicate? = nil){
       
        let categoryPredicate = NSPredicate(format: "parantCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }else{
            
            request.predicate = categoryPredicate
        }
        

        do {
           itemArray = try context.fetch(request)
        } catch  {
            
            print("Error saving context in fetch \(error)")
        }
      
        tableView.reloadData()
        
    }
    
    
}//end of class

extension TableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       let predicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate:predicate)
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
              self.loadItems()
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
              
            }
        }
        
    }
    

    
}












