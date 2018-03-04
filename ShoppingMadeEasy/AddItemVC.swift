//
//  AddItemVC.swift
//  ShoppingMadeEasy
//
//  Created by Ashish Jayaprakash Baheti (RIT Student) on 4/17/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import UIKit

var itemNameText = ""

class AddItemVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets and variables
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var quantity: UITextField!
    
    var storeName: String = ""
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()        
        itemName.delegate = self
        print("Store name received is \(storeName)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemName.text = itemNameText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        itemNameText = ""
    }
    
    //MARK: - IBAction methods
    @IBAction func viewTapped(sender:AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        if itemName.text != "" {
            if quantity.text != "" {
                print("Item add button action invoked")
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                
                //get the items entity and add new item to it
                let items = Items(context: context)
                items.itemName = itemName.text
                items.itemQty = Int16(quantity.text!)!
                items.itemStore = storeName
                
                //get stores and increase items count by 1 for selected store
                var stores:[Store] = []
                do {
                    //fetch complete data of Items entity
                    stores = try context.fetch(Store.fetchRequest())
                }
                catch {
                    print("Error while fetching items list")
                }
                
                var i = 0
                while i < stores.count {
                    if stores[i].name == storeName {
                        stores[i].numberOfItems += 1
                        break
                    }
                    i += 1
                }
                
                //save the item name to core data entity
                delegate.saveContext()
                
                //go back to Store List view controller
                navigationController!.popViewController(animated: true)
            } else {
                //display an error message for item quantity
                let alert = UIAlertController(title: "Alert", message: "Enter value in Quantity field", preferredStyle: .actionSheet)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            //display an error message for item name
            let alert = UIAlertController(title: "Alert", message: "Enter value in Item Name field", preferredStyle: .actionSheet)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - textfield delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            performSegue(withIdentifier: "itemDictTVC", sender: nil)
        }
        return false
    }
    
}
