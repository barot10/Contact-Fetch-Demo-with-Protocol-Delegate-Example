//
//  ContactModel.swift
//  Test
//
//  Created by Parth Barot on 2/19/23.
//

import Foundation
import Contacts
import UIKit

@objc public class ContactModel: NSObject, NSCoding {
   
   @objc var contactName: String!
   @objc var mobileNo: [String]!
   @objc var contactType: [String]!
   @objc var profileImage: UIImage!
   @objc var contactUniqueIdentifier: String!
   
   
   let contactStore = CNContactStore()
   
   // MARK: - Initialize Model
   required public init(contactName: String, mobileNo: [String], contactType: [String] = ["mobile"], profileImage: UIImage, contactUniqueIdentifier: String = "") {
       self.contactName = contactName
       self.mobileNo = mobileNo
       self.contactType = contactType
       self.profileImage = profileImage
       self.contactUniqueIdentifier = contactUniqueIdentifier
       super.init()
   }
   
   // MARK: - NSCoding
   public func encode(with aCoder: NSCoder) {
       autoreleasepool {
           aCoder.encode(contactName, forKey: "contactName")
           aCoder.encode(mobileNo, forKey: "mobileNo")
           aCoder.encode(contactType, forKey: "contactType")
           aCoder.encode(profileImage, forKey: "profileImage")
           aCoder.encode(contactUniqueIdentifier, forKey: "contactUniqueIdentifier")
       }
   }
   
   required public init(coder aDecoder: NSCoder) {
       contactName = aDecoder.decodeObject(forKey: "contactName") as? String
       mobileNo = aDecoder.decodeObject(forKey: "mobileNo") as? [String]
       contactType = aDecoder.decodeObject(forKey: "contactType") as? [String]
       profileImage = aDecoder.decodeObject(forKey: "profileImage") as? UIImage
       contactUniqueIdentifier = aDecoder.decodeObject(forKey: "contactUniqueIdentifier") as? String
   }
   
}
