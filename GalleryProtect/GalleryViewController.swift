//
//  GalleryViewController.swift
//  GalleryProtect
//
//  Created by Iosif Dubikovski on 11/1/22.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        
    }
    
    @IBAction func addImageButtonI(_ sender: Any) {
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showPicker(withSourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .cancel) { _ in
            self.showPicker(withSourceType: .photoLibrary)
        }
        let rollAction = UIAlertAction(title: "Saved Photos Album", style: .destructive) { _ in
            self.showPicker(withSourceType: .savedPhotosAlbum)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(rollAction)
        }
        
        present(alert, animated: true)
        
        
       
    }
    
    func setImage(_ image: UIImage, withName name: String? = nil) {
        imageView.image = image
        
        
        
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else { return }
        deletePreviousImage()
        try? data.write(to: fileURL)
        UserDefaults.standard.set(fileName, forKey: "imageName")
    }
    //aaaa
    private func loadImage() {
        guard let fileName = UserDefaults.standard.string(forKey: "imageName") else { return }
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        
        guard let savedData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: savedData) else { return }
        imageView.image = image
    }
    //aaaa
    private func deletePreviousImage() {
        guard let fileName = UserDefaults.standard.string(forKey: "imageName") else { return }
        UserDefaults.standard.removeObject(forKey: "imageName")
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        try? FileManager.default.removeItem(at: fileURL)
    }
    //aaa
    private func showPicker(withSourceType sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = sourceType
        present(pickerController, animated: true)
    }
    
    
}

//extension GalleryViewController:UINavigationControllerDelegate{
//
//}
extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var name: String?
        if let imageName = info[.imageURL] as? URL {
            name = imageName.lastPathComponent
        }
        setImage(image, withName: name)
        self.presentedViewController?.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentedViewController?.dismiss(animated: true)
        let alert = UIAlertController(title: "Strange", message: "You didn't pick any image", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "I know", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
