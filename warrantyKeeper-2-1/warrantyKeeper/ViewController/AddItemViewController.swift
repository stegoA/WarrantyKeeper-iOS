//
//  AddItemViewController.swift
//  warrantyKeeper
//
//  Created by anonymous on 22/12/2019.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth



class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var amountPaidTextField: UITextField!
    @IBOutlet weak var sellerEmailTextField: UITextField!
    @IBOutlet weak var sellerPhoneNumberTextField: UITextField!
    @IBOutlet weak var sellerNameTextField: UITextField!
    @IBOutlet weak var warrantyExpiryDateTextField: UITextField!
    
    
    var category: String = " "
    
    var db:Firestore!
    var userId = Auth.auth().currentUser?.uid


    @IBAction func onAddTapped(_ sender: Any) {
     
        guard let image = uploadImage.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let uploadImageRef = imageReference.child(filename)
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
   
            uploadTask.resume()

               
            var itemname = itemNameTextField.text!

        self.db.collection(self.userId!).document("\(itemname)_\(category)").setData(["itemName":itemNameTextField.text!, "amountPaid":amountPaidTextField.text!, "expiryDate":warrantyExpiryDateTextField.text!, "storeName":sellerNameTextField.text!, "sellerPhoneNumber":sellerPhoneNumberTextField.text!, "sellerEmail":sellerEmailTextField.text!, "storeAddress":locationText.text!,"imageID": filename,"category":category])

        
 
    }
    
    
    let filename = UUID().uuidString + ".jpg"
    
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    @IBAction func onUploadTapped(_ sender: Any) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated:true) {
            
        }
    
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
               {
                   uploadImage.image = imagePicker
               }
        self.dismiss(animated: true, completion: nil)
    }
    
    var myString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        datePicker.addTarget(self, action: #selector(AddItemViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        dateTextField.inputView = datePicker
        
        locationText.text = myString
        
        db = Firestore.firestore()
        
        

        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = formatter.string(from: sender.date)
    
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func unwindToAddItem(_ sender:UIStoryboardSegue){}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let dest = segue.destination as? DisplayItemInformationViewController
    dest?.filename = self.filename
    }
}


