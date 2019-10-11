//
//  ViewController.swift
//  ExportCSV
//
//  Created by Mufakkharul Islam Nayem on 10/10/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        StorageController.shared.addData(string: "Zarrar, 9, 3, 3, 3, 3, 3 MAY 2019, 60")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let dataString = StorageController.shared.readCSVData() {
                print(dataString)
            }
        }
    }


}

