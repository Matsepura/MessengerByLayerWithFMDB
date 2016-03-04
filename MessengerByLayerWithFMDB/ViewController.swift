//
//  ViewController.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit
import NTextView
import NMessengerController
import NHRefreshView

func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return rgba(r, g: g, b: b, a: 1.0)
}

func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(
        red: r / 255.0,
        green: g / 255.0,
        blue: b / 255.0,
        alpha: a)
}

class ViewController: UIViewController {
    
    // MARK: - Property
    
    let backgroundQueue: dispatch_queue_t = dispatch_queue_create("com.a.identifier", DISPATCH_QUEUE_CONCURRENT)
    
    @IBOutlet weak var viewForLayer: UIView!
    @IBOutlet var someView: UIView!
    
    var tableView: UITableView = UITableView()
    
    var messengerController: NHPhotoMessengerController!
    
    let dataBaseManager = DatabaseModel()
    lazy var messages: [(id: String, height: CGFloat)] = []
    
    var topRefreshView: NHRefreshView!
    var bottomRefreshView: NHRefreshView!
    
    var isLoadingMessages = false
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        self.tableView.backgroundColor = UIColor.lightGrayColor()
        
        self.setupTableView()
        
        self.setupMessengerController()
        self.setupRefreshView()
        
        self.dataBaseManager.fileURL = self.dataBaseManager.getDatabaseURL()
        
        if let relativePath = self.dataBaseManager.fileURL.relativePath where !NSFileManager.defaultManager().fileExistsAtPath(relativePath) {
            self.dataBaseManager.cleanDatabase()
            //                self.dataBaseManager.fileURL = self.dataBaseManager.getDatabaseURL()
            self.dataBaseManager.createReaderWriter()
            self.dataBaseManager.createDatabase()
        } else {
            self.dataBaseManager.createReaderWriter()
        }
        
