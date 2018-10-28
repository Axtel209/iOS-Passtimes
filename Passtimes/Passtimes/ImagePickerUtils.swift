//
//  ImagePickerUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/27/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerUtils: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var picker = UIImagePickerController()
    private var alert = UIAlertController(title: "Change Photo", message: nil, preferredStyle: .actionSheet)
    private var viewController: UIViewController?
    private var pickImageCallback: ((UIImage) -> ())?

    override init() {
        super.init()
    }

    // Present alert to viewController
    func pickImage(_ viewController: UIViewController, _ complition: @escaping (UIImage) -> ()) {
        pickImageCallback = complition
        self.viewController = viewController

        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Choose from Library", style: .default) { UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }

    // Open Camera from alert
    private func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        // Check if device has camera
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            // Present alert if no camera available
            // TODO: Change to avoid deprecated warning
            let alertWarning = UIAlertView(title: "Warning", message: "No camera was detected", delegate: nil, cancelButtonTitle: "OK")
            alertWarning.show()
            //let alertWarning = UIAlertController(title: "Warning", message: "No camera was detected", preferredStyle: .alert)

        }
    }

    // Open Gallery from alert
    private func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        pickImageCallback?(image)
    }

}
