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
    
        self.setupTableView()
        
        self.setupMessengerController()
        self.setupRefreshView()
        
        self.dataBaseManager.fileURL = self.dataBaseManager.getDatabaseURL()
        
        self.dataBaseManager.cleanDatabase()
        self.dataBaseManager.createReaderWriter()
        self.dataBaseManager.createDatabase()
        
        self.messages = self.dataBaseManager.readDatabase(nil, limit: 100)
        self.tableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: true)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setupRefreshView() {
        self.topRefreshView = NHRefreshView(scrollView: self.tableView, direction: .Top) { tableView in
            //  с диспачем никогда не заканчивается
            
            
            if !self.isLoadingMessages {
                    
                    self.isLoadingMessages = true
                    let lastMessage = self.messages.first
                    let newMessages = self.dataBaseManager.readDatabase(lastMessage, limit: 10)
                    
                    if newMessages.count > 0 {
                        
                        self.messages = newMessages + self.messages
                        
                        //                dispatch_async(dispatch_get_main_queue()) {
                        
                        self.tableView.showsVerticalScrollIndicator = false
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 10, inSection: 0), atScrollPosition: .Top, animated: false)
                            self.tableView.layoutIfNeeded()
                            self.stopRefresh()
                            self.tableView.showsVerticalScrollIndicator = true
                        }
                        //                    self.performSelector("stopRefresh", withObject: nil, afterDelay: 0.5)
                        //                }
                    }
                    else {
                        self.isLoadingMessages = false
                    
                        // здесь досоздаем базу данных и суём в начало общего массива
                        print("empty! \n need to append to array new record")
                        self.dataBaseManager.createDatabase()
                        dispatch_async(self.backgroundQueue) {
                            let arrayToAppend = self.dataBaseManager.readDatabase(self.messages.last, limit: 50)
                            for i in 0...49 {
                                self.messages.insert(arrayToAppend[i], atIndex: i)
                            }
                            
//                            self.isLoadingMessages = true
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                                
                                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 50, inSection: 0), atScrollPosition: .Top, animated: false)
//                                self.isLoadingMessages = false
                                self.stopRefresh()
                            }
                        }
                }
            }
                        // здесь вместо return создавать новые объекты догружать и вставлять в начало общего массива
            
        

            
//            dispatch_async(dispatch_get_main_queue()) {
//            self.performSelector("stopRefresh", withObject: nil, afterDelay: 1)
//            }
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
        // бабах
        tableView.registerClass(OutgoingCell.self, forCellReuseIdentifier: "myCell")
        tableView.registerClass(OutgoingCell_Image.self, forCellReuseIdentifier: "myImageCell")
        tableView.registerClass(IncomingCell.self, forCellReuseIdentifier: "senderCell")
        tableView.registerClass(IncomingCell_Image.self, forCellReuseIdentifier: "senderImageCell")
        
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
        
        //!!!!!!!!!!!
        //        self.messengerController.sendButton.setTitle(localize("conversation.placeholder", table: "ConversationLocalization"), forState: .Normal)
        
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
    }
    
    //MARK: - Keyboard show/hide
    
    func keyboardWillShow(notification: NSNotification) {
//        UIView.animateWithDuration(0.1) {
//            self.view.frame.origin.y -= self.getKeyboardHeightFromNotification(notification)
//        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        UIView.animateWithDuration(0.1) {
//            self.view.frame.origin.y += self.getKeyboardHeightFromNotification(notification)
//        }
    }
    
    private func getKeyboardHeightFromNotification(notification: NSNotification) -> CGFloat {
        guard let info = notification.userInfo else { return 0 }
        guard let infoValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
        let keyboardFrame = infoValue.CGRectValue()
        return keyboardFrame.height
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let index = indexPath.row
        let value = self.messages[index]
        var height: CGFloat = value.height
        
        if height > 0 {
            return height
        }
        
//        if indexPath.row == 7 {
//            height = 130
//        } else if indexPath.row == 2 {
//            height = 130
//        } else {
            let textInCell = self.dataBaseManager.getMessageFromId(value.id) ?? ""
            let sizeUp = TextMessageLayer.setupSize(textInCell)
            height = sizeUp.height + 10
//        }
        
        self.messages[index].height = height
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let textInCell = self.dataBaseManager.getMessageFromId(self.messages[indexPath.row])
        
        let cell: UITableViewCell
        //
        switch indexPath.row {
//        case 2:
//            cell = tableView.dequeueReusableCellWithIdentifier("senderImageCell", forIndexPath: indexPath)
//        case 7:
//            cell = tableView.dequeueReusableCellWithIdentifier("myImageCell", forIndexPath: indexPath)
        case let i where i % 2 == 0:
            cell = tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath)
            
            //            (cell as? SenderTableViewCell)?.messageLayer.contentLayer.textLayer.string = textInCell
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
            
            //            (cell as? MyTableViewCell)?.messageLayer.contentLayer.textLayer.string = textInCell
        }
        cell.selectionStyle = .None
        //
        //
        //
        //        switch (indexPath.row, textInCell) {
        //
        //        case (let i, let textForImage) where i % 2 == 0 && textForImage == "message_text-196"
        //            || i % 2 == 0 && textForImage == "message_text-191":
        //
        //            //            self.tableView.layoutIfNeeded()
        //            cell = tableView.dequeueReusableCellWithIdentifier("myImageCell", forIndexPath: indexPath)
        ////            (cell as? MyImageTableViewCell)?.myImageView.backgroundColor = UIColor.lightGrayColor()
        //
        //        case (let i, _) where i % 2 == 0:
        //
        //            cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        ////            cell.myMessageTextLabel.text = textInCell
        //
        //        case (let i, let textForImage) where i % 2 != 0 && textForImage == "message_text-196"
        //            || i % 2 != 0 && textForImage == "message_text-191":
        //
        //            /*
        //            тут я вывожу картинку и выдает такую хрень
        //            Warning once only:
        //            Detected a case where constraints ambiguously suggest a height
        //            of zero for a tableview cell's content view. We're considering
        //            the collapse unintentional and using standard height instead.
        //            saveToDataBase
        //            */
        //
        //            cell = tableView.dequeueReusableCellWithIdentifier("senderImageCell", forIndexPath: indexPath)
        ////            cell.senderImageView.backgroundColor = UIColor.lightGrayColor()
        //
        //        case (let i, _) where i % 2 != 0:
        //
        //            cell = tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath)
        ////            cell.senderMessageTextLabel.text = textInCell
        //
        //        default:
        //            cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        ////            cell.myMessageTextLabel.text = "error in ''tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell'' !"
        //        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //        if let cell = cell as? MyTableViewCell {
        //        }
        
        //задаем текст в бабл
        
        
        let value = self.messages[indexPath.row]
        let textInCell = self.dataBaseManager.getMessageFromId(value.id)
        // бабах
        if let cell = cell as? OutgoingCell {
            cell.reload(textInCell)
            cell.maskedCellDelegate = self
        } else if let cell = cell as? IncomingCell {
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
        let value = self.messages[indexPath.row]
        let textInCell = self.dataBaseManager.getMessageFromId(value.id)
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
        
        self.dataBaseManager.saveToDataBase(messageText) { success, value in
            guard success else { return }
            self.messages.append(value)
            self.tableView.reloadData()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.scrollRectToVisible(CGRect(x: 0, y: self.tableView.contentSize.height - 1, width: 1, height: 1), animated: true)
            }
        }
        (messenger.textInputResponder as? NHTextView)?.text = nil
        butonPressed()
    }
    
}