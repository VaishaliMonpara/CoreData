//
//  AddUserVc.swift
//  CoreDataDemo
//
//  Created by MAC0008 on 07/02/20.
//  Copyright © 2020 MAC0008. All rights reserved.
//

import UIKit
import CoreData

class AddUserVc: UIViewController {

    
    //MARK: Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var lblNameExists: UILabel!
    
    ///Variables
    var context: NSManagedObjectContext?
    var imagePicker = UIImagePickerController()
    var userDetail = UserDetail()
    var isEdit = false
    
    ///viewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNameExists.isHidden = true
        if isEdit
        {
            txtUserName.text = userDetail.userName
            txtPassword.text = userDetail.password
            txtMobileNumber.text = userDetail.mobileNumber
            imgProfile.image = UIImage(data: userDetail.photoUrl)
        }
        
        //We need to create a context from this container.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        context!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    ///Button Action
    @IBAction func btnSaveOnClick(_ sender: Any) {
        ///step: 1
        if txtUserName.text!.isEmpty
        {
            self.presentAlertWithoutHandler(title: "Failed to save", message: "Please Enter Username")
            return
        }else if txtPassword.text!.isEmpty
        {
            self.presentAlertWithoutHandler(title: "Failed to save", message: "Please Enter Password")
            return
        }else if txtMobileNumber.text!.isEmpty
        {
            self.presentAlertWithoutHandler(title: "Failed to save", message: "Please Enter MobileNumber")
            return
        }else{
            ///Now let’s create an entity and new user records.
            var newUser = NSManagedObject()
            let entity = NSEntityDescription.entity(forEntityName: users, in: context!)
            
            if isEdit{
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: users)
                request.entity = entity
                let predict = NSPredicate(format: "userName = %@", userDetail.userName)
                request.predicate = predict
                
                do {
                    let result = try context?.fetch(request)
                    if result!.count > 0{
                        newUser = result![0] as! NSManagedObject
                    }else
                    {
                        print("record not found")
                    }
                }catch{
                    print("error")
                }
                
            }else
            {
                newUser = NSManagedObject(entity: entity!, insertInto: context)
            }
            
            ///At last, we need to add some data to our newly created record for each keys using
            newUser.setValue(txtUserName.text!, forKey: username)
            newUser.setValue(txtPassword.text!, forKey: password)
            newUser.setValue(txtMobileNumber.text!, forKey: mobileNumber)
            
            let image: Data = (imgProfile.image?.pngData()!)!
            newUser.setValue(image, forKey: photoUrl)
            ///Save the Data
            do{
                try context!.save()
                presentAlert(title: "Saved", message: "Saved SuccessFully")
            }catch
            {
                print("Failed Saving")
                presentAlert(title: "Failed", message: "Failed To Save..Please try again.")
            }
        }
    }
    
    @IBAction func btnImageUploadOnClick(_ sender: Any) {
        setupImagePicker()
    }
    
    @IBAction func txtFieldeditingDidChange(_ sender: Any) {
        
        ///Filter Data for unique username
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:users)
        fetchRequest.predicate = NSPredicate(format: "userName == %@", txtUserName.text!)
        fetchRequest.returnsObjectsAsFaults = false
        getData(request: fetchRequest)
        
    }
    
    ///Functions
    ///show Alert
    func presentAlert(title: String,message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertWithoutHandler(title: String,message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    ///set up ImagePicker
    func setupImagePicker()
    {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    ///Get Data
    func getData(request: NSFetchRequest<NSFetchRequestResult>)
    {
        request.returnsObjectsAsFaults = false
        var arr = [UserDetail]()
        do{
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject]{
                let userDetail = UserDetail()
                userDetail.userName = data.value(forKey: username) as! String
                userDetail.mobileNumber = data.value(forKey: mobileNumber) as! String
                userDetail.password = data.value(forKey: password) as! String
                userDetail.photoUrl = data.value(forKey: photoUrl) as! Data
                print(data.value(forKey: username) as! String)
                arr.append(userDetail)
            }
            if (arr.count > 0)
            {
                lblNameExists.isHidden = false
            }
            else
            {
                lblNameExists.isHidden = true
            }
        }catch{
            print("Failed")
        }
    }
}

extension AddUserVc: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imgProfile.image = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
