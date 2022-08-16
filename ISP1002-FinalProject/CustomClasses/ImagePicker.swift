//
//  ImagePicker.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 29/07/22.
//

import Foundation

import UIKit

// Protocol that tracks Image picking
//
protocol ImagePickerDelegate: AnyObject {
    
    // Method that invokes when picking is done
    // params: image: UIImage (Optional)
    // returns: nothing
    //
    func didSelect(image: UIImage?)
}

// Class that handles camera or gallery image picker with delegates
//
class ImagePicker: NSObject, UINavigationControllerDelegate {

    // MARK: - Variables
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    // MARK: Initialsers
    //
    // Initialses the class
    // params: presentationController: UIViewController, delegate: ImagePickeeDelegate
    // returns: object of class
    //
    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    // MARK: - Member functions
    // Method that creates alert action according to available source type
    // params: type: UIImagePickerController.SourceType, title: String
    // returns: UIAlertAction (Optional)
    //
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    // Method that presents alert controller on the injected view
    // params: sourceView: UIView
    // returns: nothing
    //
    func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    // Delegate method when picker has done with image selection
    // params: controller: UIImagePickerController
    // returns: image: UIImage (Optional)
    //
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    // Delegate Method that invokes when picker's cancel is tapped
    // params: picker: UIImagePickerController
    // returns: nothing
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    // Delegate Method that invokes when picker is done picking image
    // params: picker: UIImagePickerController, info: [UIImagePickerController.InfoKey: Any]
    // returns: nothing
    //
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}
