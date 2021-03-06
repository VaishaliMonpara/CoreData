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
         
Insert User :

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
            
 
 Get User:
 
 1) We have created function for getData.This function will reuse while search functionality implement or different         types of request in same page.
 
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
         
Delete User :

1) We have created function for DeleteUser.

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
         
2) Here I have user tableview so,I have delete data from swipe action on tabeview's row.So i will call this function from tableview's trailingSwipeActionsConfigurationForRowAt() method.

          let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: users)
          fetchrequest.predicate = NSPredicate(format: "any userName == %@", self.arrData[indexPath.row].userName)
          self.deleteData(request: fetchrequest)
         

Edit User :

1) Below are the code for EditData.Here Username is Unique.So we can find data of that user easily.
        
        var newUser = NSManagedObject()
        let entity = NSEntityDescription.entity(forEntityName: users, in: context!)
         
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
                
For get full Source Code,Click on DownloadButton.

Thankyou.
