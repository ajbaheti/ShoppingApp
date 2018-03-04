//
//  ItemsListTVC.swift
//  ShoppingMadeEasy
//
//  Created by Ashish Jayaprakash Baheti (RIT Student) on 4/24/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import UIKit

class ItemsListTVC: UITableViewController, UISearchResultsUpdating {
    
    //MARK: - Variables
    var storeName: String!
    var items:[Items] = []
    var storeItems:[Items] = []
    var filteredItems:[Items] = []
    let itemSearchController = UISearchController(searchResultsController: nil)
    
    //MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = storeName
        
        let plus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        self.navigationItem.rightBarButtonItem  = plus
        
        itemSearchController.searchResultsUpdater = self
        itemSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = itemSearchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = storeName
        
        //As items are being appended, need to clear each time view appears
        storeItems = []
        
        //get the list of items for store
        getItemsList()
        
        //refresh table view so that latest data can be displayed
        self.tableView.reloadData()
    }
    
    //MARK: - Other useful methods
    func addNewItem() {
        //get storyboard and instantiate AddItemVC and then present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addItemVC") as! AddItemVC
        vc.storeName = storeName
        navigationController?.pushViewController(vc,animated: true)
    }
    
    // get the list of items for selected store if any
    func getItemsList() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        do {
            //fetch complete data of Items entity
            items = try context.fetch(Items.fetchRequest())
            
            //filter to selected store items
            var i = 0
            while i < items.count{
                if items[i].itemStore == storeName {
                    storeItems.append(items[i])
                }
                i += 1
            }
        }
        catch {
            print("Error while fetching items list")
        }
    }
    
    // MARK: - UISearchResultsUpdating methods
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchBar(searchText: searchController.searchBar.text!)
    }
    
    func filteredContentForSearchBar(searchText: String) {
        filteredItems = storeItems.filter({ store in
            return (store.itemName?.lowercased().contains(searchText.lowercased()))!
        })
        self.tableView.reloadData()
    }

    // MARK: - Table view methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemSearchController.isActive && itemSearchController.searchBar.text != "" {
            return filteredItems.count
        }
        return storeItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsTVCCell", for: indexPath)
     
        let item: Items?
        if itemSearchController.isActive && itemSearchController.searchBar.text != "" {
            item = filteredItems[indexPath.row]
        } else {
            item = storeItems[indexPath.row]
        }
     
        cell.textLabel?.text = item?.itemName
        cell.detailTextLabel?.text = "Quantity: "+String(describing: item!.itemQty)
     
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete item action invoked")
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            if itemSearchController.isActive && itemSearchController.searchBar.text != "" {
                //delete from core data Entity
                context.delete(filteredItems[indexPath.row])
            } else {
                //delete from core data Entity
                context.delete(storeItems[indexPath.row])
            }
            
            //minus count from store as well
            var stores:[Store] = []
            do {
                //fetch complete data of Items entity
                stores = try context.fetch(Store.fetchRequest())
            }
            catch {
                print("Error while fetching store list")
            }
            
            var i = 0
            while i < stores.count {
                if stores[i].name == storeName {
                    stores[i].numberOfItems -= 1
                    break
                }
                i += 1
            }
            
            //save the context
            delegate.saveContext()
            
            self.viewWillAppear(false)
            if itemSearchController.isActive && itemSearchController.searchBar.text != "" {
                self.filteredContentForSearchBar(searchText: itemSearchController.searchBar.text!)
            }
        }
    }
}
