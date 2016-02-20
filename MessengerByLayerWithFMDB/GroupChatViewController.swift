//
//  GroupChatViewController.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 20.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class GroupChatViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let index = indexPath.row
        let value = self.messages[index]
        var height: CGFloat = value.height
        
        if height > 0 {
            return height
        }
        
        let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
        let sizeUp = TextMessageLayer.setupSize(textInCell)
        
        height = sizeUp.height + 40
        
        self.messages[index].height = height
        return height
    }
    
    override func setupTableView() {
        
        self.tableView.frame = self.view.bounds
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        
        self.tableView.registerClass(OutgoingCell.self, forCellReuseIdentifier: "myCell")
        self.tableView.registerClass(OutgoingCell_Image.self, forCellReuseIdentifier: "myImageCell")
        self.tableView.registerClass(Group_IncomingCell.self, forCellReuseIdentifier: "senderCell")
        self.tableView.registerClass(IncomingCell_Image.self, forCellReuseIdentifier: "senderImageCell")
        
        self.view.addSubview(tableView)
        self.tableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: false)
    }
    
}
