//
//  SwipeCardView.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 28/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit

class SwipeCardView : UIView {
    
    let nibName = "SwipeCardView"
    var userId : String?
    var delegate : SwipeCardsDelegate?
    var divisor : CGFloat = 0
    
    @IBOutlet weak var imageBorderView: UIView!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var dobButton: UIButton!
    @IBOutlet weak var personButton: UIButton!
    
    @IBOutlet weak var userInformationLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    var dataSource : CardsDataModel? {
        didSet {
            swipeView.backgroundColor = dataSource?.bgColor
            self.userInformationLabel.text = dataSource?.text
            self.userId = dataSource?.cardID
            guard let image = dataSource?.image else { return }
            userImageView.loadImageUsingCacheWithURLString(image, placeHolder: UIImage(named: "placeholder"))
        }
    }
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        
        self.configureShadowView()
        
        self.addPanGestureOnCards()
        self.configureTapGesture()
        
        self.makeRounded()
        
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: - Gesture
    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    func configureShadowView() {
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
    }
    
    func makeRounded() {
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        imageBorderView.layer.cornerRadius = imageBorderView.frame.size.height/2
        userImageView.layer.borderWidth = 5.0
        userImageView.layer.borderColor = UIColor.gray.cgColor
        
        userImageView.clipsToBounds = true
        imageBorderView.clipsToBounds = true
    }
    
    
    //MARK: - AddButton Methods
    
    @IBAction func personButtonClicked(_ sender: UIButton) {
        
        if let userData = CoreDataStack.shared.getDataByUserId(predicateString: NSPredicate(format: "userId == %@", self.userId!)) {
            let strName = "\(userData.userFullName!)"
            self.headerLabel.text = "Hi, My name is"
            self.userInformationLabel.text = strName
            
            DispatchQueue.main.async {
                self.resetButtonStates()
                sender.setImage(UIImage(named: "user_sel"), for: UIControl.State.normal)
            }
            
        }
        
    }
    @IBAction func dobButtonClicked(_ sender: UIButton) {
        if let userData = CoreDataStack.shared.getDataByUserId(predicateString: NSPredicate(format: "userId == %@", self.userId!)) {
            
            let strNameDOB = "\(userData.userDOB!.toString())"
            self.headerLabel.text = "My birthday is"
            self.userInformationLabel.text = strNameDOB
            
            DispatchQueue.main.async {
                self.resetButtonStates()
                sender.setImage(UIImage(named: "calendar_sel"), for: UIControl.State.normal)
            }
        }
        
    }
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        if let userData = CoreDataStack.shared.getDataByUserId(predicateString: NSPredicate(format: "userId == %@", self.userId!)) {
            
            let strNameAddress = "\(userData.userLocation!)"
            
            self.userInformationLabel.text = strNameAddress
            self.headerLabel.text = "My address is"
            
            DispatchQueue.main.async {
                self.resetButtonStates()
                sender.setImage(UIImage(named: "location_sel"), for: UIControl.State.normal)
            }
        }
    }
    
    
    
    
    @IBAction func phoneButtonClicked(_ sender: UIButton) {
        if let userData = CoreDataStack.shared.getDataByUserId(predicateString: NSPredicate(format: "userId == %@", self.userId!)) {
            
            let strNamePhone = "\(userData.userPhoneNo!)"
            
            
            self.headerLabel.text = "My phone number is"
            self.userInformationLabel.text = strNamePhone
            
            DispatchQueue.main.async {
                self.resetButtonStates()
                sender.setImage(UIImage(named: "phone_sel"), for: UIControl.State.normal)
            }
        }
        
    }
    @IBAction func passwordButtonClicked(_ sender: UIButton) {
        if let userData = CoreDataStack.shared.getDataByUserId(predicateString: NSPredicate(format: "userId == %@", self.userId!)) {
            
            let strNamePassword = "\(userData.userPassword!)"
            
            self.headerLabel.text = "My password is"
            self.userInformationLabel.text = strNamePassword
            
            DispatchQueue.main.async {
                self.resetButtonStates()
                sender.setImage(UIImage(named: "lock_sel.png"), for: UIControl.State.normal)
                
            }
        }
    }
    
    func resetButtonStates() {
        
        self.personButton.setImage(UIImage(named: "user"), for: UIControl.State.normal)
        self.dobButton.setImage(UIImage(named: "calendar"), for: UIControl.State.normal)
        self.locationButton.setImage(UIImage(named: "location"), for: UIControl.State.normal)
        self.phoneButton.setImage(UIImage(named: "phone"), for: UIControl.State.normal)
        self.passwordButton.setImage(UIImage(named: "lock"), for: UIControl.State.normal)
        
    }
    
    //MARK: - Handlers
    @objc func handlePanGesture(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UIPanGestureRecognizer {
            let card = gesture.view as! SwipeCardView
            let point = swipeGesture.translation(in: self) //gesture.translation(in: self)
            let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
            
            let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
            divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
            
            switch gesture.state {
            case .ended:
                if (card.center.x) > 400 {
                    delegate?.swipeDidEnd(on: card, direction: CardDirection.leftToRight)
                    UIView.animate(withDuration: 0.2) {
                        card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                        card.alpha = 0
                        self.layoutIfNeeded()
                    }
                    return
                }else if card.center.x < -65 {
                    delegate?.swipeDidEnd(on: card, direction: CardDirection.rightToLeft)
                    UIView.animate(withDuration: 0.2) {
                        card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                        card.alpha = 0
                        self.layoutIfNeeded()
                    }
                    return
                }
                UIView.animate(withDuration: 0.2) {
                    card.transform = .identity
                    card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                    self.layoutIfNeeded()
                }
            case .changed:
                let rotation = tan(point.x / (self.frame.width * 2.0))
                card.transform = CGAffineTransform(rotationAngle: rotation)
                
            default:
                break
            }
        }
        
        
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
    }
    
    
    
}
