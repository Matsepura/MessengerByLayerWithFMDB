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
        
        switch indexPath.row {
        case let i where i % 10 == 0 || i % 5 == 0:
            height = 130
        case let i where i % 2 == 0:
            let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
            let sizeUp = TextMessageLayer.setupSize(textInCell)
            
            height = sizeUp.height + 40
        default:
            let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
            let sizeUp = TextMessageLayer.setupSize(textInCell)
            
            height = sizeUp.height + 10
        }
        // для теста картинок
        
        self.messages[index].height = height
        return height
    }
    
    override func setupTableView() {
        super.setupTableView()
        self.tableView.registerClass(GroupIncomingTextCell.self, forCellReuseIdentifier: "senderCell")
        self.tableView.registerClass(GroupIncomingImageCell.self, forCellReuseIdentifier: "senderImageCell")
    }
    
}
