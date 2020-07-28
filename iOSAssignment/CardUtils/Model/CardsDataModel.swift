//
//  CardsDataModel.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 25/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit
struct CardsDataModel {
    
    var bgColor: UIColor
    var text : String
    var image : String
    var cardID : String
      
    init(bgColor: UIColor, text: String, image: String, cardId: String) {
        self.bgColor = bgColor
        self.text = text
        self.image = image
        self.cardID = cardId
    
    }
}
