//
//  DisplayItemInformationViewController.swift
//  warrantyKeeper
//
//  Created by anonymous on 23/12/2019.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DisplayItemInformationViewController: UIViewController {

    
    var userId = Auth.auth().currentUser?.uid
    var db:Firestore!


    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var amountPaid: UILabel!
    @IBOutlet weak var warrantyExpiryDate: UILabel!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var sellerPhoneNumber: UILabel!
    @IBOutlet weak var sellerEmail: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    var category: String = ""
    var filename: String = ""
    var currentItem: String = ""
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    @IBAction func onShowReceiptTapped(_ sender: Any) {
        
        let downloadImageRef = imageReference.child(filename)
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data:data)
                self.receiptImageView.image = image
            }
            print(error ?? "NO ERROR")
        }
        
        downloadtask.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()

        let docRef = db.collection(self.userId!).document("\(currentItem)_\(category)")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let fetchedItemName = document.get("itemName")
                let fetchedAmountPaid = document.get("amountPaid")
                let fetchedWarrantyExpiryDate = document.get("expiryDate")
                let fetchedSellerName = document.get("storeName")
                let fetchedSellerPhoneNumber = document.get("sellerPhoneNumber")
                let fetchedSellerEmail = document.get("sellerEmail")
                let fetchedStoreAddress = document.get("storeAddress")
                let fetchedImageID = document.get("imageID")
               
                self.itemName.text = fetchedItemName as? String
                self.amountPaid.text = fetchedAmountPaid as? String
                self.warrantyExpiryDate.text = fetchedWarrantyExpiryDate as? String
               self.sellerName.text = fetchedSellerName as? String
               self.sellerPhoneNumber.text = fetchedSellerPhoneNumber as? String
                self.sellerEmail.text = fetchedSellerEmail as? String
                self.storeAddress.text = fetchedStoreAddress as? String
                self.filename = fetchedImageID as! String
                
                
            } else {
                print("Document does not exist")
            }
        }
        
        
        

        
    }
    

  

}
