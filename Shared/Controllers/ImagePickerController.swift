//
//  ImagePickerController.swift
//  Anytime
//
//  Created by Josephine Chan on 10/23/22.
//

import SwiftUI

struct ImagePickerController: UIViewControllerRepresentable{
    @Binding var imagePickerSource: UIImagePickerController.SourceType
    @Binding var imagePicked: Data
    @Binding var showImagePicker: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = imagePickerSource
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController
        init (_ parent: ImagePickerController){
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //Switches image picker off
            parent.showImagePicker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //Access the original image from the image picker info dictionary then converting it to a PNG file
            let image = info[.originalImage] as! UIImage
            //Resize and crop image to reduce size before uploading to Firebase
            let shorterSide = min(image.size.width, image.size.height)
            let ratio = 100.0/shorterSide
            let newWidth = image.size.width * ratio
            let newHeight = image.size.height * ratio
            let resize = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
            let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 100.0, height: 100.0)).image{ _ in
                image.draw(in: resize)
            }
            //Save image and close the controller in png format
            parent.imagePicked = resizedImage.pngData()!
            parent.showImagePicker.toggle()
        }
    }
}
