//
//  ViewController.swift
//  AcceptNSExample
//
//  Created by Piotr Ilski on 18.06.2018.
//  Copyright © 2018 Beachy. All rights reserved.
//

import UIKit
import AcceptNS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let card = AcceptNSRequest()
        
        card.cardNumber = "4111111111111111"
        card.expMonth = "10"
        card.expYear = "22"
        card.cvc = "333"
        
        let config = AcceptNSConfig(environment: AcceptNSEnvironment.ENV_TEST)
        config.clientName = "5KP3u95bQpv"
        config.clientKey = "5FcB6WrfHGS76gHW3v7btBCE3HuuBuke9Pj96Ztfn5R32G5ep42vne7MCWZtAucY"
        
        AcceptNS.shared.getToken(config: config, payload: card, completion: { (inResponse) -> () in
            print("We have a result: ")
            print(inResponse ?? "Nie poszlo!")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

