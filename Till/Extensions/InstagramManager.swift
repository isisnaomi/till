//
//  InstagramManager.swift
//  InstagramSDK
//
//  Created by Attila Roy on 23/02/15.
//  share image with caption to instagram

import Foundation
import UIKit

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram-stories:://share"
    private let kUTI = "com.instagram.photo" //"com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.ig"//"instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, event: Event, view: UIView) -> Bool {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = InstagramStory(frame: CGRect(x: 0, y: 0, width: 360, height: 640))
                myView.setBackground(image: imageInstagram)
                myView.setData(event: event)
                let image = imageFromView(with: myView)!
                guard let imageData = image.pngData() else { return false }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#000000",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#262829"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func imageFromView(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}


