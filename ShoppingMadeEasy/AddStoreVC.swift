//
//  AddStoreVC.swift
//  ShoppingMadeEasy
//
//  Created by Apurva Tripathi on 4/1/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import UIKit

class AddStoreVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //MARK: - Outlets and Variables
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var listOfStores: UIPickerView!
    
    var storeList: [String] = []
    var storeType: [String] = []
    var type = ""
    
    //MARK: - IBAction methods
    @IBAction func addButton(_ sender: Any) {
        
        if storeName.text != "" {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            var stores: [Store] = []
            
            do {
                //fetch complete data of Store entity
                stores = try context.fetch(Store.fetchRequest())
            }
            catch {
                print("Error while fetching store list")
            }
            
            let temp = stores.first(where: {$0.name == storeName.text!})
            
            //alert if user is trying to add same store in the list again
            if temp != nil {
                let alert = UIAlertController(title: "Alert", message: "Store already exist", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                present(alert, animated: true, completion: nil)                
            } else {
                //get the store entity and add store name to it
                let store = Store(context: context)
                store.name = storeName.text!
                store.type = type
            }
            
            //save the store name to core data entity
            delegate.saveContext()
            
            //go back to Store List view controller
            navigationController!.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Enter value in Store Name field", preferredStyle: .actionSheet)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // on view tap
    @IBAction func viewTapped(sender:AnyObject){
        listOfStores.isHidden = true
    }
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStores()
        storeName.delegate = self
    }
    
    //MARK: - Other useful methods
    //Load stores list in picker view from plist file
    func loadStores() {
        if let path = Bundle.main.path(forResource: "storeList", ofType: "plist") {
            if let tempDict = NSDictionary(contentsOfFile: path) {
                let tempArray = (tempDict.value(forKey: "stores") as! NSArray) as Array
                
                for dict in tempArray {
                    storeList.append(dict["name"] as! String)
                    storeType.append(dict["type"] as! String)
                }
            }
        }
    }
    
    //MARK: - Textfield Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {        
        listOfStores.isHidden = false
        self.view.endEditing(true)
    }
    
    // MARK: - Picker View Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return storeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storeName.text = storeList[row]
        type = storeType[row]
    }
}
