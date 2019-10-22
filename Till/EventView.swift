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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var scale: CGSize = CGSize.init(width: 1, height: 1)
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    init(box: Event) {
        self.box = box
    }
    
    var body: some View {
        ZStack (alignment: Alignment.init(horizontal: .leading, vertical: .bottom)) {
            GeometryReader { geometry in
                if self.box!.image != nil {
                    Image(uiImage: ImageHelper().getSavedImage(named:self.box!.image!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
            
            Color.gray.opacity(0.4).cornerRadius(10).edgesIgnoringSafeArea(.all)

            VStack (alignment: .leading) {
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

