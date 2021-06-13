//
//  ItemsTableViewController.swift
//  warrantyKeeper
//
//  Created by Krishna Khandelwal on 12/21/19.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ItemsTableViewController: UITableViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    var db:Firestore!
    var itemsArray = [item]()
    var category:String=""
    var userId = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        loadData()
    }
    
    func loadData(){
        db.collection(userId!).whereField("category", isEqualTo: category).getDocuments { (querySnapshot, error) in
            if let error=error{
                print("Error getting documents")
            }
            else{
                self.itemsArray = querySnapshot!.documents.flatMap({item(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! ItemsTableViewCell
        cell.itemName.text = itemsArray[indexPath.row].itemName
        cell.storeName.text = itemsArray[indexPath.row].storeName
        cell.expiryDate.text = itemsArray[indexPath.row].expiryDate
        print(cell)
        // Configure the cell...

        return (cell)
    }
    

   //UNCOMMENT THIS TO ADD EDIT
      // Override to support conditional editing of the table view.
      override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          // Return false if you do not want the specified item to be editable.
          return true
      }
      //THE SWIPE FUNCTION
      override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          //DELETE ACTION , DELETES FROM THE ARRAY AND FROM DB AND THEN FROM THE TABLE VIEW
          let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
              let deletedItemName = self.itemsArray[indexPath.row].itemName
              let deletedCategoryName = self.itemsArray[indexPath.row].category
              self.itemsArray.remove(at: indexPath.row)
              self.db.collection(self.userId!).document("\(deletedItemName)_\(deletedCategoryName)").delete()
              tableView.deleteRows(at: [indexPath], with: .left)
          }
          //EDIT ACTION , CREATES ALERT OF FOUR OPTIONS
          let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
              let editAlert = UIAlertController(title: "Edit Item", message: "Choose an optin", preferredStyle: .alert)
              //first button
              editAlert.addAction(UIAlertAction(title: "Edit Item Name", style: .default, handler: { (action :UIAlertAction) in
                  //creates an alert to enter item name
                  let editItemName = UIAlertController(title: "Edit Item Name", message: "Enter Item Name", preferredStyle: .alert)
                  editItemName.addTextField{
                      (textField:UITextField) in
                      textField.placeholder = "Item Name"
                  }
                  editItemName.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                  //when user updates , updates the db , removes all elements of array , and loads data
                  editItemName.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action:UIAlertAction) in
                      if let editItemNameText = editItemName.textFields?.first?.text{
                          let currentItem = self.itemsArray[indexPath.row].itemName
                          self.itemsArray[indexPath.row].itemName = editItemNameText
                          
                          self.db.collection(self.userId!).document("\(editItemNameText)_\(self.category)").setData(
                              
                              ["itemName" : self.itemsArray[indexPath.row].itemName,
                              "storeName" : self.itemsArray[indexPath.row].storeName,
                              "expiryDate" : self.itemsArray[indexPath.row].expiryDate,
                              "category" : self.itemsArray[indexPath.row].category,
                              "amountPaid" : self.itemsArray[indexPath.row].amountPaid,
                            "sellerPhoneNumber" : self.itemsArray[indexPath.row].sellerPhoneNumber,
                            "sellerEmail" : self.itemsArray[indexPath.row].sellerEmail,
                            "storeAddress" : self.itemsArray[indexPath.row].storeAddress,
                            "imageID" :
                                self.itemsArray[indexPath.row].imageID]
                          )
                          print("Deleting")
                          print("\(currentItem)_\(self.category)")
                          self.db.collection(self.userId!).document("\(currentItem)_\(self.category)").delete()
                          print("Updating GUI")
                        
                          self.itemsArray.removeAll()
                          self.loadData()
                          
                      }
                      
                  }))
                  
                  self.present(editItemName,animated: true,completion: nil)
                  
                  
              }))
              
              editAlert.addAction(UIAlertAction(title: "Edit Store Name", style: .default, handler: { (alert:UIAlertAction) in
                  
                  let editStoreName = UIAlertController(title: "Edit Store Name", message: "Enter Store Name", preferredStyle: .alert)
                  editStoreName.addTextField{
                      (textField:UITextField) in
                      textField.placeholder="Store Name"
                  }
                  editStoreName.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                  editStoreName.addAction(UIAlertAction(title: "Update", style: .default, handler: { (alert:UIAlertAction) in
                      if let editStoreNameText = editStoreName.textFields?.first?.text{
                          self.db.collection(self.userId!).document("\(self.itemsArray[indexPath.row].itemName)_\(self.category)").updateData(["storeName" : editStoreNameText])
                          self.itemsArray.removeAll()
                          self.loadData()
                          
                          
                      }
                  }))
                  self.present(editStoreName,animated: true,completion: nil)
                  
              }))
              editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
              self.present(editAlert,animated: true,completion: nil)
          }
          return [deleteAction,editAction]
      }
    //SENDING DATA TO ADD ITEM FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
  
        
        let dest = segue.destination as? AddItemViewController
        dest?.category = self.category
        
        
        let dest2 = segue.destination as? DisplayItemInformationViewController
        dest2?.category = self.category
        
        if segue.identifier == "segueToDisplayItem" {
              let selectedRow: Int = (self.tableView.indexPathForSelectedRow?.row)!
              
              dest2?.currentItem = self.itemsArray[selectedRow].itemName
          }
        
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

}
