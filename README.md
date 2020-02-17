# CoreData

Core data is used to manage the model layer object in our application. You can treat Core Data as a framework to save, track, modify and filter the data within iOS apps, however, Core Data is not a Database.

Step 1 : Create Project and Enable CoreData while create Project.
         It will created already xcdatamodeld file for us.
         
Step 2 : Go To coredata.xcdatamodeld file and click on Add Entity and give name Users.

Step 3 : Click on Users Entity and Attribute like (userName(String), password(String), mobilenumber(String), and profileurl(Binary Data)).

Here we have four field to store data.First is username to store name of user and set the data type for Username it will 
String.Same as for password and mobilenumber.You can take Integer for MobileNumber also.

In Coredata Model we can not store imageDirectly.So we can convert image to Binary data and that binary data will be store in datamodel.

Step 4 : Go to View Controller and Import Coredata as per below:

        import UIKit
        import CoreData
        
Step 5 : Create class variable of NSManagedObjectContext.

What is NSManagedObjectContext?

An object space that you use to manipulate and track changes to managed objects.

         var context: NSManagedObjectContext?
         
InsertData :

  1) In ViewDidLoad() We need to create a context from this container.
    
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         context = appDelegate.persistentContainer.viewContext
         
  2) On Insert User button On Click we have to save data in coredatamodel
         
            var newUser =  NSManagedObject(entity: entity!, insertInto: context)
            let entity = NSEntityDescription.entity(forEntityName: users, in: context!)

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
            
 
 GetData:
 
 1) We have created function for getData.This function will reuse while search functionality implement or different types     of request in same page.
 
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
                         arrData.append(userDetail)
                     }
                 }catch{
                     print("Failed")
                 }
             }
             
  2) Call function for getData whenever you call.
  
          ///set Request for Get saved all Data
          let request = NSFetchRequest<NSFetchRequestResult>(entityName: users)
          getData(request: request)
          
          
 3) SearchData by username
 
 
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
         

