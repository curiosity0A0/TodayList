//
//  TableViewController.swift
//  TodayList
//
//  Created by 洪森達 on 2018/6/28.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

  
    
    var itemArray = [item]()
  
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
 
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
      
        let item = itemArray[indexPath.row]
    
        
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
 
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
                
                let newitem = item()
                newitem.title = textField.text!
                
                self.itemArray.append(newitem)
                
                self.saveItems()
                self.tableView.reloadData()
            }
            
            
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            
            print("error in encode")
            
        }
        
        
    }
    
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do{
               
                itemArray = try decoder.decode([item].self, from: data)
                
            }catch{
                print("error decoding item array")
            }
            
        }
        
    }
    
}
