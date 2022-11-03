//
//  ViewController.swift
//  GalleryProtect
//
//  Created by Iosif Dubikovski on 11/1/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pinField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinField.placeholder = "Password"
    }
    @IBAction func unlock(_ sender: Any) {
        view.endEditing(true)
        guard pinField.text == "1234" else {return}
        let galary = GalleryViewController()
        let navigation = UINavigationController(rootViewController: galary)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: false)
        
    }
    
    
}

