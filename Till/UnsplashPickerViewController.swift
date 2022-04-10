//
//  UnsplashPickerViewController.swift
//  Till
//
//  Created by Isis Ramirez on 22/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import SwiftUI
import UnsplashPhotoPicker

struct  UnsplashGallary: UIViewControllerRepresentable {
    
    let isShown: Binding<Bool>
    let image: Binding<UIImage?>
    let imagePicked: Binding<Bool>
    private static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")

    class Coordinator: NSObject, UINavigationControllerDelegate, UnsplashPhotoPickerDelegate {
        let isShown: Binding<Bool>
        let image: Binding<UIImage?>
        let imagePicked: Binding<Bool>
        private var imageDataTask: URLSessionDataTask?

        init(isShown: Binding<Bool>, image: Binding<UIImage?>, imagePicked: Binding<Bool>) {
            self.isShown = isShown
            self.image = image
            self.imagePicked = imagePicked
        }
        
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            downloadPhoto(photos.first!) { (success) in
                self.imagePicked.wrappedValue = true
                self.isShown.wrappedValue = false
            }
        }
        
        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
            isShown.wrappedValue = false
        }
        
        
        func downloadPhoto(_ photo: UnsplashPhoto,  completion: @escaping (Bool) -> Void)  {
            guard let url = photo.urls[.full] else {
                completion(false)
                return
            }

            if let cachedResponse = UnsplashGallary.self.cache.cachedResponse(for: URLRequest(url: url)),
                let image = UIImage(data: cachedResponse.data) {
                self.image.wrappedValue = image
                completion(true)
                return
            }

            imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
                guard let strongSelf = self else {
                    completion(false)
                    return
                }

                strongSelf.imageDataTask = nil

                guard let data = data, let image = UIImage(data: data), error == nil else {
                    completion(false)
                    return
                }
                self!.image.wrappedValue = image
                completion(true)
            }

            imageDataTask?.resume()
        }

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: isShown, image: image, imagePicked: imagePicked)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<UnsplashGallary>) -> UnsplashPhotoPicker {
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "b0ebbd21418f55e55ec0aca39509d7b9451baa3c3d9364e0bcada33884e42f01",
            secretKey: "a6626cd893b43bc1d856314acee4e1a6901fd18de2b10a22998525dd6e59d066",
            query: "",
            allowsMultipleSelection: false
        )
        let picker = UnsplashPhotoPicker(configuration: configuration)
        picker.photoPickerDelegate = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UnsplashPhotoPicker,
                                context: UIViewControllerRepresentableContext<UnsplashGallary>) {        
    }
}

