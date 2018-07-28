//
//  ViewController.swift
//  YSMapNavigation
//
//  Created by Yuns on 2018/7/26.
//  Copyright © 2018年 Yuns. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NavigateMapAlertProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func navigateMapAlertAction(_ sender: Any) {
        navigateAlertUserToDestination(route: .driving, params: NavigateMapParams(lat: 29.56, lng: 106.58, name: "重庆市洪崖洞"), rootVC: self)
    }
    
}

