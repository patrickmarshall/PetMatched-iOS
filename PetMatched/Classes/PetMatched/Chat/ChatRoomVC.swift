//
//  ChatRoomVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/21/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import GrowingTextView
import IQKeyboardManagerSwift
import QuartzCore

class ChatRoomVC: BaseViewController {

    // Table View
    @IBOutlet var tableView: UITableView!
    
    // Text View
    @IBOutlet var messageTextView: GrowingTextView!
    @IBOutlet weak var sendImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // Matched View
    @IBOutlet weak var matchView: UIView!
    
    // Data
    var chatName: String = "Andre"
    var roomID: Int = 0
    var petID: Int = 0
    var firstLoad: Bool = true
    
    // Timer
    var timer: Timer?
    
    // Message List
    var messageList: [MessageDateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getChatListAPI), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
        getChatListAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
        
        DispatchQueue.main.async {
            if self.messageList.count != 0 {
                let lastRowNumber = self.tableView.numberOfRows(inSection: self.messageList.count-1) - 1
                let ip: IndexPath = IndexPath(row: lastRowNumber, section: self.messageList.count-1)
                print("section \(self.messageList.count-1), row \(lastRowNumber)")
                self.tableView.scrollToRow(at: ip, at: .top, animated: false)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        
        DispatchQueue.main.async {
            if self.messageList.count != 0 {
                let lastRowNumber = self.tableView.numberOfRows(inSection: self.messageList.count-1) - 1
                let ip: IndexPath = IndexPath(row: lastRowNumber, section: self.messageList.count-1)
                print("section \(self.messageList.count-1), row \(lastRowNumber)")
                self.tableView.scrollToRow(at: ip, at: .top, animated: false)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.removeKeyboardScrollView()
        IQKeyboardManager.shared.enable = true
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = chatName
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.setMatchButton(caller: self)
        
        self.matchView.isHidden = true
        
        messageTextView.layer.cornerRadius = 6
        messageTextView.delegate = self
        
        checkText()
        
        IQKeyboardManager.shared.enable = false
        
        self.keyboardViewBottom(heightCons: self.bottomConstraint, height: 0)
    }
    
    @objc func getChatListAPI() {
        if self.firstLoad {
            self.firstLoad = false
            self.showLoading(view: self.view)
        }
        Network.request(request: APIChat.getChatList(roomid: self.roomID), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOChatListBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let chats = responses.response?.chatMsg {
                        var messageModel: [MessageModel] = []
                        for data in chats {
                            let isMe: Bool = (self.chatName == data.name!) ? false : true
                            let chat = MessageModel(message: data.text!, date: data.addedAt!, isMe: isMe, name: data.name!, photo: data.photo!)
                            messageModel.append(chat)
                        }
                        self.messageListProcess(model: messageModel, method: "get")
                    }
                }
            } else {
                self.showMessage(message: responses.errorMsg!.title!, error: true)
            }
        }, onFailure: { error in
            // If fail while calling API
            self.showMessage(message: error, error: true)
            self.stopLoading()
        })
    }
    
