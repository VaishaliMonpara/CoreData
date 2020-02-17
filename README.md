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
