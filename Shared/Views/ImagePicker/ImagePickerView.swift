//
//  ImagePickerView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/23/22.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var imagePicked: Data
    @Binding var imagePickerSource: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool
    
    var body: some View {
        VStack{
            ImagePickerController(imagePickerSource: $imagePickerSource, imagePicked: $imagePicked, showImagePicker: $showImagePicker)
        }
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(imagePicked: .constant(.init(capacity: 0)), imagePickerSource: .constant(.photoLibrary), showImagePicker: .constant(false))
    }
}
