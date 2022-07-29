//
//  DatabaseManager.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 29/07/22.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {
    
    static var shared = DatabaseManager()
    
    private var appDelegate: AppDelegate? {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return nil
                }
        return appDelegate
    }
    
    private var managedContext: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext ?? nil
    }
    
    func saveContactToDBFor(model: ContactModel) {
        guard let managedContext = managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "ContactModelDB", in: managedContext)!
        let contact = NSManagedObject(entity: entity, insertInto: managedContext) as! ContactModelDB
        contact.contactId = model.contactId
        contact.firstName = model.firstName
        contact.lastName = model.lastName
        contact.email = model.email
        contact.mobile = model.phoneNumber
        contact.imageUrl = model.profilePic
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateContact(model: ContactModel) {
        guard let managedContext = managedContext,
              let contactId = model.contactId,
              let contactModel = fetchContactForId(contactModelId: contactId) else {
                  return
              }
        contactModel.contactId = model.contactId
        contactModel.firstName = model.firstName
        contactModel.lastName = model.lastName
        contactModel.email = model.email
        contactModel.mobile = model.phoneNumber
        contactModel.imageUrl = model.profilePic
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteContact(contactId: String?) {
        guard let managedContext = managedContext,
              let contactId = contactId,
              let contactModel = fetchContactForId(contactModelId: contactId)else {
                  return
              }
        managedContext.delete(contactModel)
        do {
            try managedContext.save()
        } catch {
            
        }
    }
    
    func fetchAllContacts() -> [ContactModel]? {
        guard let managedContext = managedContext else {
            return nil
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactModelDB")
        do
        {
            if let objects = try managedContext.fetch(request) as? [ContactModelDB] {
                var contactModels = [ContactModel]()
                for model in objects {
                    contactModels.append(ContactModel(contactId: model.contactId, firstName: model.firstName, lastName: model.lastName, phoneNumber: model.mobile, email: model.email, profilePic: model.imageUrl))
                }
                return contactModels
            }
        }
        catch
        {
            
        }
        return nil
    }
    
    func fetchContactForId(contactModelId: String) -> ContactModelDB? {
        guard let managedContext = managedContext else {
            return nil
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactModelDB")
        request.predicate = NSPredicate(format: "contactId = %@", contactModelId)
        do
        {
            if let objects = try managedContext.fetch(request) as? [ContactModelDB],
               let contactModel = objects.first {
                return contactModel
            }
        }
        catch
        {
            
        }
        return nil
    }
    
}
