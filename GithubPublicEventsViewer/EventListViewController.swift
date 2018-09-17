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
    fileprivate var datas = [EventCellViewModel]()
    
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
//        tableNode.view.
        
        let controller = EventListController()
        controller.fetch { (events) in
            print(events)
            print(events.count)
            print("あ")
        }
    }
}

extension EventListViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellBlock: ASCellNodeBlock = {
            // TODO: ASCellNodeを継承したNodeを返す
            let vm = EventCellViewModel(
                eventType: "Push Event",
                eventDate: "2018/09/15",
                displayName: "Tom",
                avatarUrl: "https://scontent-nrt1-1.cdninstagram.com/vp/9576c2f8ff9c458ae7b3d824828f30d4/5C353734/t51.2885-19/s320x320/35166396_1854571321504130_3944272096611270656_n.jpg", //"https://avatars.githubusercontent.com/u/4578511?",
                url: "https://api.github.com/users/fuji2013"
            )
            return EventCellNode(viewModel: vm)
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
//        [context beginBatchFetching];
//        // Notificationをフェッチするコードをここに書きます。
//        fetchNotifications(completion: { () -> Void in
//            let insertedIndexPathes: [NSIndexPath]() = ...
//            // IndexPathの配列を渡して、Insertをします。
//            tableNode.insertRowsAtIndexPaths(insertedIndexPathes, withRowAnimation: .Fade)
//            // 最後にフェッチが完了したことを伝えます。trueは成功したことを意味します。
//            context.completeBatchFetching(true)
//        }
        
//        [context completeBatchFetching:YES];
        insertRow()
        context.completeBatchFetching(true)
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
        
        
//        NSInteger section = 0;
//        NSMutableArray *indexPaths = [NSMutableArray array];
//
//        NSInteger newTotalNumberOfPhotos = [_photoFeed numberOfItemsInFeed];
//        NSInteger existingNumberOfPhotos = newTotalNumberOfPhotos - newPhotos.count;
//        for (NSInteger row = existingNumberOfPhotos; row < newTotalNumberOfPhotos; row++) {
//            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
//            [indexPaths addObject:path];
//        }
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
        
    }
}

