//
//  ViewController.swift
//  WibrickFrameworkDemo
//
//  Created by Anders Zetterström on 2017-07-26.
//  Copyright © 2017 Wibrick Solutions. All rights reserved.
//

import UIKit
import WibrickFramework

class ViewController: UIViewController {

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!

    
    var storageCoach = StorageCoach.sharedInstance
    var apiCoach: APICoach!
    var wibrickCoach: WibrickCoach!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init ApiCoach with using App Identity and App Secret from WibrickFrameworkProperties.plist
        // Make sure you enter your App Identy and App Secret!
        apiCoach = APICoach()
        
        // register callback for Event (in this example eventCallback is registered in AppAPICallback)
        //apiCoach.registerEventCallback(eventCallback: eventCallback)
        
        // register callback for Content via API response
        apiCoach.registerCallback(callback: AppAPICallback(view: contentView, changeUI: changeUI))
        
        // handshake with portal
        apiCoach.handshake(callback: AppHandshakeCallback())
        
        //register APICoach for StorageCoach
        storageCoach.registerApiCoach(apiCoach: apiCoach)
        
        //init WibrickCoach and start Monitioring and Ranging regions collected from API and saved Core data
        wibrickCoach = WibrickCoach()
        
        //register callback for hits when ranging
        wibrickCoach.registerCallback(callback: AppRangingCallback())
    }

    
    
//    func eventCallback(eventResponse: EventResponse) {
//        
//        
//    }
    
    func changeUI(settings: Dictionary<String, String>) {
        
        if let themeColor = settings["themeColor"] {

            topBar.backgroundColor = UIColor.init(hexString: themeColor)
        }
        
        if let title = settings["title"] {
            
            titleLabel.text = title
        }
    }
}

