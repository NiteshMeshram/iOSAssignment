//
//  ViewController.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 25/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var heartButton: UIButton!
    var isLoadedFirstTime: Bool = true
    
    var userDetailsArray = [UserDetails]()
    var viewModelData = [CardsDataModel]()
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDetails.self))
        let predicate = NSPredicate(format: "isFavorite != %@ || isFavorite == nil", NSNumber(value: true))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userId", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    
    
    var stackContainer : StackContainerView!
    
    
    //MARK: - Init
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBarButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tinder Sample"
        self.updateTableContent()
        stackContainer.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateImage(notification:)), name: .updateHeartImage, object: nil)
        Utility.showApploader()
        self.view.isUserInteractionEnabled = false
    }
    
    @objc func updateImage(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {
            //            self.heartButton.setImage(UIImage(named: "heart"), for: .normal)
            
        }, completion: { finished in
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                //                self.heartButton.setImage(UIImage(named: "heart_dark"), for: .normal)
            }
        })
        
    }
    
    func fetchDataFromDB () {
        do {
            try self.fetchedhResultController.performFetch()
//            print("2. COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
            if let fetchedObjects = self.fetchedhResultController.fetchedObjects as? [UserDetails] {
                self.userDetailsArray.removeAll()
                self.userDetailsArray = fetchedObjects
                self.createDataModelForCards()
//                print("2. userDetailsArray.count ==> \(self.userDetailsArray.count)")
            }
        } catch let error  {
            print("ERROR: \(error)")
        }
        
    }
    
    func updateTableContent() {
        self.fetchDataFromDB()
        
        let service = APIService()
        DispatchQueue.main.async {
            service.getUserDetails { (result) in
                switch result {
                case .Success(let data):
                    CoreDataStack.shared.saveInCoreDataWith(array: data)
                    self.fetchDataFromDB()
                case .Error(let message):
                    print(message)
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            let action = UIAlertAction(title: title, style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Configurations
    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func configureNavigationBarButtonItem() {
        
        let imgLeft = UIImage(named: "refresh")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: imgLeft, style: UIBarButtonItem.Style.plain, target: self, action: #selector(resetTapped))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let imgRight = UIImage(named: "heart_sel")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let rightBarButtonItem = UIBarButtonItem(image: imgRight, style: UIBarButtonItem.Style.plain, target: self, action: #selector(favoriteTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        DispatchQueue.main.async {
            self.updateTableContent()
            self.stackContainer.reloadData()
        }
        
    }
    
    @objc func favoriteTapped() {
        performSegue(withIdentifier: "detailsView", sender: nil)
    }
    
    func createDataModelForCards() {
        self.viewModelData.removeAll()
        for userCard in self.userDetailsArray {
            self.viewModelData.append(CardsDataModel(bgColor: UIColor.white,
                                                     text: "\(String(describing: userCard.userFullName!))",
                image: userCard.userImageURL!,
                cardId: userCard.userId!))
        }
        if !isLoadedFirstTime {
            DispatchQueue.main.async {
                self.stackContainer.reloadData()
                Utility.hideApploader()
                self.view.isUserInteractionEnabled = true
            }
            
        }else {
            DispatchQueue.main.async {
                self.isLoadedFirstTime = false
                Utility.hideApploader()
                self.view.isUserInteractionEnabled = true
            }
            
        }
        
    }
    
    //MARK: - Refresh control-Data
    @IBAction func reloadButtonClicked(_ sender: Any) {
        let service = APIService()
        DispatchQueue.main.async {
            service.getUserDetails { (result) in
                switch result {
                case .Success(let data):
                    CoreDataStack.shared.saveInCoreDataWith(array: data)
                    self.fetchDataFromDB()
                case .Error(let message):
                    print(message)
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    
}


extension ViewController : SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
    
    
}


extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}


extension Notification.Name {
    static let updateHeartImage = Notification.Name("updateHeartImage")
}
