//
//  UserDetailViewController.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 27/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit
import CoreData

class UserDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDetails.self))
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userId", ascending: true)]
        
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.rowHeight = UITableView.automaticDimension;
//        self.tableView.estimatedRowHeight = 90.0; // set to whatever your "average" cell height is
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView?.register(UserDetailsCell.nib, forCellReuseIdentifier: UserDetailsCell.identifier)
        self.updateTableContent()

        // Do any additional setup after loading the view.
    }
    
    func updateTableContent() {
        do {
            try self.fetchedhResultController.performFetch()
//            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
            if let fetchedObjects = self.fetchedhResultController.fetchedObjects as? [UserDetails] {
                print(fetchedObjects.count)
            }
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserDetailsCell = tableView.dequeueReusableCell(withIdentifier: UserDetailsCell.identifier) as! UserDetailsCell
        cell.tag = indexPath.row
        if let user = fetchedhResultController.object(at: indexPath) as? UserDetails {
            cell.setUserCellWith(user: user)
        }
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfSections: Int = 0
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            if count > 0 {
                tableView.backgroundView = nil
                numOfSections = count
            }else {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
            
        }
        return numOfSections
    }

}


extension UserDetailViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
