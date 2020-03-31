//
//  OpenGallary.swift
//  Till
//
//  Created by Isis Ramirez on 17/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import SwiftUI

struct OpenGallary: UIViewControllerRepresentable {

let isShown: Binding<Bool>
let image: Binding<UIImage?>
let imagePicked: Binding<Bool>


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let isShown: Binding<Bool>
    let image: Binding<UIImage?>
    let imagePicked: Binding<Bool>

    init(isShown: Binding<Bool>, image: Binding<UIImage?>, imagePicked: Binding<Bool>) {
        self.isShown = isShown
        self.image = image
        self.imagePicked = imagePicked
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.image.wrappedValue = uiImage
        self.isShown.wrappedValue = false
        self.imagePicked.wrappedValue = true
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown.wrappedValue = false
    }

}

func makeCoordinator() -> Coordinator {
    return Coordinator(isShown: isShown, image: image, imagePicked: imagePicked)
}

func makeUIViewController(context: UIViewControllerRepresentableContext<OpenGallary>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
}

func updateUIViewController(_ uiViewController: UIImagePickerController,
                            context: UIViewControllerRepresentableContext<OpenGallary>) {

}
}
