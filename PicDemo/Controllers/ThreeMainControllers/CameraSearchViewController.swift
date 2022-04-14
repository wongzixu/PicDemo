//
//  CameraSearchViewController.swift
//  PicDemo
//
//  Created by 王梓旭 on 2022/4/10.
//

import UIKit
import CoreML
import Vision

class CameraSearchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var text: String?

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    let standard = IdentifierStandard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage.")
            }
            
            detect(image: ciimage)
        }
        // Dissmiss imagpicker camera or photo library
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage) {
        
        guard let mlModel = try? MobileNetV2(configuration: .init()).model ,let model = try? VNCoreMLModel(for: mlModel) else {
            fatalError("Loding CoreML model failed.")
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            if let firstResult = results.first {
                let identifi = firstResult.identifier
                print(identifi)
                self.text = identifi
            }
        }
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segues.cameraToImage, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
       
        if segue.identifier == K.segues.cameraToImage {
            let destinationVC = segue.destination as! ImageReturnViewController
            
            destinationVC.text = standard.getStandardIdentifier(self.text ?? "dog")
            destinationVC.color = "yellow"
        }
    }

}
