//
//  SwipeCardsDataSource.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 25/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
    
}

protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView, direction: CardDirection)
}

public enum CardDirection {
    case undefined
    case rightToLeft
    case leftToRight
}
