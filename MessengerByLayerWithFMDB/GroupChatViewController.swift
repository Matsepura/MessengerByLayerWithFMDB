//
//  GroupChatViewController.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 20.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class GroupChatViewController: ViewController {
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let index = indexPath.row
        let value = self.messages[index]
        var height: CGFloat = value.height
        
        switch indexPath.row {
            
        case let i where i % 10 == 0:
            if let image = UIImage(named: "horse") {
                let size = image.size
                let ratio = size.width / size.height
                height = 220 / ratio
                return height + 10
            } else {
                height = 130 }
            
        case let i where i % 5 == 0:
            if let image = UIImage(named: "cat") {
                let size = image.size
                let ratio = size.width / size.height
                height = 220 / ratio
                return height + 10
            } else {
                return 130
            }
            
        case let i where i % 2 == 0:
            if height > 0 {
                return height
            }
            
            let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
            let sizeUp = TextMessageLayer.setupSize(textInCell)
            
            height = sizeUp.height + 40
        default:
            let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
            let sizeUp = TextMessageLayer.setupSize(textInCell)
            
            height = sizeUp.height + 10
        }
        
        self.messages[index].height = height
        return height
    }
    
    override func setupTableView() {
        super.setupTableView()
        self.tableView.registerClass(GroupIncomingTextCell.self, forCellReuseIdentifier: "senderCell")
        self.tableView.registerClass(GroupIncomingImageCell.self, forCellReuseIdentifier: "senderImageCell")
    }
}