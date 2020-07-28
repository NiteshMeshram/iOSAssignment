//
//  StackContainerView.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 25/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import UIKit


class StackContainerView: UIView, SwipeCardsDelegate {
    
    //MARK: - Properties
    var numberOfCardsToShow: Int = 0
    var cardsToBeVisible: Int = 3
    var cardViews : [SwipeCardView] = []
    var remainingcards: Int = 0
    
    let horizontalInset: CGFloat = 10.0
    let verticalInset: CGFloat = 5.0
    
    var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }
    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        
        for i in 0..<min(numberOfCardsToShow,cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )
            
        }
    }
    
    //MARK: - Configurations
    
    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        
        DispatchQueue.main.async {
            cardView.delegate = self
            self.addCardFrame(index: index, cardView: cardView)
            self.cardViews.append(cardView)
            self.insertSubview(cardView, at: 0)
            self.remainingcards -= 1
        }
        
    }
    
    func addCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        //        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        DispatchQueue.main.async {
            for cardView in self.visibleCards {
                cardView.removeFromSuperview()
            }
        }
        
        cardViews = []
    }
    
    func swipeDidEnd(on view: SwipeCardView , direction: CardDirection) {
        guard let datasource = dataSource else { return }
        
        if direction == CardDirection.leftToRight {
            if let cardId = view.dataSource?.cardID {
                CoreDataStack.shared.markUserAsFavorite(predicateString: NSPredicate(format: "userId == %@", cardId))
                NotificationCenter.default.post(name: .updateHeartImage, object: nil)
            }
        }else {
        }
        
        
        view.removeFromSuperview()
        
        if remainingcards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingcards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
            
        }else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    
}
