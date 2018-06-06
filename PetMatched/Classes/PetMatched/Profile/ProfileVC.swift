//
//  ProfileVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import MXSegmentedPager

class ProfileVC: BaseViewController {

    // Segmented Pager
    @IBOutlet var segmentedPager: MXSegmentedPager!
    var listTitle: [String] = ["My Profile", "My Pet"]
    var vcPager:[UIViewController] = []
    
    var rootDelegate: RootDelegate?
    
    var profile: DAOProfileResponse?
    var pet: DAOPetResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        addHeader()
        setupViewPager()
        getDataAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Profile"
        self.tabBarItem.title = "Profile"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.hideBackButton()
    }
    
    func getDataAPI() {
        Network.request(request: APIProfile.getProfile(), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOProfileBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    let vcSelf = self.vcPager[0] as! ProfileSelfVC
                    self.profile = responses.response!
                    vcSelf.profile = self.profile
                    self.reloadHeader()
                    self.segmentedPager.reloadData()
                }
            } else {
                self.showMessage(message: responses.errorMsg!.title!, error: true)
            }
        }, onFailure: { error in
            // If fail while calling API
            self.showMessage(message: error, error: true)
            self.stopLoading()
        })
        
        Network.request(request: APIProfile.getPet(), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOPetBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    let vcPet = self.vcPager[1] as! ProfilePetVC
                    self.pet = responses.response!
                    vcPet.pet = self.pet
                    self.segmentedPager.reloadData()
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

extension ProfileVC: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    func addHeader() {
        let header:ProfileHeaderView = ProfileHeaderView.instantiateFromNib()
        self.segmentedPager.parallaxHeader.view?.backgroundColor = UIColor("#66CDCC")
        self.segmentedPager.parallaxHeader.view = header
        self.segmentedPager.parallaxHeader.mode = .fill
        self.segmentedPager.parallaxHeader.minimumHeight = 0
        self.segmentedPager.parallaxHeader.height = 180
    }
    
    func reloadHeader() {
        let header = self.segmentedPager.parallaxHeader.view as! ProfileHeaderView
        let tab = self.segmentedPager.segmentedControl.selectedSegmentIndex
        if tab == 0 {
            if let data = self.profile {
                header.profileImage.sd_setImage(with: URL(string: data.photo!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                    if error != nil && image == nil {
                        header.profileImage.image = UIImage(named: "dummyPlaceholder")
                    }
                }
                
                header.profileNameLabel.text = data.name!.capitalized
                header.profileCityLabel.text = data.city!.capitalized
            }
        } else {
            if let data = self.pet {
                header.profileImage.sd_setImage(with: URL(string: data.petPhoto!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                    if error != nil && image == nil {
                        header.profileImage.image = UIImage(named: "dummyPlaceholder")
                    }
                }
                
                header.profileNameLabel.text = data.petName!.capitalized
                header.profileCityLabel.text = data.breedName!.capitalized
            }
        }
    }
    
    func setupViewPager(){
        
        // Storyboard
        let storyboard = UIStoryboard(name: "Profile", bundle: self.nibBundle)
        
        // Self
        let vcSelf = storyboard.instantiateViewController(withIdentifier: "ProfileSelfVC") as! ProfileSelfVC
        vcSelf.delegate = self
        
        // Pet
        let vcPet = storyboard.instantiateViewController(withIdentifier: "ProfilePetVC") as! ProfilePetVC
        vcPet.delegate = self
        
        vcPager.append(vcSelf)
        vcPager.append(vcPet)
        
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        
        let fontTitle = UIFont.systemFont(ofSize: 14)
        let selectedFontTitle = UIFont.boldSystemFont(ofSize: 14)
        
        self.segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font: fontTitle]
        self.segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font: selectedFontTitle]
        self.segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        self.segmentedPager.segmentedControl.type = .text
        self.segmentedPager.segmentedControl.backgroundColor = .white
        self.segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        self.segmentedPager.segmentedControl.selectionIndicatorColor = .baseBlue
        self.segmentedPager.segmentedControl.selectionIndicatorHeight = 2
        self.segmentedPager.segmentedControl.borderColor = .white
        self.segmentedPager.backgroundColor = .white
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return self.listTitle[index]
    }
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return self.listTitle.count
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        return vcPager[index].view
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        reloadHeader()
    }
    
    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 45
    }
}

extension ProfileVC: ProfileDelegate {
    
}
