//
//  OpenLibraryTableViewController.swift
//  OpenLibrary API TableView
//
//  Created by Ivan Pedrero on 3/22/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
 

class OpenLibraryTableViewController: UITableViewController {
    
    // Struct for the book handling.
    struct Books{
        var name:String
        var authors:[String]
        var image:String
        
        init(name:String, authors:[String], image:String) {
            self.name = name
            self.authors = authors
            self.image = image
        }
    }
      
    // Data source for the table view.
    private var books = [Books]()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Open Library Books"
        
        /*
         FOR TESTING:
         
        self.books.append(Books(name: "It", authors: ["Stephen King"], image: "https://upload.wikimedia.org/wikipedia/en/thumb/5/5a/It_cover.jpg/220px-It_cover.jpg"))
        
        self.books.append(Books(name: "The Name of the Wind", authors: ["Pathrick Rothfuss"], image: "https://images-na.ssl-images-amazon.com/images/I/51PZj2tdTGL.jpg"))
 
         */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.books[indexPath.row].name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "detailSegue" {
            // Assign the controller destination.
            let cc = segue.destination as! BookDetailViewController
            
            // Get the index of the selected row.
            let indexPath = self.tableView.indexPathForSelectedRow
            
            // Pass the selected object to the new view controller.
            cc.bookName = self.books[indexPath!.row].name
            cc.bookAuthors = self.books[indexPath!.row].authors
            cc.bookImage = self.books[indexPath!.row].image
        }
        else if segue.identifier == "addSegue" {
            // Assign the controller destination.
            let cc = segue.destination as! BookAddingViewController
            
            // Assign the object reference.
            cc.controllerReference = self
        }
    }
    
    // MARK: - Book Adding

    public func addBook(book:Books){
        self.books.append(Books(name: book.name, authors: book.authors, image: book.image))
        self.tableView.reloadData()
    }

}
