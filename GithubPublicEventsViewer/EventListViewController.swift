//
//  EventListViewController.swift
//  GithubPublicEventsViewer
//
//  Created by hf on 2018/09/15.
//  Copyright © 2018年 swift-studying.com. All rights reserved.
//

import UIKit

// AsyncDisplayKitをインポート
import AsyncDisplayKit

// ASViewController<ASTableNode>を継承
class EventListViewController: ASViewController<ASTableNode> {
    private let eventListController: EventListController = EventListController()
    fileprivate var datas = [EventCellViewModel]()
    var page: UInt = 0
    
    fileprivate var tableNode: ASTableNode {
        return node
    }
    
    init() {
        super.init(node: ASTableNode())
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.view.tableFooterView = UIView()
        tableNode.view.backgroundColor = UIColor.cyan
    }
}

extension EventListViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return eventListController.numberOfFetchdEvents
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellBlock: ASCellNodeBlock = { [weak self] in
            // TODO: ASCellNodeを継承したNodeを返す
            let emptyVm = EventCellViewModel(
                eventType: "Push Event",
                eventDate: "2018/09/15",
                displayName: "Tom",
                avatarUrl: "https://scontent-nrt1-1.cdninstagram.com/vp/9576c2f8ff9c458ae7b3d824828f30d4/5C353734/t51.2885-19/s320x320/35166396_1854571321504130_3944272096611270656_n.jpg", //"https://avatars.githubusercontent.com/u/4578511?",
                url: "https://api.github.com/users/fuji2013"
            )
            
            guard let event = self?.eventListController.fetch(index: indexPath.row) else {
                return EventCellNode(viewModel: emptyVm)
            }
            
            return EventCellNode(viewModel: EventCellViewModel(event: event))
        }
        
        return cellBlock()
    }
}
extension EventListViewController: ASTableDelegate {
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        context.beginBatchFetching()
        loadPage(with: context)
    }
    
    private func insertRow() {
        let section = 0
        var indexPaths = [IndexPath]()
        var vms = [EventCellViewModel]()
        for i in datas.count..<datas.count + 100 {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
            
            let vm = EventCellViewModel(
                eventType: "Push Event",
                eventDate: "2018/09/15",
                displayName: "Tom",
                avatarUrl: "https://scontent-nrt1-1.cdninstagram.com/vp/9576c2f8ff9c458ae7b3d824828f30d4/5C353734/t51.2885-19/s320x320/35166396_1854571321504130_3944272096611270656_n.jpg", //"https://avatars.githubusercontent.com/u/4578511?",
                url: "https://api.github.com/users/fuji2013"
            )
            vms.append(vm)
        }
        datas.append(contentsOf: vms)
        
        DispatchQueue.main.async {
            self.tableNode.insertRows(at: indexPaths, with: .none)
        }
        
        
    }
    
    private func insertRow(_ viewModels: [EventCellViewModel], context: ASBatchContext? = nil) {
        let section = 0
        var indexPaths = [IndexPath]()
        
        let newTotalNumberOfEvents = eventListController.numberOfFetchdEvents
        let existingTotalNumberOfEvents = newTotalNumberOfEvents - viewModels.count
        
        for i in existingTotalNumberOfEvents..<newTotalNumberOfEvents {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableNode.insertRows(at: indexPaths, with: .none)
            context?.completeBatchFetching(true)
        }
    }
    
    private func loadPage(with context: ASBatchContext) {
        page += 1
        eventListController.fetch(page: page) { [weak self] (events) in
            let viewModels = events.map(EventCellViewModel.init(event: ))
            self?.insertRow(viewModels, context: context)
        }
    }
}

