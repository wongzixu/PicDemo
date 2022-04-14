//
//  TextSearchViewController.swift
//  PicDemo
//
//  Created by 王梓旭 on 2022/4/10.
//

import UIKit

class TextSearchViewController: UIViewController {
    
    
    @IBOutlet weak var substanceKeywordTextField: UITextField!
    @IBOutlet weak var colorKeywordTextField: UITextField!
    
    let standard = IdentifierStandard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchNow(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segues.textToImage, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.textToImage {
            let destinationVC = segue.destination as! ImageReturnViewController
            destinationVC.color = colorKeywordTextField.text ?? "red"
            destinationVC.text = standard.getStandardIdentifier(substanceKeywordTextField.text ?? "dog")
        }
    }

}
