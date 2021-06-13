//
//  item.swift
//  warrantyKeeper
//
//  Created by Krishna Khandelwal on 12/21/19.
//  Copyright © 2019 anonymous. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}
struct item{
    
    var itemName:String=""
    var storeName:String=""
    var expiryDate:String=""
    var category:String=""
    var amountPaid:String=""
    var sellerPhoneNumber:String=""
    var sellerEmail:String=""
    var storeAddress:String=""
    var imageID:String=""
    
    var dictionary:[String:Any]{
        return[
            "itemName":itemName,
            "storeName":storeName,
            "expiryDate":expiryDate,
            "category":category,
            "amountPaid":amountPaid,
            "sellerPhoneNumber":sellerPhoneNumber,
            "sellerEmail":sellerEmail,
            "storeAddress":storeAddress,
            "imageID":imageID
        ]
    }

    
}
extension item :DocumentSerializable{
    init?(dictionary:[String:Any]){
        guard let itemName = dictionary["itemName"] as? String,
        let storeName = dictionary["storeName"] as? String,
        let expiryDate = dictionary["expiryDate"] as? String,
        let category = dictionary["category"] as? String,
        let amountPaid = dictionary["amountPaid"] as? String,
        let sellerPhoneNumber = dictionary["sellerPhoneNumber"] as? String,
        let sellerEmail = dictionary["sellerEmail"] as? String,
        let storeAddress = dictionary["storeAddress"] as? String,
        let imageID = dictionary["imageID"] as? String
            else{return nil}
        self.init(itemName : itemName,storeName : storeName,expiryDate : expiryDate,category: category,amountPaid : amountPaid, sellerPhoneNumber : sellerPhoneNumber , sellerEmail : sellerEmail , storeAddress : storeAddress, imageID : imageID)
    }
}
