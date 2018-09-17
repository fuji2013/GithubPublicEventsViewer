//
//  EventCellNode.swift
//  GithubPublicEventsViewer
//
//  Created by hf on 2018/09/15.
//  Copyright © 2018年 swift-studying.com. All rights reserved.
//

import UIKit
import AsyncDisplayKit

struct EventCellViewModel {
    let eventType: String
    let eventDate: String
    let displayName: String
    let avatarUrl: String
    let url: String
    
    init(eventType: String, eventDate: String, displayName: String, avatarUrl: String, url: String) {
        self.eventType = eventType
        self.eventDate = eventDate
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.url = url
    }
    
    init(event: Event) {
        self.eventType = event.type
        self.eventDate = event.eventDate?.description ?? ""
        self.displayName = event.actor.displayName
        self.avatarUrl = event.actor.avatarUrl?.absoluteString ?? ""
        self.url = event.actor.url?.absoluteString ?? ""
    }
}

class EventCellNode: ASCellNode {
    private let viewModel: EventCellViewModel
    
    private let eventTypeNode = ASTextNode()
    private let eventDateNode = ASTextNode()
    private let iconNode = ASNetworkImageNode()
    private let displayNameNode = ASTextNode()
    
    init(viewModel: EventCellViewModel) {
        self.viewModel = viewModel
        super.init()
        
        automaticallyManagesSubnodes = true
        
        // event type
        eventTypeNode.attributedText = NSAttributedString(string: viewModel.eventType)
        eventTypeNode.isLayerBacked = true
        eventTypeNode.maximumNumberOfLines = 1
        
        // date
        eventDateNode.attributedText = NSAttributedString(string: viewModel.eventDate)
        eventDateNode.isLayerBacked = true
        eventDateNode.maximumNumberOfLines = 1
        
        // display name
        displayNameNode.attributedText = NSAttributedString(string: viewModel.displayName)
        displayNameNode.isLayerBacked = true
        displayNameNode.maximumNumberOfLines = 1
        
        // icon
        iconNode.url = URL(string: viewModel.avatarUrl)
        iconNode.isLayerBacked = true
    }
    
    override func didLoad() {
        super.didLoad()
        // UIKitに関してはdidLoadで処理する
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        iconNode.style.preferredSize = CGSize(width: 50, height: 50)
        
        let textLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .spaceBetween,
            alignItems: .start,
            children: [eventTypeNode, eventDateNode, displayNameNode]
        )
        textLayout.style.flexShrink = 1.0
        textLayout.style.flexGrow = 1.0
        
        textLayout.style.spacingBefore = 10
        textLayout.style.spacingAfter = 16
        
        let horizontalNodes: [ASLayoutElement] = [iconNode, textLayout]
        let horizontalStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: horizontalNodes)
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 12, 15, 20), child: horizontalStack)
        
    }
}
