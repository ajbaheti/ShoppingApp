//
//  ItemDictionaryTVC.swift
//  ShoppingMadeEasy
//
//  Created by Apurva Tripathi on 5/8/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import UIKit

class ItemDictionaryTVC: UITableViewController, UISearchResultsUpdating {
    
    //MARK: - variables
    let itemdictSearchController = UISearchController(searchResultsController: nil)
    var allItemList:[String] = []
    var filteredList:[String] = []
    var medicines:[String] = []
    var personalCare:[String] = []
    var dairy:[String] = []
    var condiments:[String] = []
    var freshVeggies:[String] = []
    var beverages:[String] = []
    var fruits:[String] = []
    var office:[String] = []
    var frozen:[String] = []
    var grocery:[String] = []
    var spices:[String] = []
    var other:[String] = []
    
    enum groupTitle: Int {
        case medicine = 0,
        personalCare = 1,
        dairy = 2,
        condiments = 3,
        veggies = 4,
        beverage = 5,
        fruit = 6,
        office = 7,
        frozen = 8,
        grocery = 9,
        spice = 10,
        other = 11
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStores()
        
        itemdictSearchController.searchResultsUpdater = self
        itemdictSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = itemdictSearchController.searchBar
    }
    
    // MARK: - UISearchResultsUpdating delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredContentForSearchBar(searchText: searchController.searchBar.text!)
    }
    
    func filteredContentForSearchBar(searchText: String) {
        filteredList = allItemList.filter({ searchString in
            return (searchString.lowercased().contains(searchText.lowercased()))
        })
        self.tableView.reloadData()
    }
    
    //MARK: - Other useful methods
    //Load grouped items list in table view from plist file
    func loadStores() {
        if let path = Bundle.main.path(forResource: "itemsList", ofType: "plist") {
            if let tempDict = NSDictionary(contentsOfFile: path) {
                
                let medArray = (tempDict.value(forKey: "Medicines") as! NSArray) as Array
                for itemName in medArray {
                    medicines.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let pcArray = (tempDict.value(forKey: "PersonalCare") as! NSArray) as Array
                for itemName in pcArray {
                    personalCare.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let dArray = (tempDict.value(forKey: "Dairy") as! NSArray) as Array
                for itemName in dArray {
                    dairy.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let condiArray = (tempDict.value(forKey: "Condiments") as! NSArray) as Array
                for itemName in condiArray {
                    condiments.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let fvArray = (tempDict.value(forKey: "FreshVeggies") as! NSArray) as Array
                for itemName in fvArray {
                    freshVeggies.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let bArray = (tempDict.value(forKey: "Beverages") as! NSArray) as Array
                for itemName in bArray {
                    beverages.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let fruitsArray = (tempDict.value(forKey: "Fruits") as! NSArray) as Array
                for itemName in fruitsArray {
                    fruits.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let oArray = (tempDict.value(forKey: "Office") as! NSArray) as Array
                for itemName in oArray {
                    office.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let fzArray = (tempDict.value(forKey: "Frozen") as! NSArray) as Array
                for itemName in fzArray {
                    frozen.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let gArray = (tempDict.value(forKey: "Groceries") as! NSArray) as Array
                for itemName in gArray {
                    grocery.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let shArray = (tempDict.value(forKey: "SpicesAndHerbs") as! NSArray) as Array
                for itemName in shArray {
                    spices.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
                
                let osArray = (tempDict.value(forKey: "OtherStuff") as! NSArray) as Array
                for itemName in osArray {
                    other.append(itemName as! String)
                    allItemList.append(itemName as! String)
                }
            }
        }
    }
    
    // MARK: - Table view delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        if itemdictSearchController.isActive && itemdictSearchController.searchBar.text != "" {
            return 1
        } else {
            return 12
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemdictSearchController.isActive && itemdictSearchController.searchBar.text != "" {
            return filteredList.count
        } else {
            switch section {
            case groupTitle.medicine.rawValue:
                return medicines.count
            case groupTitle.personalCare.rawValue:
                return personalCare.count
            case groupTitle.dairy.rawValue:
                return dairy.count
            case groupTitle.condiments.rawValue:
                return condiments.count
            case groupTitle.veggies.rawValue:
                return freshVeggies.count
            case groupTitle.beverage.rawValue:
                return beverages.count
            case groupTitle.fruit.rawValue:
                return fruits.count
            case groupTitle.office.rawValue:
                return office.count
            case groupTitle.frozen.rawValue:
                return frozen.count
            case groupTitle.grocery.rawValue:
                return grocery.count
            case groupTitle.spice.rawValue:
                return spices.count
            case groupTitle.other.rawValue:
                return other.count
            default:
                return 0
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualItemCell", for: indexPath)

        if itemdictSearchController.isActive && itemdictSearchController.searchBar.text != "" {
            cell.textLabel?.text = filteredList[indexPath.row]
        } else {
            switch indexPath.section {
            case groupTitle.medicine.rawValue:
                cell.textLabel?.text = medicines[indexPath.row]
                cell.textLabel?.textColor = UIColor.orange
            case groupTitle.personalCare.rawValue:
                cell.textLabel?.text = personalCare[indexPath.row]
                cell.textLabel?.textColor = UIColor.green
            case groupTitle.dairy.rawValue:
                cell.textLabel?.text = dairy[indexPath.row]
                cell.textLabel?.textColor = UIColor.blue
            case groupTitle.condiments.rawValue:
                cell.textLabel?.text = condiments[indexPath.row]
                cell.textLabel?.textColor = UIColor.red
            case groupTitle.veggies.rawValue:
                cell.textLabel?.text = freshVeggies[indexPath.row]
                cell.textLabel?.textColor = UIColor.lightGray
            case groupTitle.beverage.rawValue:
                cell.textLabel?.text = beverages[indexPath.row]
                cell.textLabel?.textColor = UIColor.purple
            case groupTitle.fruit.rawValue:
                cell.textLabel?.text = fruits[indexPath.row]
                cell.textLabel?.textColor = UIColor.black
            case groupTitle.office.rawValue:
                cell.textLabel?.text = office[indexPath.row]
                cell.textLabel?.textColor = UIColor.brown
            case groupTitle.frozen.rawValue:
                cell.textLabel?.text = frozen[indexPath.row]
                cell.textLabel?.textColor = UIColor.magenta
            case groupTitle.grocery.rawValue:
                cell.textLabel?.text = grocery[indexPath.row]
                cell.textLabel?.textColor = UIColor.cyan
            case groupTitle.spice.rawValue:
                cell.textLabel?.text = spices[indexPath.row]
                cell.textLabel?.textColor = UIColor.blue
            case groupTitle.other.rawValue:
                cell.textLabel?.text = other[indexPath.row]
                cell.textLabel?.textColor = UIColor.lightGray
            default:
                cell.textLabel?.text = ""
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if itemdictSearchController.isActive && itemdictSearchController.searchBar.text != "" {
            return "Search Result"
        } else {
            switch section {
            case groupTitle.medicine.rawValue:
                return "Medicines"
            case groupTitle.personalCare.rawValue:
                return "Personal Care"
            case groupTitle.dairy.rawValue:
                return "Dairy"
            case groupTitle.condiments.rawValue:
                return "Condiments"
            case groupTitle.veggies.rawValue:
                return "Fresh Veggies"
            case groupTitle.beverage.rawValue:
                return "Beverages"
            case groupTitle.fruit.rawValue:
                return "Fruits"
            case groupTitle.office.rawValue:
                return "Office"
            case groupTitle.frozen.rawValue:
                return "Frozen"
            case groupTitle.grocery.rawValue:
                return "Grocery"
            case groupTitle.spice.rawValue:
                return "Spices & Herbs"
            case groupTitle.other.rawValue:
                return "Other Stuff"
            default:
                return ""
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemdictSearchController.isActive && itemdictSearchController.searchBar.text != "" {
            itemNameText = filteredList[indexPath.row]
        } else {
            switch indexPath.section {
            case groupTitle.medicine.rawValue:
                itemNameText = medicines[indexPath.row]
            case groupTitle.personalCare.rawValue:
                itemNameText = personalCare[indexPath.row]
            case groupTitle.dairy.rawValue:
                itemNameText = dairy[indexPath.row]
            case groupTitle.condiments.rawValue:
                itemNameText = condiments[indexPath.row]
            case groupTitle.veggies.rawValue:
                itemNameText = freshVeggies[indexPath.row]
            case groupTitle.beverage.rawValue:
                itemNameText = beverages[indexPath.row]
            case groupTitle.fruit.rawValue:
                itemNameText = fruits[indexPath.row]
            case groupTitle.office.rawValue:
                itemNameText = office[indexPath.row]
            case groupTitle.frozen.rawValue:
                itemNameText = frozen[indexPath.row]
            case groupTitle.grocery.rawValue:
                itemNameText = grocery[indexPath.row]
            case groupTitle.spice.rawValue:
                itemNameText = spices[indexPath.row]
            case groupTitle.other.rawValue:
                itemNameText = other[indexPath.row]
            default:
                itemNameText = ""
            }
        }
        
        navigationController?.popViewController(animated: true)
    }

}
