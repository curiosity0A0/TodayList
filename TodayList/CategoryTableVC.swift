//
//  CategoryTableVC.swift
//  TodayList
//
//  Created by 洪森達 on 2018/7/5.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableVC: UITableViewController {

   
    var categoryItem = [Category]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        loadCatogory()

    }

    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        addText()
    }
    
    
    //MARK: -TableView dataSource
    
  
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItem.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
            cell.textLabel?.text = categoryItem[indexPath.row].name
        
            return cell
        
    }
    
    
    
     //MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        performSegue(withIdentifier: "gotoItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destination = segue.destination as! TableViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            
            destination.selectedCategory = categoryItem[index]
        }
       
        
        
      
    }
    
  override  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let DeletecellAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            //delete
            
            self.context.delete(self.categoryItem[index.row])
            self.categoryItem.remove(at: index.row)
            self.saveCategory()
    
        }
        
        return [DeletecellAction]
    }
    
    func addText(){
        
        
        var _textField = UITextField()
        
        let alert = UIAlertController(title: "Add something", message: "", preferredStyle: .alert)
        alert.addTextField { (TextField) in
           _textField = TextField
            TextField.placeholder = "Add new category"
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        let add = UIAlertAction(title: "ADD", style: .default) { (action) in

            let newCatogory = Category(context: self.context)
                newCatogory.name = _textField.text
            self.categoryItem.append(newCatogory)
            //save context
            self.saveCategory()
            
            
        }
        
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:  -Data Manipulation
    
    func saveCategory(){
        
        do {
            try context.save()
        } catch  {
            print("error in save")
        }
        tableView.reloadData()
    }
    
    func loadCatogory(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        
        do {
             categoryItem = try context.fetch(request)
        } catch  {
            
            print("error in request")
        }
        
        tableView.reloadData()
    }
    
    
    
}
