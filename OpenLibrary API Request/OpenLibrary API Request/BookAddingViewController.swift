//
//  BookAddingViewController.swift
//  OpenLibrary API TableView
//
//  Created by Ivan Pedrero on 3/22/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit

class BookAddingViewController: UIViewController {
    
    // Segue functions.
    var controllerReference = OpenLibraryTableViewController()
    
    // Book to add.
    var bookToAdd = OpenLibraryTableViewController.Books.init(name: "", authors: [], image: "")
    
    // Storyboard variables.
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    
    // Storyboard buttons.
    @IBAction func searchAction(_ sender: Any) {
        // Clean the labels.
        bookTitleLabel.text = ""
        bookAuthorsLabel.text = ""
        bookImageView.image = nil
        
        // Hide the add button.
        addButton.isHidden = true
        
        // Hide the keyboard.
        dismissKeyboard()
        
        /* An example of this would be:
         978-84-376-0494-7      -> With dashes
         0061558230             -> Multiple authors, no cover
         0262131587             -> No author
         0030209692             -> Normal
         9780007311293          -> Not valid, use for testing
        */
        let isbn:String? = isbnTextField.text
        
        // Avoid errors.
        if(isbn == "" || isbn!.count < 10){
            showAlert(alertMessage: "Please provide a valid ISBN.")
            return
        }
        
        // Search the isbn.
        searchISBN(isbnText: isbn!)
    }
    
    @IBAction func addBookAction(_ sender: Any) {
        if(bookToAdd.name != "" || bookToAdd.name != "No title available"){
            controllerReference.addBook(book: bookToAdd)
            print("Added book: " + bookToAdd.name)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Data request and parsing.
    
    func searchISBN(isbnText:String){
        // Avoid internet connection errors.
        if (!Reachability.isConnectedToNetwork()){
            showAlert(alertMessage: "No internet connection.")
            return
        }
        
        // Add to the URL the ISBN given as text.
        let urlForRequest = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbnText
                
        // Create an URL.
        let url = URL(string: urlForRequest)!
        
        // Create the task.
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.processRequestData(dataString: data, isbnText: isbnText)
            }
            
        }
        
        // Resume the task.
        task.resume()
    }
    
    
    /**
            This function will process the Data object into a JSON object for management into dictionaries and strings,
     */
    func processRequestData(dataString:Data, isbnText:String){
        // Process the Data as JSON.
        do
        {
            let json = try JSONSerialization.jsonObject(with: dataString, options: []) as? [String : Any]
                        
            // Get main dictionaries.
            let dict = json! as NSDictionary
            
            // Check for valid book.
            if(dict.count == 0){
                showAlert(alertMessage: "Book not found...")
                return
            }
            
            // Get the ISBN.
            let isbnDict = dict["ISBN:"+isbnText] as! NSDictionary
            
            // Get information dictionaries from main dictionaries.
            
            // Check for title.
            var titleString = "No title available"
            if(isbnDict["title"] != nil){
                titleString = isbnDict["title"] as! NSString as String
            }
            // Check for authors.
            var authorStringArray:Array<String> = []
            if(isbnDict["authors"] != nil){
                let authorArray = isbnDict["authors"] as? NSArray
                for autor in (authorArray!) {
                    let autorDic = autor as! NSDictionary
                    authorStringArray.append(((autorDic["name"] as! NSString) as String))
                }
            }else{
                authorStringArray.append("No author available")
            }
            
            // Check for cover.
            var coverLink = ""
            if(isbnDict["cover"] != nil){
                coverLink = (isbnDict["cover"] as! NSDictionary)["medium"] as! NSString as String
            }else{
                // Add a placeholder cover if none available
                coverLink = "https://images.squarespace-cdn.com/content/v1/5a5547e1a803bb7df0649e50/1569021071787-GQ6QWL4IMADHSY7W7VH2/ke17ZwdGBToddI8pDm48kKDp-7ip__g8QobJS6Y5m3dZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVFhb23Mwiwo3IFHbJH9edcC4_w0H8oueJbNNKCuHf_kD6QvevUbj177dmcMs1F0H-0/placeholder.png?format=500w"
            }
            
            // Assign the values in the text view.
            assignRequestValues(title: titleString, authors: authorStringArray, coverURL: coverLink)
            
            // Assign the current book as the adding book.
            bookToAdd.name = titleString
            bookToAdd.authors = authorStringArray
            bookToAdd.image = coverLink
            
            // Show the button.
            addButton.isHidden = false
            
        }
        catch
        {
            showAlert(alertMessage: "Error while parsing JSON.")
        }
    }
    
    
    /**
            This function will set the values parsed from the JSON in the text view and image view.
     */
    func assignRequestValues(title:String, authors:Array<String>, coverURL:String){
        // Check for title existence.
        if(title != ""){
            // Assign title
            bookTitleLabel.text = "Title : "+title
        }
        
        // Assign the authors.
        for autor in (authors) {
            bookAuthorsLabel.text! += "\nAuthor : " + autor + "\n"
        }
        
        // Add the image to the image view.
        let url = URL(string: coverURL)
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let image = UIImage(data: imageData)
            bookImageView.image = image
        }

    }
    
    
    // MARK: - Alerts
    
    func showAlert(alertMessage:String){
        // Create the alert.
        let alert = UIAlertController(title: "Request Error", message: alertMessage, preferredStyle: .alert)

        // Add the accept button with no action.
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))

        // Present it on the sceen.
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Hide the button.
        addButton.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard(){
    //Causes the view to resign from the status of first responder.
    view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
