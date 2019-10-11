//
//  FormTableViewController.swift
//  ExportCSV
//
//  Created by Mufakkharul Islam Nayem on 10/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit
import MessageUI

class FormTableViewController: UITableViewController {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var scissorValueLabel: UILabel!
    @IBOutlet weak var pencilValueLabel: UILabel!
    @IBOutlet weak var pincherValueLabel: UILabel!
    @IBOutlet weak var buttonValueLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var countDownTimerLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    
    // MARK: Steppers
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var scissorStepper: UIStepper!
    @IBOutlet weak var pencilStepper: UIStepper!
    @IBOutlet weak var pincherStepper: UIStepper!
    @IBOutlet weak var buttonStepper: UIStepper!
    @IBOutlet weak var timerStepper: UIStepper!
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter
    }
    private var _isTimerRunning = false
    private var isTimerRunning = false {
        didSet {
            _isTimerRunning = isTimerRunning
            if isTimerRunning {
                shareButton.isEnabled = false
                nameTextField.isEnabled = false; nameTextField.alpha = 0.2
                ageStepper.isEnabled = false; ageStepper.alpha = 0.2
                scissorStepper.isEnabled = true; scissorStepper.alpha = 1.0
                pencilStepper.isEnabled = true; pencilStepper.alpha = 1.0
                pincherStepper.isEnabled = true; pincherStepper.alpha = 1.0
                buttonStepper.isEnabled = true; buttonStepper.alpha = 1.0
                timerStepper.isEnabled = false; timerStepper.alpha = 0.2
            } else {
                shareButton.isEnabled = true
                nameTextField.isEnabled = true; nameTextField.alpha = 1.0
                ageStepper.isEnabled = true; ageStepper.alpha = 1.0
                scissorStepper.isEnabled = false; scissorStepper.alpha = 0.2
                pencilStepper.isEnabled = false; pencilStepper.alpha = 0.2
                pincherStepper.isEnabled = false; pincherStepper.alpha = 0.2
                buttonStepper.isEnabled = false; buttonStepper.alpha = 0.2
                timerStepper.isEnabled = true; timerStepper.alpha = 1.0
            }
        }
    }
    
    private var timeRemaining = 0 {
        didSet {
            countDownTimerLabel.text = timeRemaining.formattedAsMinuteSecond
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        dateValueLabel.text = dateFormatter.string(from: Date())
        // force set the status of timer running state
        isTimerRunning = _isTimerRunning
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareButton.isEnabled = isTimerRunning
        startTimerButton.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }

    @IBAction func ageStepperValueDidChange(_ sender: UIStepper) {
        ageValueLabel.text = sender.value.formattedAsDecimal
    }
    @IBAction func scissorStepperValueDidChange(_ sender: UIStepper) {
        scissorValueLabel.text = sender.value.formattedAsDecimal
    }
    @IBAction func pencilStepperValueDidChange(_ sender: UIStepper) {
        pencilValueLabel.text = sender.value.formattedAsDecimal
    }
    @IBAction func pincherStepperValueDidChange(_ sender: UIStepper) {
        pincherValueLabel.text = sender.value.formattedAsDecimal
    }
    @IBAction func buttonStepperValueDidChange(_ sender: UIStepper) {
        buttonValueLabel.text = sender.value.formattedAsDecimal
    }
    @IBAction func timerStepperValueDidChange(_ sender: UIStepper) {
        timerValueLabel.text = sender.value.formattedAsDecimal
    }

    private func saveDataInCSVStorage() {
        if let name = nameTextField.text, let age = ageValueLabel.text, let scissorValue = scissorValueLabel.text,
            let pencilValue = pencilValueLabel.text, let pincherValue = pincherValueLabel.text,
            let buttonValue = buttonValueLabel.text, let date = dateValueLabel.text, let timer = timerValueLabel.text {
            let composedString = [name, age, scissorValue, pencilValue, pincherValue, buttonValue, date, timer].joined(separator: ", ")
            print(composedString)
            
            StorageController.shared.addOrMergeIntoCSVStorage(string: composedString)   //FIXME: This should be done when saving is needed
        }
    }
    
    @IBAction func shareButtonDidTap(_ sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            do {
                let fileURL = StorageController.shared.CSVFileURL
                let data = try Data(contentsOf: fileURL)
                let mailViewController = MFMailComposeViewController()
                mailViewController.mailComposeDelegate = self
                mailViewController.setSubject("ZOTTZ OT Data")
                mailViewController.addAttachmentData(data, mimeType: "text/plain", fileName: fileURL.lastPathComponent)
                present(mailViewController, animated: true)
            } catch {
                print("Couldn't initialize data")
            }
        } else {
            print("Mailing not supported")
        }
    }

    @IBAction func startTimerButtonDidTap(_ sender: UIButton) {
        if !isTimerRunning {
            guard let allowedTime = timerValueLabel.text, let allowedElapsedTime = Int(allowedTime) else { return }
            isTimerRunning = true
            startTimerButton.alpha = 0.2
            var timeElapsed = 0
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                timeElapsed += 1
                self?.timeRemaining = allowedElapsedTime - timeElapsed
                if timeElapsed == allowedElapsedTime {
                    timer.invalidate()
                    self?.isTimerRunning = false
                    self?.startTimerButton.alpha = 1.0
                    self?.saveDataInCSVStorage()
                }
            }
        }
    }
    
}

extension FormTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension FormTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Make sure this method is being called
        guard textField == nameTextField else { return true }
        let newLength = (textField.text?.count ?? 0) - range.length + string.count
        startTimerButton.isEnabled = newLength > 0
        return true
    }
}

extension Double {
    var formattedAsDecimal: String {
        NumberFormatter.localizedString(from: NSNumber(value:self), number: .decimal)
    }
}

extension Int {
    var formattedAsMinuteSecond: String {
        let minutes = self / 60 % 60
        let seconds = self % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
