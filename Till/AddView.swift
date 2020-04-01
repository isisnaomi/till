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
    @State var showDatePicker: Bool = false
    @State var showHourPicker: Bool = false
    @State var showUnsplashPicker: Bool = false
    @State var imagePicked: Bool = false
    @State var image: UIImage?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var currentColorScheme: ColorScheme
    @State private var createEventCalendar = true
    @State private var isAllDay = true
    @State var dateText: String = ""

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
                    //Title
                    TextField("Add a title", text: $name)
                        .font(.largeTitle)
                    //Toggles
                    Toggle(isOn: $isAllDay) {
                        Text("All day")
                    }
                    //Pickers
                    Button(action: {
                        withAnimation {
                            self.showDatePicker.toggle()
                            self.showHourPicker = false
                        }
                    }) {
                        HStack {
                            Text("Date").bold()
                            Spacer()
                            Text("\(date, formatter: dateFormatter)")
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
                                Text("Time").bold()
                                Spacer()
                                Text("\(date, formatter: hourFormatter)")
                            }.padding()
                        }
                    }
                    if showHourPicker {
                        DatePicker.init("", selection: $date , in: Date.init(timeIntervalSince1970: 0)... , displayedComponents: .hourAndMinute).labelsHidden()
                    }
                    
                    Toggle(isOn: $createEventCalendar) {
                        Text("Add event to iCal")
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
                        self.disabled(true)
                        let imageSaved = self.image != nil ? ImageHelper().saveImage(image: self.image!) : ImageHelper().saveImage(image: ImageHelper().getRandomDefaultImage())
                        let newEvent = Event.init(context: self.managedObjectContext)
                        newEvent.image = imageSaved
                        newEvent.name = self.name
                        newEvent.date = self.date
                        newEvent.id = "\(UUID())"
                        CalendarManager().addEventToCalendar(title: self.name, description: nil, startDate: self.date, endDate: self.date, location: "Till") { (identifier, error) in
                            if error == nil {
                                newEvent.calendarEventIdentifier = identifier
                            }
                        }
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
                    }
                }
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

