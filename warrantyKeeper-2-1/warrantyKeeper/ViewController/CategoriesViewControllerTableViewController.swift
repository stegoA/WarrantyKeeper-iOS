//
//  CategoriesViewControllerTableViewController.swift
//  warrantyKeeper
//
//  Created by Krishna Khandelwal on 12/21/19.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class CategoriesViewControllerTableViewController: UITableViewController {

    var db:Firestore!
    var categoriesArray = [category]()
    var userId = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadData()

    }
    //load data to table view
    func loadData(){

        //gets data from firestore
        db.collection(userId!).document("Categories").getDocument { (document, error) in
            if let doc = document , doc.exists{
                //converts to dcitionary
                let dictionary = document!.data() as! [String:String]
                //convert dictionary to categories array object
                for(key,value) in  dictionary{
                    self.categoriesArray.append(category(Code: Int(key)!, Descript: value))
                    //sorting categories array
                    self.categoriesArray.sort(by: {$0.Code < $1.Code})
                    //updating table view
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            }
        }
        /*
        db.collection(userId!).document("Categories").addSnapshotListener { (document, error) in
            guard let doc = document else{
                print("Error")
                return
            }
            guard let data = document?.data() else{
                print("Document data was empty")
                return
            }
            let dictionary = document!.data() as! [String:String]
            for(key,value) in  dictionary{
                print("Start")
                self.categoriesArray.append(category(Code: key, Descript: value))
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            
        }
 */
    }

    @IBAction func AddCategory(_ sender: Any) {
        
        let composeAlert = UIAlertController(title: "Add Category", message: "Enter Category Name", preferredStyle: .alert)
        composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Category Name"
        }
        composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        composeAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(action:UIAlertAction) in
            
            if let addCategory = composeAlert.textFields?.first?.text{
                
                for category in self.categoriesArray{
                    if category.Descript == addCategory{
                        let errorAlert = UIAlertController(title: "ERROR", message: "Category already exists", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(errorAlert,animated: true,completion: nil)
                        return
                    }
                }
                var currentCount = self.categoriesArray.count
                print("Add Count : \(currentCount)"); self.db.collection(self.userId!).document("Categories").setData(["\(currentCount)":addCategory],merge: true)
                self.categoriesArray.removeAll()
            
                self.loadData()
            }
            
            
            
            
        }))
        self.present(composeAlert,animated: true,completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let category = categoriesArray[indexPath.row]
        cell.textLabel?.text = "\(category.Descript)"

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.categoriesArray.remove(at: indexPath.row)
            var tempDictionary = [String:String]()
            for category in self.categoriesArray{
                var key = self.findInArray(array: self.categoriesArray, toFind: category.Descript)
                print("Key :\(key)")
                tempDictionary["\(key)"] = category.Descript
            }
            self.db.collection(self.userId!).document("Categories").setData(tempDictionary)
            self.categoriesArray.removeAll()
            self.loadData()
            for category in self.categoriesArray{
                print("After Delete")
                print(category.Code)
            }
           
        }
        let editAction = UITableViewRowAction(style: .normal,title:"Edit"){
            (action, indexPath) in
            let editAlert = UIAlertController(title: "Edit Category", message: "Enter Category Name", preferredStyle: .alert)
            editAlert.addTextField{
                (textField : UITextField)in
                textField.placeholder = "Category"
            }
            editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            editAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: {(action:UIAlertAction) in
                
                if let categoryName = editAlert.textFields?.first?.text{
                    for category in self.categoriesArray{
                        if category.Descript == categoryName{
                            let errorAlert = UIAlertController(title: "ERROR", message: "Category already exists", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(errorAlert,animated: true,completion: nil)
                                           return
                                       }
                                   }
                    self.categoriesArray[indexPath.row].Descript = categoryName
                    var tempDictionary = [String:String]()
                    for category in self.categoriesArray{
                        var key = self.findInArray(array: self.categoriesArray, toFind: category.Descript)
                        tempDictionary["\(key)"] = category.Descript
                    }
                    self.db.collection(self.userId!).document("Categories").setData(tempDictionary)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
          
                
                
                
                
            }))
            self.present(editAlert,animated: true,completion: nil)
            
        }
         return [deleteAction,editAction]
    }
    //sending data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? ItemsTableViewController
        
        let selectedRow:Int =
            (self.tableView.indexPathForSelectedRow?.row)!
        dest?.category=categoriesArray[selectedRow].Descript
    }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func findInArray(array : [category] , toFind : String) -> Int{
        for (index,value) in array.enumerated(){
            if(value.Descript == toFind){
                return index
            }
        }
        return -1
    }

}
