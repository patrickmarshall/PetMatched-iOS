//
//  ChatVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SDWebImage

class ChatVC: BaseViewController {

    // Root Delegate
    var rootDelegate: RootDelegate?
    
    var roomList: [DAORoomListRooms] = []
    
    // Table View
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
        getRoomListAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Chats"
        self.tabBarItem.title = "Chat"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.hideBackButton()
        self.emptyView.isHidden = true
    }

    func getRoomListAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APIChat.getRoomList(), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAORoomListBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let rooms = responses.response?.rooms {
                        self.roomList = rooms
                        if self.roomList.count == 0 {
                            self.emptyView.isHidden = false
                        } else {
                            self.emptyView.isHidden = true
                        }
                        self.tableView.reloadData()
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
}

extension ChatVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "ChatListCell", bundle: self.nibBundle), forCellReuseIdentifier: "ChatListCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        vc.chatName = self.roomList[indexPath.row].name!
        vc.roomID = self.roomList[indexPath.row].roomId!
        vc.petID = self.roomList[indexPath.row].memberId!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ChatVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.roomList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        cell.profileImage.sd_setImage(with: URL(string: data.photo!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
            if error != nil && image == nil {
                cell.profileImage.image = UIImage(named: "dummyPlaceholder")
            }
        }
        cell.profileNameLabel.text = data.name!
        cell.lastChatLabel.text = data.lastMsg!.text!
        if data.lastMsg!.timestamp != "" {
            cell.chatDateLabel.text = data.lastMsg!.timestamp!.roomListDateFormatter()
        } else {
            cell.chatDateLabel.text = ""
        }
        return cell
    }
}
