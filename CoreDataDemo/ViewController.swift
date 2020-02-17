//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by MAC0008 on 03/02/20.
//  Copyright © 2020 MAC0008. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    ///Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var serchBar: UISearchBar!
    
    ///Variables
    var context: NSManagedObjectContext?
    var arrData = [UserDetail]()
    var selectedIndex = -1
    
    ///ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup TableView
        tblView.estimatedRowHeight = 109
        tblView.rowHeight = tblView.estimatedRowHeight
        tblView.tableFooterView = UIView()
        
        
        ///We need to create a context from this container.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ///set Request for Get saved all Data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: users)
        getData(request: request)
    }

    ///Button Action
    @IBAction func btnAddOnClick(_ sender: Any) {
        ///Redirect to AddUser Page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "AddUserVc") as? AddUserVc
        self.navigationController?.pushViewController(viewController ?? self, animated: true)
    }
    
    //MARK: Functions
    ///DeleteData
    func deleteData(request: NSFetchRequest<NSFetchRequestResult>)
    {
        request.returnsObjectsAsFaults = false
        arrData = [UserDetail]()
        do{
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject]{
                context?.delete(data)
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: users)
            getData(request: request)
        }catch{
            print("Failed")
        }
    }
    
    ///Get Data
    func getData(request: NSFetchRequest<NSFetchRequestResult>)
    {
        request.returnsObjectsAsFaults = false
        arrData = [UserDetail]()
        do{
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject]{
                let userDetail = UserDetail()
                userDetail.userName = data.value(forKey: username) as! String
                userDetail.mobileNumber = data.value(forKey: mobileNumber) as! String
                userDetail.password = data.value(forKey: password) as! String
                userDetail.photoUrl = data.value(forKey: photoUrl) as! Data
                print(data.value(forKey: username) as! String)
                arrData.append(userDetail)
            }
            tblView.reloadData()
        }catch{
            print("Failed")
        }
    }
    
}

///TableView Extension
extension ViewController : UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: userTableViewCell, for: indexPath) as! UserTableViewCell
        cell.setData(data: arrData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.selectedIndex = indexPath.row
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: "AddUserVc") as? AddUserVc
            viewController?.userDetail = self.arrData[self.selectedIndex]
            viewController?.isEdit = true
            self.navigationController?.pushViewController(viewController ?? self, animated: true)
        }
        
        let contextItemDelete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: users)
            fetchrequest.predicate = NSPredicate(format: "any userName == %@", self.arrData[indexPath.row].userName)
            self.deleteData(request: fetchrequest)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItemDelete,contextItem])
        
        return swipeActions
    }
}

//MARK: Search From Database
extension ViewController: UISearchBarDelegate
{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        ///Generate Request for FIlter Data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:users)
        fetchRequest.predicate = NSPredicate(format: "userName CONTAINS %@", searchText)
        fetchRequest.returnsObjectsAsFaults = false
        
        if (searchText.count > 0)
        {
            getData(request: fetchRequest)
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: users)
            getData(request: request)
        }
    }
}

