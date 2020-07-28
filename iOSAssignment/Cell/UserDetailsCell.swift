//
//  UserDetailsCell.swift
//  UserAssignment
//
//  Created by Nitesh Meshram on 22/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit

class UserDetailsCell: UITableViewCell {
    
    
    
    @IBOutlet weak var photoImageview: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func makeRounded() {
        
        photoImageview.layer.borderWidth = 1
        photoImageview.layer.masksToBounds = false
        photoImageview.layer.borderColor = UIColor.black.cgColor
        photoImageview.layer.cornerRadius = frame.height/2
        photoImageview.clipsToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImageview.contentMode = .scaleAspectFill
        photoImageview.translatesAutoresizingMaskIntoConstraints = false
        photoImageview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        photoImageview.layer.masksToBounds = true
        self.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.photoImageview.image = UIImage(named: "placeholder")
    }
    
    func setUserCellWith(user: UserDetails) {
        
        DispatchQueue.main.async {
            self.userNameLabel.text = "Name : \(String(describing: user.userFullName!))"
            self.emailLabel.text = "Email Id : \(user.userId!)"
            self.genderLabel.text = "Gender : \(String(describing: user.userGender!))"
            if let url = user.userImageURL {
                self.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                
            }
        }
    }
    
}
