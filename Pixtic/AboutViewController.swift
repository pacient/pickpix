//
//  AboutViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 19/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var versionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLbl.text = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
    }

    @IBAction func aboutPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "about")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func suggestionPressed(_ sender: Any) {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "Could not send email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configureMailComposer() -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["pickpixapp@gmail.com"])
        mailVC.setSubject("PickPix App Feedback")
        
        return mailVC
    }
    
    @IBAction func removeAdsPressed(_ sender: Any) {
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true) { 
            AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
        }
    }
    
    
    //MARK: MFMAilComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
