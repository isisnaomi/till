//
//  EditView.swift
//  Till
//
//  Created by Isis Ramirez on 21/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import SwiftUI

struct EditView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var id: String
    @State private var name: String
    @State private var date: Date
    @State var showImagePicker: Bool = false
    @State var showUnsplashPicker: Bool = false
    @State var showDatePicker: Bool = false
    @State var showHourPicker: Bool = false
    @State var image: UIImage?
    @State var imagePicked: Bool = false
    @State private var isAllDay = true
    @State private var calendarEventIdentifier: String?
    private var box: Event?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var currentColorScheme: ColorScheme

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    init(box: Event) {
        self.box = box
        _id = State(initialValue: box.id!)
        _name = State(initialValue: box.name!)
        _date = State(initialValue: box.date!)
        _image = State(initialValue: ImageHelper().getSavedImage(named: box.image!))
        _isAllDay = State(initialValue: Bool(box.isAllDay))
        _calendarEventIdentifier = State(initialValue: box.calendarEventIdentifier)
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
                //Toggles
                Toggle(isOn: $isAllDay) {
                    Text("All day")
                }.padding()
                //Pickers
                Button(action: {
                    withAnimation {
                        self.showDatePicker.toggle()
                        self.showHourPicker = false
                    }
                }) {
                    HStack {
                        Text("Date").bold().foregroundColor(.primary)
                        Spacer()
                        Text("\(date, formatter: dateFormatter)").foregroundColor(.primary)
                    }.padding()
                }
                if showDatePicker {
                        DatePicker.init("", selection: $date , in: Date.init(timeIntervalSince1970: 0)... , displayedComponents: .date).labelsHidden()
                    }
                if !isAllDay {
                    Button(action: {
                        withAnimation {
                            self.showHourPicker.toggle()
                            self.showDatePicker = false
                        }
                    }) {
                        HStack {
                            Text("Time").bold().foregroundColor(.primary)
                            Spacer()
                            Text("\(date, formatter: hourFormatter)").foregroundColor(.primary)
                        }.padding()
                    }
                }
                
                if showHourPicker {
                    DatePicker.init("", selection: $date , in: Date.init(timeIntervalSince1970: 0)... , displayedComponents: .hourAndMinute).labelsHidden()
                }
                
                //Add Image
                Button(action: {
                    withAnimation {
                        self.showImagePicker.toggle()
                    }
                }) {
                    HStack {
                        Image.init(systemName: "camera").foregroundColor(.primary)
                        Text("Add an image").foregroundColor(.primary)
                    }
                }
                Button(action: {
                    withAnimation {
                        self.showUnsplashPicker.toggle()
                    }
                }) {
                    HStack {
                        Image.init(systemName: "camera").foregroundColor(.primary)
                        Text("Add image from Unsplash").foregroundColor(.primary)
                    }
                }
                //Submit
                Button(action:  {
                    self.managedObjectContext.performAndWait {
                        if self.imagePicked {
                            let imageSaved = self.image != nil ? ImageHelper().saveImage(image: self.image!) : ImageHelper().saveImage(image: ImageHelper().getRandomDefaultImage())
                             self.box!.image = imageSaved
                        }
                        self.box!.name = self.name
                        self.box!.date = self.date
                        self.box!.isAllDay = self.isAllDay ? 1 : 0
                        //edit calendar event if exists according to new date
                        CalendarManager().updateCalendarEvent(event: self.box!) { (identifier, error) in
                            do {
                                try self.managedObjectContext.save()
                                 self.presentationMode.wrappedValue.dismiss()
                                } catch {
                                 print(error)
                            }
                        }
                    }
                }) {
                    HStack{
                        Text("Save event").foregroundColor(.primary).colorInvert()
                    }.padding()
                    .background(Color.primary)
                    .cornerRadius(30)
                    
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

