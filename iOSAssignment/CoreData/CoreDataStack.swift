//
//  CoreDataStack.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 25/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack {
    
    private init() {}
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iOSAssignment")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        context.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createUserEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.shared.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func saveInCoreDataWith(jsonDictionary: NSDictionary) {
        
        let userArray = jsonDictionary["results"] as?  [String: AnyObject]
        print(userArray!)
        
        
        _ = userArray.map{self.createUserEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.shared.persistentContainer.viewContext.save()
            
        } catch let error {
            print(error)
        }
        
    }
    
    func clearData() {
        do {
            
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDetails.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.shared.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func createUserEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        //        print(dictionary)
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        if let userDetailsEntity = NSEntityDescription.insertNewObject(forEntityName: "UserDetails", into: context) as? UserDetails {
            if let nameDictionary = dictionary["name"] {
                if let firstName = nameDictionary["first"],
                    let lastName = nameDictionary["last"], let title = nameDictionary["title"] {
                    userDetailsEntity.userFullName = "\(String(describing: title!)) \(String(describing: firstName!)) \(String(describing: lastName!))"
                }
            }
            
            if let locationDictionary = dictionary["location"] {
                if let city = locationDictionary["city"],
                    let country = locationDictionary["country"],
                    let postcode = locationDictionary["postcode"],
                    let state = locationDictionary["state"] {
                    
                    let stringLocation = "\(String(describing: city!)), \(String(describing: state!)) \(String(describing: country!)) (PostalCode: \(String(describing: postcode!)))"
                    userDetailsEntity.userLocation = stringLocation
                }
            }
            
            if let dobDictionary = dictionary["dob"] {
                if let date = dobDictionary["date"] as? String {
                    userDetailsEntity.userDOB = date.toDate()
                }
            }
            if let email = dictionary["email"] {
                userDetailsEntity.userId = email as? String
            }
            
            if let loginDictionary = dictionary["login"] {
                //                print(loginDictionary["uuid"])
                if let password = loginDictionary["password"], let uuidString = loginDictionary["uuid"]  {
                    userDetailsEntity.userPassword = password as? String
                    
                }
                
            }
            
            if let pictureDictionary = dictionary["picture"] {
                if let thumbnail = pictureDictionary["large"] {
                    userDetailsEntity.userImageURL = thumbnail as? String
                }
            }
            
            
            
            if let phoneNo = dictionary["phone"], let cellNo = dictionary["cell"] {
                
                let phoneString = "Phone No. : \(phoneNo), \n Cell No. : \(cellNo)"
                
                userDetailsEntity.userPhoneNo = phoneString
                
            }
            
            if let gender = dictionary["gender"] {
                userDetailsEntity.userGender = gender as? String
            }
            return userDetailsEntity
        }
        
        
        return nil
    }
    
    // MARK: - Fetch Data from Core-Data-Model
    
    func getAllUserData() -> [UserDetails] {
        
        let managedContext = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        let predicate = NSPredicate(format: "isFavorite != 1")
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let fetchedObjects = result as?  [UserDetails] {
                return fetchedObjects
            }
        } catch {
            return []
        }
        return []
    }
    
    func getDataByUserId(predicateString: NSPredicate) -> UserDetails? {
        
        let managedContext = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        fetchRequest.predicate = predicateString
        do {
            let result = try managedContext.fetch(fetchRequest)
            //            print(result.self)
            return result[0] as? UserDetails
        } catch {
            
            print("Failed")
        }
        return nil
    }
    
    func markUserAsFavorite(predicateString: NSPredicate) {
        
        let managedContext = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserDetails")
        fetchRequest.predicate = predicateString
        do
        {
            let userData = try managedContext.fetch(fetchRequest)
            
            let userDetails = userData[0] as! UserDetails
            userDetails.isFavorite = true
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
    
}
