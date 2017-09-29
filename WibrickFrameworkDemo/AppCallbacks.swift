//
//  AppCallbacks.swift
//  WibrickFrameworkDemo
//
//  Created by Anders Zetterström on 2017-07-26.
//  Copyright © 2017 Wibrick Solutions. All rights reserved.
//

import Foundation
import WibrickFramework

class AppHandshakeCallback: Callback {
    
    override func onSuccess(type: CallbackType) {
        print("Handshake Success!")
    }
    
    override func onFailure(type: CallbackType) {
        print("Handshake Failure")
    }
    
}

class AppAPICallback: APICallback {
    
    private var _contentView: UIView
    private var _changeUI: (Dictionary<String, String>) -> ()
    
    init(view: UIView, changeUI: @escaping (Dictionary<String, String>) -> ()) {
        
        _contentView = view
        _changeUI = changeUI
    }
    
    override func onSuccess(type: CallbackType) {
        
        if let apiResponse = getResponseAsAPIResponse() {
            
            apiResponse.registerEventCallback(callback: eventCallback)
            
            if apiResponse.content.hasContent {
                
                var settings = Dictionary<String, String>()
                
                if let theme = apiResponse.content.getProperty(named: "theme") as? Dictionary<String, AnyObject> {
                    
                    if let logo = theme["logo"] as? String {
                        //URL address for logotype if any
                        if !logo.isEmpty {
                            
                            settings.updateValue(logo, forKey: "logo")
                        }
                    }
                    
                    if let color = theme["color"] as? String {
                        // HEX color (#aarrggbb)
                        if !color.isEmpty {
                            
                            settings.updateValue(color, forKey: "themeColor")
                        }
                    }
                }
                
                if !apiResponse.content.title.isEmpty {
                    //content title
                    settings.updateValue(apiResponse.content.title, forKey: "title")
                }
                //remove subview
                _contentView.subviews.first?.removeFromSuperview()
                // add the UIView with the content
                _contentView.addSubview(apiResponse.content.getView(forSize: _contentView.frame.size))
                _changeUI(settings)
            }
        }
    }
    
    override func onFailure(type: CallbackType) {
        
        if let errorResponse = getResponseAsErrorResponse() {
            
            print(errorResponse.message)
        }
    }
    
    func eventCallback(eventResponse: EventResponse) {
        //all events has to be configured in backend and added to desired element in content
        
        // example of event types
        switch eventResponse.type {
        case "load":
            // used to get indication that content is loaded
            break
        case "show":
            // used mainly for getting event callback when sliding in slideshow
            break
        case "tap":
            // some Element in content has ben tapped
            if eventResponse.message == "link" {
                // if it´s a web-URL maybe open it in a WebView or let Safari open it
            }
            break
        default:
            
            break
        } 
    }
}

class AppRangingCallback: LocationCallback {
    
    override func onSuccess(type: CallbackType){

        switch type {
        case .enterTriggerzone:
            
            //Do something when you are entering a trigger zone
            let triggeredWibrickBeacon = getResponseAsWibrickBeacon()
            print("\(type) \(triggeredWibrickBeacon?.identifier ?? "N/A")")
            break
        case .exitTriggerZone:
            
            //Do something when you are exiting a trigger zone
            let triggeredWibrickBeacon = getResponseAsWibrickBeacon()
            print("\(type) \(triggeredWibrickBeacon?.identifier ?? "N/A")")
            break
        case .enterRegion:
            
            //Do something when you are entering a region
            let triggeredRegion = getResponseAsRegion()
            print("\(type) \(triggeredRegion?.identifier ?? "N/A")")
            break
        case .exitRegion:
            
            //Do something when you are exiting a region
            let triggeredRegion = getResponseAsRegion()
            print("\(type) \(triggeredRegion?.identifier ?? "N/A")")
            break
        default:
            // Oops! this is awkward...
            break
        }
    }
}


