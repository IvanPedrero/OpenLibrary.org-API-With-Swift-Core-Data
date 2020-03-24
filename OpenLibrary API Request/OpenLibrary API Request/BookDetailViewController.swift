//
//  BookDetailViewController.swift
//  OpenLibrary API TableView
//
//  Created by Ivan Pedrero on 3/22/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    // Variables obtained by the segue.
    public var bookName:String = ""
    public var bookAuthors = [String]()
    public var bookImage:String = ""
    
    // Storyboard variables.
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setDetails()
    }
    
    func setDetails(){
        // Add the name.
        bookNameLabel.text = "Title: "+bookName
        
        // Add the authors.
        if (bookAuthors.count == 0) {
            bookNameLabel.text = "No author information available."
        }else{
            bookAuthorsLabel.text = "Author:\n"
            for author in bookAuthors {
                bookAuthorsLabel.text?.append(author+"\n")
            }
        }
        
        // Add the image to the image view.
        var url = URL(string: bookImage)
        // Add a cover if none available.
        if(url == nil){
            url = URL(string: "https://images.squarespace-cdn.com/content/v1/5a5547e1a803bb7df0649e50/1569021071787-GQ6QWL4IMADHSY7W7VH2/ke17ZwdGBToddI8pDm48kKDp-7ip__g8QobJS6Y5m3dZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVFhb23Mwiwo3IFHbJH9edcC4_w0H8oueJbNNKCuHf_kD6QvevUbj177dmcMs1F0H-0/placeholder.png?format=500w")
        }
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let image = UIImage(data: imageData)
            bookImageView.image = image
        }
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
