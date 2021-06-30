//
//  ViewController.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/24.
//

import UIKit
import Alamofire
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Session.shared.send(request: TestAPI.getInfo) { (result: Result<TestAPIResultA, Error>) in
            switch result {
            case .success(let data):
                print(data.a)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        Session.shared.send(request: TestAPI.getDetail(page: 7)).subscribe(onNext: { (result: TestAPIResultB) in
            print(result.b)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
        
        guard let r = TestAPI.getDetail(page: 8).response as? TestAPIResultB else {
            return
        }
        print(r.message)
    }
}