    func sendMessagesAPI(text: String) {
        Network.request(request: APIChat.sendMessage(image: "", text: text, room: self.roomID), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOChatListBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let chats = responses.response?.chatMsg {
                        var messageModel: [MessageModel] = []
                        for data in chats {
                            let isMe: Bool = (self.chatName == data.name!) ? false : true
                            let chat = MessageModel(message: data.text!, date: data.addedAt!, isMe: isMe, name: data.name!, photo: data.photo!)
                            messageModel.append(chat)
                        }
                        self.messageListProcess(model: messageModel, method: "send")
                    }
                }
            } else {
                self.showMessage(message: responses.errorMsg!.title!, error: true)
            }
        }, onFailure: { error in
            // If fail while calling API
            self.showMessage(message: error, error: true)
            self.stopLoading()
        })
    }
    
    func messageListProcess(model: [MessageModel], method: String) {
        self.stopLoading()
        var messages: [MessageDateModel] = []
        var dateNow = Date()
        for i in 0..<model.count {
            let date = model[i].date!.stringParseToDate(oldFormat: "yyyy-MM-dd HH:mm", newFormat: "dd MMMM yyyy")
            if dateNow != date {
                dateNow = date
                messages.append(MessageDateModel(date: dateNow.dateParseToString(newFormat: "dd MMMM yyyy"), messages: [model[i]]))
            } else {
                let va = messages.index(where: { (data) -> Bool in
                    if data.date == model[i].date!.dateParseToString(oldFormat: "yyyy-MM-dd HH:mm", newFormat: "dd MMMM yyyy") {
                        return true
                    } else {
                        return false
                    }
                })
                if va != nil {
                    if messages[va!].messages != nil {
                        messages[va!].messages?.append(model[i])
                    }
                }
            }
        }
        self.messageList = messages
        self.tableView.reloadData()
        
        if method != "get" {
            DispatchQueue.main.async {
                if self.messageList.count != 0 {
                    let lastRowNumber = self.tableView.numberOfRows(inSection: self.messageList.count-1) - 1
                    let ip: IndexPath = IndexPath(row: lastRowNumber, section: self.messageList.count-1)
                    print("section \(self.messageList.count-1), row \(lastRowNumber)")
                    self.tableView.scrollToRow(at: ip, at: .top, animated: false)
                }
            }
        }
    }
    
    func postHistoryAPI(status: Int) {
        Network.request(request: APIHistory.postHistory(id: self.petID, status: status), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOInputHistoryBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.showMessage(message: "Success input history!", error: false)
                }
            } else {
                self.showMessage(message: responses.errorMsg!.title!, error: true)
            }
        }, onFailure: { error in
            // If fail while calling API
            self.showMessage(message: error, error: true)
            self.stopLoading()
        })
    }
    
    func checkText() {
        if self.messageTextView.text == "" {
            self.sendImage.tintColor = .lightGray
            self.sendButton.isEnabled = false
        } else {
            self.sendImage.tintColor = .darkBlue
            self.sendButton.isEnabled = true
        }
    }
    
    override func match() {
        self.matchView.isHidden = false
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        self.sendMessagesAPI(text: self.messageTextView.text!)
        self.messageTextView.text = ""
        self.checkText()
    }
    
    @IBAction func notMatchedAction(_ sender: Any) {
        self.postHistoryAPI(status: 0)
        self.matchView.isHidden = true
    }
    
    @IBAction func matchedAction(_ sender: Any) {
        self.postHistoryAPI(status: 1)
        self.matchView.isHidden = true
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.matchView.isHidden = true
    }
}

extension ChatRoomVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "MessageSenderCell", bundle: self.nibBundle), forCellReuseIdentifier: "MessageSenderCell")
        self.tableView.register(UINib(nibName: "MessageReceiverCell", bundle: self.nibBundle), forCellReuseIdentifier: "MessageReceiverCell")
        self.tableView.register(UINib(nibName: "MessageDateCell", bundle: self.nibBundle), forCellReuseIdentifier: "MessageDateCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ChatRoomVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.messageList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.messageList[section].messages?.count != 0 {
            return self.messageList[section].messages!.count + 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDateCell", for: indexPath) as! MessageDateCell
            cell.messageDateLabel.text = self.messageList[indexPath.section].date!.timeAgoStringFrom(format: "dd MMMM yyyy")
            return cell
        } else {
            if self.messageList[indexPath.section].messages![indexPath.row - 1].isMe! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSenderCell") as! MessageSenderCell
                cell.messageLabel.text = self.messageList[indexPath.section].messages![indexPath.row - 1].message!
                cell.timeLabel.text = self.messageList[indexPath.section].messages![indexPath.row - 1].date!.getHour()
                cell.setup()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageReceiverCell") as! MessageReceiverCell
                cell.profileImage.sd_setImage(with: URL(string: self.messageList[indexPath.section].messages![indexPath.row - 1].photo!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                    if error != nil && image == nil {
                        cell.profileImage.image = UIImage(named: "dummyPlaceholder")
                    }
                }
                cell.messageLabel.text = self.messageList[indexPath.section].messages![indexPath.row - 1].message!
                cell.timeLabel.text = self.messageList[indexPath.section].messages![indexPath.row - 1].date!.getHour()
                cell.setup()
                return cell
            }
        }
    }
}

extension ChatRoomVC: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkText()
    }
}
