//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Julia Vasilchenko on 24/01/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category1]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { [self] action in
            //what will happen once the user clicks Add Item button
            let newCategory = Category1(context: context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
        
    
    
    //MARK: - TableView Datasource Methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category1> = Category1.fetchRequest()){
      do {
          categoryArray = try context.fetch(request)
      } catch {
          print("Error fetching data from context\(error)")
      }
   }
  
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "goToItems", sender: self)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let destinationVC = segue.destination as! TodoListViewController
           
           if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.selectedCategory = categoryArray[indexPath.row]
           }
       }
}
