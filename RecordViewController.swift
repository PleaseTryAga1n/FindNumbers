//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Pavel Serada on 3/7/23.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.gameRecord)
        
        if record != 0{
            recordLabel.text = "Your record is \(record)!"
        }
        else{
            recordLabel.text = "Record is not yet set!"
        }
    }

    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
}
