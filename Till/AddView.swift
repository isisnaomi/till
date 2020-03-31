//
//  AddView.swift
//  Till
//
//  Created by Isis Ramirez on 18/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name: String = ""
    @State private var date = Date()
    @State var showImagePicker: Bool = false
    @State var showUnsplashPicker: Bool = false
    @State var imagePicked: Bool = false
    @State var image: UIImage?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var currentColorScheme: ColorScheme

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var colorScheme: ColorScheme {
        if self.image != nil {
            return .dark
        } else {
            return self.currentColorScheme
        }
    }
    
    var body: some View {
        ZStack {
            //Color.yellow
            //.edgesIgnoringSafeArea(.all)
              GeometryReader { geometry in
                if self.image != nil {
                    Image(uiImage: self.image!)
                        .resizable()
                        .aspectRatio(self.image!.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: geometry.size.width,
                               maxHeight: geometry.size.height)
                    Color.black.opacity(0.4).cornerRadius(10)
                }
            }
            VStack {
                TextField("Add a title", text: $name)
                    .font(.largeTitle)
                DatePicker.init("", selection: $date , in: Date.init(timeIntervalSince1970: 0)... , displayedComponents: .date).labelsHidden()
                Button(action: {
                    withAnimation {
                        self.showImagePicker.toggle()
                    }
                }) {

                    HStack {
                        Image.init(systemName: "camera").foregroundColor(.primary)
                        Text("Add an image").foregroundColor(.primary)
                    }.padding()
                }
                Button(action: {
                    withAnimation {
                        self.showUnsplashPicker.toggle()
                    }
                }) {
                    HStack {
                        Image.init(systemName: "camera").foregroundColor(.primary)
                        Text("Add an from Unsplash").foregroundColor(.primary)
                    }.padding()
                }
                Button(action:  {
                    self.disabled(true)
                    let imageSaved = self.image != nil ? ImageHelper().saveImage(image: self.image!) : ImageHelper().saveImage(image: ImageHelper().getRandomDefaultImage())
                    let newEvent = Event.init(context: self.managedObjectContext)
                    newEvent.image = imageSaved
                    newEvent.name = self.name
                    newEvent.date = self.date
                    newEvent.id = "\(UUID())"
                    do {
                        try self.managedObjectContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }) {
                    HStack{
                        Text("Add new event").foregroundColor(.primary).colorInvert()
                    }.padding()
                    .cornerRadius(10)
                    .background(Color.primary)
                }.padding()
            }.padding()
            VStack {
                if (showImagePicker) {
                    OpenGallary(isShown: $showImagePicker, image: $image, imagePicked: $imagePicked)
                }
            }
            VStack {
                if (showUnsplashPicker) {
                    UnsplashGallary(isShown: $showUnsplashPicker, image: $image, imagePicked: $imagePicked)
                }
            }
        }.colorScheme(colorScheme)
        
    }
}

