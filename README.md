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
            
 
   