        self.messages = self.dataBaseManager.readDatabase(nil, limit: 20)
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        // scroll tableView to bottom
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let section = self?.tableView.numberOfSections where section > 0  else { return }
            guard let rows = self?.tableView.numberOfRowsInSection(section - 1) where rows > 0 else { return }
            let indexPath = NSIndexPath(forRow: rows - 1, inSection: section - 1)
            self?.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func setupRefreshView() {
        self.topRefreshView = NHRefreshView(scrollView: self.tableView, direction: .Top) { [weak self] tableView in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.isLoadingMessages == false {
                
                strongSelf.isLoadingMessages = true
                let lastMessage = self?.messages.first
                let newMessages = strongSelf.dataBaseManager.readDatabase(lastMessage, limit: 10)
                
                if newMessages.count > 0 {
                    strongSelf.messages = newMessages + strongSelf.messages
                    strongSelf.tableView.showsVerticalScrollIndicator = false
                    
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        self?.tableView.reloadData()
                        self?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 10, inSection: 0), atScrollPosition: .Top, animated: false)
                        self?.tableView.layoutIfNeeded()
                        self?.stopRefresh()
                        self?.tableView.showsVerticalScrollIndicator = true
                    }
                }
                else {
                    strongSelf.isLoadingMessages = false
                    
                    // здесь досоздаем базу данных и суём в начало общего массива
                    print("empty! \n need to append to array new record")
                    strongSelf.dataBaseManager.createDatabase()
                    dispatch_async(strongSelf.backgroundQueue) { [weak self] in
                        guard let arrayToAppend = self?.dataBaseManager.readDatabase(self?.messages.last, limit: 50) else { return }
                        for i in 0...49 {
                            self?.messages.insert(arrayToAppend[i], atIndex: i)
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) { [weak self] in
                            self?.tableView.reloadData()
                            
                            self?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 50, inSection: 0), atScrollPosition: .Top, animated: false)
                            self?.stopRefresh()
                        }
                    }
                }
            }
        }
        
        self.bottomRefreshView = NHRefreshView(scrollView: self.tableView, direction: .Bottom) { [weak self] tableView in
            self?.performSelector("stopRefresh", withObject: nil, afterDelay: 3)
        }
    }
    
    func stopRefresh() {
        self.topRefreshView?.stopRefreshing()
        self.bottomRefreshView?.stopRefreshing()
        self.tableView.reloadData()
        self.isLoadingMessages = false
        
    }
    
    func setupTableView() {
        
        self.tableView.frame = self.view.bounds
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        
        self.tableView.registerClass(OutgoingTextCell.self, forCellReuseIdentifier: "myCell")
        self.tableView.registerClass(OutgoingImageCell.self, forCellReuseIdentifier: "myImageCell")
        self.tableView.registerClass(IncomingTextCell.self, forCellReuseIdentifier: "senderCell")
        self.tableView.registerClass(IncomingImageCell.self, forCellReuseIdentifier: "senderImageCell")
        
        self.view.addSubview(tableView)
        self.tableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: false)
    }
    
    func setupMessengerController() {
        
        self.messengerController = NHPhotoMessengerController(scrollView: self.tableView, andSuperview: self.view, andTextInputClass: NHTextView.self)
        
        self.messengerController.delegate = self
        self.messengerController.photoDelegate = self
        self.messengerController.separatorView.backgroundColor = UIColor.blackColor()
        
        self.messengerController.attachmentButton.addTarget(self, action: Selector("addPhoto:"), forControlEvents: .TouchUpInside)
        
        self.messengerController.sendButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.messengerController.sendButton.setTitleColor(UIColor.redColor(), forState: .Disabled)
        
        
        self.messengerController.sendButton.backgroundColor = rgb(233, g: 238, b: 239)
        //        self.messengerController.sendButton.titleLabel!.font = UIFont.s_Body_P1()
        
        (self.messengerController.textInputResponder as? NHTextView)?.placeholder = NSLocalizedString("conversation.placeholder", tableName: "ConversationLocalization", comment: "comment")
        (self.messengerController.textInputResponder as? NHTextView)?.textColor = UIColor.darkGrayColor()
        //        (self.messengerController.textInputResponder as? NHTextView)?.font = UIFont.s_Body_P2()
        (self.messengerController.textInputResponder as? NHTextView)?.keyboardType = .Default
        
        (self.messengerController.textInputResponder as? NHTextView)?.useHeightConstraint = true
        (self.messengerController.textInputResponder as? NHTextView)?.isGrowingTextView = true
        (self.messengerController.textInputResponder as? NHTextView)?.numberOfLines = 4
        (self.messengerController.textInputResponder as? NHTextView)?.spellCheckingType = .Yes
        (self.messengerController.textInputResponder as? NHTextView)?.backgroundColor = UIColor.whiteColor()
        (self.messengerController.textInputResponder as? NHTextView)?.tintColor = UIColor.darkGrayColor()
        
        self.messengerController.container.backgroundColor = rgb(233, g: 238, b: 239)
        self.messengerController.sendButton.backgroundColor = rgb(233, g: 238, b: 239)
        self.messengerController.attachmentButton.backgroundColor = rgb(233, g: 238, b: 239)
        self.messengerController.photoCollectionView.backgroundColor = rgb(233, g: 238, b: 239)
        
        (self.messengerController.textInputResponder as? NHTextView)?.findLinks = true
        (self.messengerController.textInputResponder as? NHTextView)?.findHashtags = true
        (self.messengerController.textInputResponder as? NHTextView)?.findMentions = true
        
        var textInsets = (self.messengerController.textInputResponder as? NHTextView)?.textContainerInset
        textInsets?.left = 5
        textInsets?.right = 5
        (self.messengerController.textInputResponder as? NHTextView)?.textContainerInset = textInsets!
        //        (self.messengerController.textInputResponder as? NHTextView)?.mentionAttributes = [NSFontAttributeName : UIFont.s_Body_P2(), NSForegroundColorAttributeName : UIColor._blue()]
        
        (self.messengerController.textInputResponder as? NHTextView)?.hashtagAttributes = [NSForegroundColorAttributeName : UIColor.blueColor()]
        
        (self.messengerController.textInputResponder as? NHTextView)?.linkAttributes = [NSForegroundColorAttributeName : UIColor.blueColor(), NSUnderlineStyleAttributeName : "NSUnderlineStyleSingle"]
        
        self.messengerController.updateMessengerView()
        (self.messengerController.textInputResponder as? NHTextView)?.layer.cornerRadius = ((self.messengerController.textInputResponder as? NHTextView)?.bounds.size.height)! / 2
        
        (self.messengerController.textInputResponder as? NHTextView)?.layer.borderColor = UIColor.lightGrayColor().CGColor
        (self.messengerController.textInputResponder as? NHTextView)?.layer.borderWidth = 1
        
        self.messengerController.updateMessengerView()
    }
    
    func addPhoto(button: UIButton) {
        
        if self.messengerController.imageArray.count < 10 {
            self.addPhotoToMessage()
        } else {
            UIView.animateWithDuration(0.25) {
                self.messengerController.photoCollectionView.alpha = 0.5
            }
            
            UIView.animateWithDuration(0.25, animations: {
                self.messengerController.photoCollectionView.alpha = 0.5
                }, completion: { _ in
                    UIView.animateWithDuration(0.25) {
                        self.messengerController.photoCollectionView.alpha = 1
                    }
            })
        }
    }
    
    func addPhotoToMessage() {
        print("addPhotoToMessage")
    }
    
    func butonPressed() {
        print("butonPressed")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSLog("deinit view controller")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        UIMenuController.sharedMenuController().setMenuVisible(false, animated: false)
    }
    //
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
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
        default:
            let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
            let sizeUp = TextMessageLayer.setupSize(textInCell)
            
            height = sizeUp.height + 10
        }
        
        self.messages[index].height = height
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //                let textInCell = self.dataBaseManager.getMessageFromId(self.messages[indexPath.row])
        
        let cell: UITableViewCell
        //
        switch indexPath.row {
        case let i where i % 10 == 0:
            cell = tableView.dequeueReusableCellWithIdentifier("senderImageCell", forIndexPath: indexPath)
        case let i where i % 5 == 0:
            cell = tableView.dequeueReusableCellWithIdentifier("myImageCell", forIndexPath: indexPath)
        case let i where i % 2 == 0:
            cell = tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath)
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        //задаем текст в бабл
        
        let value = self.messages[indexPath.row]
        let textInCell = self.dataBaseManager.getMessageFromId(value.id)
        // бабах
        if let cell = cell as? OutgoingTextCell {
            cell.reload(textInCell)
            cell.maskedCellDelegate = self
        } else if let cell = cell as? IncomingTextCell {
            cell.reload(textInCell)
            cell.maskedCellDelegate = self
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell number \(indexPath.row)!")
    }
}

