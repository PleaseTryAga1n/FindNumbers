//
//  YellowViewController.swift
//  FindNumber
//
//  Created by Pavel Serada on 2/23/23.
//

import UIKit

class YellowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func goToBlueControllerButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToBlueId", sender: nil)
    }
    

}
