//
//  StoresTVC.swift
//  ShoppingMadeEasy
//
//  Created by Ashish Jayaprakash Baheti (RIT Student) on 4/24/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class StoresTVC: UITableViewController, UISearchResultsUpdating, CLLocationManagerDelegate {

    //MARK: - variables
    var stores: [Store] = []
    var filteredStores: [Store] = []
    let storeSearchController = UISearchController(searchResultsController: nil)
    var locationManager = CLLocationManager()
    
    //MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ask for local notifications permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {didAllow, error in
            if !didAllow {
                let alert = UIAlertController(title: "Alert", message: "Please allow notifications for this app in Settings in order for app to work at it's best", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
            let alert = UIAlertController(title: "Alert", message: "Please enable location services for this app in Settings in order for app to work at it's best", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
        } // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        self.navigationItem.title = "List of Stores"
        
        let plus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewStore))
        self.navigationItem.rightBarButtonItem  = plus
        
        storeSearchController.searchResultsUpdater = self
        storeSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = storeSearchController.searchBar
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //get the list of stores
        self.getStoreList()
        
        //refresh table view so that latest data can be displayed
        self.tableView.reloadData()
    }
    
    //MARK: - Location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update location called")
        
        if stores.count > 0 {
            let temp = StoreMatch()
            temp.checkForNearByStores(self.stores)
        }
    }
    
    //MARK: - Other useful methods
    func addNewStore() {
        print("add action called")
        performSegue(withIdentifier: "AddNewStoreVC", sender: nil)
    }
    
    //function to send data to ItemsLitVC on click of any row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemsList" {
            if let destination = segue.destination as? ItemsListTVC {
                destination.storeName = sender as! String
                print("sender value -- \(String(describing: sender))")
            }
        }
    }
    
    //get the list of stores from Store core data entity
    func getStoreList() {
        print("getting the store list")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        do {
            //fetch complete data of Store entity
            stores = try context.fetch(Store.fetchRequest())
        }
        catch {
            print("Error while fetching store list")
        }
    }
    
    //create notification method
    func createNoti(name: String) {
        print(name+"-----noti called")
        let content = UNMutableNotificationContent()
        content.title = "Store in vicinity"
        content.body = "A store is found near you to shop from"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "demo", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: - UISearchResultsUpdating delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredContentForSearchBar(searchText: searchController.searchBar.text!)
    }
    
    func filteredContentForSearchBar(searchText: String) {
        filteredStores = stores.filter({ store in
            return (store.name?.lowercased().contains(searchText.lowercased()))!
        })
        self.tableView.reloadData()
    }

    // MARK: - Table view methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if storeSearchController.isActive && storeSearchController.searchBar.text != "" {
            return filteredStores.count
        }
        return stores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoresTVCCell", for: indexPath)
        
        let store: Store?
        if storeSearchController.isActive && storeSearchController.searchBar.text != "" {
            store = filteredStores[indexPath.row]
        } else {
            store = stores[indexPath.row]
        }
        cell.textLabel?.text = store!.name
        cell.detailTextLabel?.text = "Number of Items: "+String(store!.numberOfItems)
        
        return cell
    }
    
    //optional method - on row select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        var data: String = ""
        if storeSearchController.isActive && storeSearchController.searchBar.text != "" {
            data = filteredStores[indexPath.row].name!
        } else {
            data = stores[indexPath.row].name!
        }
        performSegue(withIdentifier: "goToItemsList", sender: data)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var storeName = ""
            if self.storeSearchController.isActive && self.storeSearchController.searchBar.text != "" {
                print("Delete action invoked --- \(String(describing: self.filteredStores[indexPath.row].name))")
                storeName = self.filteredStores[indexPath.row].name!
            } else {
                print("Delete action invoked --- \(String(describing: self.stores[indexPath.row].name))")
                storeName = self.stores[indexPath.row].name!
            }
            
            let alert = UIAlertController(title: "Are you sure you want to delete the Store?", message: "All items will also be deleted", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                
                //delete from core data Entity
                if self.storeSearchController.isActive && self.storeSearchController.searchBar.text != "" {
                    context.delete(self.filteredStores[indexPath.row])
                } else {
                    context.delete(self.stores[indexPath.row])
                }
                
                //delete all items belonging to current store
                var tempItems:[Items] = []
                do {
                    tempItems = try context.fetch(Items.fetchRequest())
                }
                catch {
                    print("Error while fetching items list in store vc")
                }
                
                var i = 0
                while(i < tempItems.count) {
                    if tempItems[i].itemStore == storeName {
                        context.delete(tempItems[i])
                    }
                    i += 1
                }
                
                //save the context
                delegate.saveContext()
                
                self.viewWillAppear(true)
                if self.storeSearchController.isActive && self.storeSearchController.searchBar.text != "" {
                    self.filteredContentForSearchBar(searchText: self.storeSearchController.searchBar.text!)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                self.tableView.setEditing(false, animated: false)
            })
            
            alert.addAction(OKAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
}