// MARK: - UIMenu​Controller (copy)

extension ViewController: MaskedCellProtocol {
    
    func maskedCell(cell: UITableViewCell, canPerfomAction action: Selector) -> Bool {
        return (action == "copy:")
    }
    
    func maskedCellDidCopy(cell: UITableViewCell) {
        guard let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell) else { return }
        //        let value = self.messages[indexPath.row]
        let textInCell = self.dataBaseManager.getMessageFromId(self.messages[indexPath.row].id) ?? ""
        UIPasteboard.generalPasteboard().string = textInCell
    }
}

// MARK: - NHMessengerControllerDelegate, NHPhotoMessengerControllerDelegate

extension ViewController: NHMessengerControllerDelegate, NHPhotoMessengerControllerDelegate {
    
    func didStartEditingInMessenger(messenger: NHMessengerController!) {
        messenger.scrollToBottomAnimated(true)
    }
    func messenger(messenger: NHMessengerController!, willChangeInsets insets: UIEdgeInsets) {
        // определяет что внизу есть строка для ввода инфы и поднимает тэйблВью, чтобы все было ровно
        self.bottomRefreshView?.initialScrollViewInsets.bottom = insets.bottom
    }
    
    func photoMessenger(messenger: NHPhotoMessengerController!, didSendPhotos array: [AnyObject]!) {
        guard let messageText = (messenger.textInputResponder as? NHTextView)?.text else { return }
        
        self.dataBaseManager.saveToDataBase(messageText) { [weak self] success, value in
            guard success else { return }
            self?.messages.append(value)
            self?.tableView.reloadData()
            
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.messengerController?.scrollToBottomAnimated(true)
            }
        }
        (messenger.textInputResponder as? NHTextView)?.text = nil
        butonPressed()
    }
    
}