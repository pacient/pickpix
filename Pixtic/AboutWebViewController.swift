//
//  AboutWebViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 26/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class AboutWebViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let htmlFile = Bundle.main.path(forResource: "about", ofType: "html")
        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webview.loadHTMLString(html!, baseURL: nil)
    }


}
