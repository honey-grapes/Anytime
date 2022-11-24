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
            let shorterSide = min(image.size.width, image.size.height)
            //Center-crop original image
            let imageSize = image.size
            let wCenter = (imageSize.width - shorterSide) / 2.0
            let hCenter = (imageSize.height - shorterSide) / 2.0
            let cropZone = CGRect(x: wCenter, y: hCenter, width: shorterSide, height: shorterSide).integral
            let croppedImage = image.cgImage!.cropping(to: cropZone)
            //Save image and close the controller
            parent.imagePicked = (UIImage(cgImage: croppedImage!).pngData())!
            parent.showImagePicker.toggle()
        }
    }
}
