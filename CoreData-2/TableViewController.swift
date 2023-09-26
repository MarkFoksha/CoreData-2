//
//  TableViewController.swift
//  CoreData-2
//
//  Created by Марк Фокша on 26.09.2023.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData_2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - viewDidLoad
    var fetchResultController: NSFetchedResultsController<User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(User.firstName), ascending: true)
        
        fetchRequest.fetchLimit = 15
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            try fetchResultController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
        
        fetchResultController.delegate = self
    }

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let user = User(context: persistentContainer.viewContext)
        let range = Int.random(in: 0...1000)
        
        user.firstName = "Name \(range)"
        user.avatar = UIImage(named: "avatar")
        
        let book = Book(context: persistentContainer.viewContext)
        book.name = "Some book"
        
        user.book = book
        
        saveContext()
        tableView.reloadData()
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if indexPath != nil {
                tableView.insertRows(at: [indexPath!], with: .automatic)
            }
        case .delete:
                tableView.deleteRows(at: [indexPath! ], with: .automatic)
        default: break
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchResultController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let user = fetchResultController.object(at: indexPath)
        
        cell.textLabel?.text = user.firstName
        cell.detailTextLabel?.text = user.book?.name
        cell.imageView?.image = user.avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = fetchResultController.object(at: indexPath)
            
            persistentContainer.viewContext.delete(user)
            saveContext()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
