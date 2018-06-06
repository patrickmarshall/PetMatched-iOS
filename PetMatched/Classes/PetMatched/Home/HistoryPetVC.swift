//
//  HistoryPetVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/23/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class HistoryPetVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Data
    var petName = ""
    var petId = 0
    var historyList: [DAOHistoryListResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
        getHistoryAPI()
    }
    
    func setup() {
        self.navigationItem.title = petName.capitalized + "'s History"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
    }
    
    func getHistoryAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APIHistory.getHistory(id: self.petId), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOHistoryListBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.historyList = responses.response!
                    self.tableView.reloadData()
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

extension HistoryPetVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "HistoryListCell", bundle: self.nibBundle), forCellReuseIdentifier: "HistoryListCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension HistoryPetVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryListCell") as! HistoryListCell
        cell.data = self.historyList[indexPath.row]
        cell.setup()
        return cell
    }
}
