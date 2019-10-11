//
//  FormTableViewController.swift
//  ExportCSV
//
//  Created by Mufakkharul Islam Nayem on 10/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var scissorValueLabel: UILabel!
    @IBOutlet weak var pencilValueLabel: UILabel!
    @IBOutlet weak var pincherValueLabel: UILabel!
    @IBOutlet weak var buttonValueLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var timerValueLabel: UILabel!

    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateValueLabel.text = dateFormatter.string(from: Date())
    }

    @IBAction func ageStepperValueDidChange(_ sender: UIStepper) {
        ageValueLabel.text = sender.value.formattedForDisplay
    }
    @IBAction func scissorStepperValueDidChange(_ sender: UIStepper) {
        scissorValueLabel.text = sender.value.formattedForDisplay
    }
    @IBAction func pencilStepperValueDidChange(_ sender: UIStepper) {
        pencilValueLabel.text = sender.value.formattedForDisplay
    }
    @IBAction func pincherStepperValueDidChange(_ sender: UIStepper) {
        pincherValueLabel.text = sender.value.formattedForDisplay
    }
    @IBAction func buttonStepperValueDidChange(_ sender: UIStepper) {
        buttonValueLabel.text = sender.value.formattedForDisplay
    }
    @IBAction func timerStepperValueDidChange(_ sender: UIStepper) {
        timerValueLabel.text = sender.value.formattedForDisplay
    }

    @IBAction func shareButtonDidTap(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text, let age = ageValueLabel.text, let scissorValue = scissorValueLabel.text,
            let pencilValue = pencilValueLabel.text, let pincherValue = pincherValueLabel.text,
            let buttonValue = buttonValueLabel.text, let date = dateValueLabel.text, let timer = timerValueLabel.text {
            let composedString = [name, age, scissorValue, pencilValue, pincherValue, buttonValue, date, timer].joined(separator: ", ")
            print(composedString)

            StorageController.shared.addOrMergeIntoCSVStorage(string: composedString)   //FIXME: This should be done when saving is needed
            let files = [StorageController.shared.CSVFileURL]
            let activityViewController = UIActivityViewController(activityItems: files, applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }


}

extension Double {
    var formattedForDisplay: String {
        NumberFormatter.localizedString(from: NSNumber(value:self), number: .decimal)
    }
}