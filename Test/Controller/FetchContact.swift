//
//  FetchContact.swift
//  Test
//
//  Created by Parth Barot on 2/19/23.
//

import UIKit
import Contacts
import MobileCoreServices

protocol FetchContactModelDelegate: class {
    func didRecieveDataUpdate(data: [ContactModel])
    func showSettingAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void)
}

class FetchContactModel: NSObject {
    
    let contactStore = CNContactStore()
    weak var delegate: FetchContactModelDelegate?
    var result : [ContactModel] = []
    
    // MARK: - Fetch Contacts
    func fetchContacts() {
        
        
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataAvailableKey,
            CNContactImageDataKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as? [CNKeyDescriptor] ?? [])
        request.sortOrder = CNContactSortOrder.userDefault
        
        do {
            try self.contactStore.enumerateContacts(with: request) { (contact, _) in
                
                var arrPhoneNumber: [String] = [String]()
                var arrContactType: [String] = [String]()
                
                for data in contact.phoneNumbers {
                    arrPhoneNumber.append(data.value.stringValue)
                }
                
                
                
                var userProfileImage: UIImage! = UIImage()
                
                if contact.imageDataAvailable, let imgData = contact.imageData {
                    let imgProfile = UIImage(data: imgData)
                    
                    if imgProfile != nil {
                        userProfileImage = imgProfile
                    }
                }
                
                var personName: String = String()
                if contact.familyName != "" {
                    personName = contact.givenName + " " + contact.familyName
                } else {
                    personName = contact.givenName
                }
                //                    DLog("NAME:\(personName)")
                
                var personIdentifier: String = String()
                personIdentifier = contact.identifier
                //                    DLog("Person Identifier:\(personIdentifier)")
                
                
                if personName == "" {
                    personName = arrPhoneNumber.first ?? ""
                }
                
                
                self.result.append(ContactModel(contactName: personName, mobileNo: arrPhoneNumber, contactType: arrContactType, profileImage: userProfileImage, contactUniqueIdentifier: personIdentifier))
                
                self.delegate?.didRecieveDataUpdate(data: self.result)
            }
            
        } catch {
                self.requestAccess(completionHandler: { (isSuccess) in
                    //                    DLog(isSuccess)
                })
                print("unable to fetch contacts")
            }
        }
    
    func UIImageToDataIO(image: UIImage, maxPixelSize: Int, compressionRatio: CGFloat, orientation: Int = 1) -> Data? {
        return autoreleasepool(invoking: { () -> Data in
            let data = NSMutableData()
            let options: NSDictionary = [
                kCGImagePropertyOrientation: orientation,
                kCGImagePropertyHasAlpha: true,
                kCGImageDestinationImageMaxPixelSize: 2376.0,
                kCGImageDestinationLossyCompressionQuality: 0.0
            ]
            let imageDestinationRef = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil)!
            CGImageDestinationAddImage(imageDestinationRef, image.cgImage!, options)
            CGImageDestinationFinalize(imageDestinationRef)
            return data as Data
        })
    }
    
    // MARK: - Check User Permission
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            delegate?.showSettingAlert(completionHandler)
        case .restricted, .notDetermined:
            contactStore.requestAccess(for: .contacts) { granted, _ in
                if granted {
                    completionHandler(true)
                } else {
                    self.delegate?.showSettingAlert(completionHandler)
                }
            }
        @unknown default:
            self.delegate?.showSettingAlert(completionHandler)
        }
    }
}

