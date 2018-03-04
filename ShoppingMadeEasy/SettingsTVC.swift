//
//  SettingsTVC.swift
//  ShoppingMadeEasy
//
//  Created by Ashish Jayaprakash Baheti (RIT Student) on 5/7/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import UIKit
import UserNotifications

//global variable
//var distance = 500

class SettingsTVC: UITableViewController {
    
    //MARK: - IBOutlets and variables
    var pickerVisible = false
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var date: UILabel!    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - IBActions
    @IBAction func perimeterChanged(_ sender: UISlider) {
//        distance = Int(sender.value)
        infoLabel.text = "Perimeter (" + String(Int(sender.value)) + ")"
        UserDefaults.standard.set(Int(sender.value), forKey: "perimeter")
    }
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        tableView.reloadData()
    }
    
   @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        date.text = dateFormatter.string(from: sender.date)
    
        if sender.date > Date.init() {
            let seconds = sender.date.timeIntervalSince(Date.init())
            print(seconds)
            
            if toggle.isOn {
                let content = UNMutableNotificationContent()
                content.title = "Shopping Reminder!!"
                content.body = "Let's go shopping"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
                let request = UNNotificationRequest(identifier: "demo", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
   }
    
    //MARK: - view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "perimeter") as? Float{
            slider.value = x
            infoLabel.text = "Perimeter (" + String(Int(x)) + ")"
        }
    }

    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                pickerVisible = !pickerVisible
                tableView.reloadData()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 && toggle.isOn == false {
            return 0.0
        }
        if indexPath.section == 1 && indexPath.row == 2 {
            if toggle.isOn == false || pickerVisible == false {
                return 0.0
            }
            return 180.0
        }
        return 56.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 56.0
    }

}
