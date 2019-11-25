//
//  ToDoViewController.swift
//  ToDo_TaDa_CoreData
//
//  Created by Iordan, Raluca on 25/11/2019.
//  Copyright © 2019 Iordan, Raluca. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var items: [NSManagedObject] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        
    }
    
    //MARK: Core Data Methods
    
    func fetchData() {
        guard UIApplication.shared.delegate as? AppDelegate != nil else {return}
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        do {
            items = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print (error.description)
        }
    }
    
    
    func save(name: String) {
        
        guard UIApplication.shared.delegate as? AppDelegate != nil else {return}
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let item = Item(context: managedObjectContext)
        item.name = name
        
        do {
            try managedObjectContext.save()
            items.append(item)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    //MARK: Actions
    @IBAction func addItem(_ sender: Any) {
        
        let newItemAlert = UIAlertController(title: "New Item", message: "Add a new item to your list", preferredStyle: .alert)
        
        newItemAlert.view.tintColor = UIColor.hexStringToUIColor(hex: "3de4ff")
        newItemAlert.setValue(NSAttributedString(string: newItemAlert.title!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexStringToUIColor(hex: "3de4ff")]), forKey: "attributedTitle")
        newItemAlert.setValue(NSAttributedString(string: newItemAlert.message!, attributes: [ NSAttributedString.Key.foregroundColor :  UIColor.hexStringToUIColor(hex: "3de4ff")]), forKey: "attributedMessage")

        
        let saveItem = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            
            guard let nameTextField = newItemAlert.textFields?.first, let itemName = nameTextField.text else {
                return
            }
            
            self?.save(name: itemName)
            self?.tableView.reloadData()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        newItemAlert.addTextField(configurationHandler: nil)
        newItemAlert.addAction(saveItem)
        
        newItemAlert.addAction(cancel)
        
        self.present(newItemAlert, animated: true)
    }
    
    
}

//MARK: Table View Data Source
extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "name") as? String
        return cell
    }
}

