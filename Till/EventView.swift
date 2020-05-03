//
//  EventView.swift
//  Till
//
//  Created by Isis Ramirez on 18/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import SwiftUI

struct EventView: View {
    private var box: Event?
    private var image: UIImage
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var scale: CGSize = CGSize.init(width: 1, height: 1)
    @State var showingEdit = false
    @State private var showingAlert = false

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    init(box: Event) {
        self.box = box
        debugPrint(box)
        self.image = ImageHelper().getSavedImage(named:box.image!)!
    }
    
    var body: some View {
        ZStack(alignment: Alignment.init(horizontal: .leading, vertical: .bottom)) {
            GeometryReader { geometry in
                if self.box!.image != nil {
                    Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(self.image.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: geometry.size.width,
                               maxHeight: geometry.size.height)
                        .scaleEffect(self.scale)
                        .onAppear {
                            withAnimation(Animation.easeIn(duration: 5)) {
                                self.scale = CGSize.init(width: 1.1, height: 1.1)
                        }
                    }

                }
            }
            
            Color.black.opacity(0.4).cornerRadius(10).edgesIgnoringSafeArea(.all)
               VStack (alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingEdit.toggle()
                    }) {
                        Image("iconEdit")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                    Button(action: {
                        self.showingAlert = !InstagramManager().postImageToInstagramWithCaption(imageInstagram: self.image, event: self.box!, view: UIView())
                    }) {
                        Image("iconInsta")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Ups! Look like you don't have Instagram"), message: Text("Install Instagram to enjoy this feature and share your countdowns"), dismissButton: .default(Text("Got it!")))
                    }
                    .sheet(isPresented: self.$showingEdit) {
                        EditView(box: self.box!).environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                    }
                }

                Spacer()
                if box!.calendarEventIdentifier != nil {
                    Image.init(systemName: "calendar")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20, alignment: .center)
                }
                Text("\(box!.daysUntil())")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text("\(box!.name!)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("\(box!.date!, formatter: Self.taskDateFormat)")
                    .font(.subheadline)
                    .foregroundColor(.white)
               }.padding()
        }
        
        
    }
}

