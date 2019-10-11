//
//  StorageController.swift
//  ExportCSV
//
//  Created by Mufakkharul Islam Nayem on 10/10/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

class StorageController {
    static let shared = StorageController()
    private init() { }

    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    var CSVFileURL: URL {
        documentsDirectory.appendingPathComponent("ZOTTZ").appendingPathExtension("csv")
    }

    func createInitialCSVStorage() {
        guard !FileManager.default.fileExists(atPath: CSVFileURL.path) else { return }
        let rowString = "user_name, user_age, scissor, pencil, pincher, button, session_date, timer"
        do {
            try rowString.write(to: CSVFileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }

    func addData(string: String) {
        if let previousString = readCSVData() {
            let merged = [previousString, string].joined(separator: "\n")
            do {
                try merged.write(to: CSVFileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        } else {
            do {
                try string.write(to: CSVFileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }
    }

    func readCSVData() -> String? {
        do {
            let string = try String(contentsOf: CSVFileURL)
            return string
        } catch {
            print(error)
            return nil
        }
    }

}
