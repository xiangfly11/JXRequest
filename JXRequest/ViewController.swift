//
//  ViewController.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Session.shared.send(request: TestAPI.getInfo) { (result: Result<TestAPIResultA, Error>) in
            
        }
    }
}

