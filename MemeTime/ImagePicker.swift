//
//  ImagePicker.swift
//  MemeTime
//
//  Created by Ethan Humphrey on 10/30/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?
    @Binding var imageAspectRatio: CGFloat

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var imageAspectRatio: CGFloat

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, imageAspectRatio: Binding<CGFloat>) {
            _presentationMode = presentationMode
            _image = image
            _imageAspectRatio = imageAspectRatio
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            imageAspectRatio = CGFloat(uiImage.size.height / uiImage.size.width)
            print(imageAspectRatio)
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, imageAspectRatio: $imageAspectRatio)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
