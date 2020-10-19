//
//  FirstLaunch.swift
//  iMeow
//
//  Created by Francisco Arriagada on 05-10-20.
//

import SwiftUI



struct FirstLaunch: View {
    @ObservedObject var miCat = Cat()
    @State var isLinkActive = false
    @State private var showImagePicker: Bool = false
    @State private var catphoto : Image? = Image("uploadphoto2")
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CAT NAME")){
                    TextField("", text: $miCat.catname)
                }
                Section{
                    Picker(selection: $miCat.catgender, label:Text("Gender")){
                        ForEach(miCat.genders, id: \.self) { catgender in
                            Text(catgender)
                        }
                    }
                }
                Section{
                    DatePicker("Birthday", selection: $miCat.catbirthday, displayedComponents: .date)
                }
                
                Section(header: Text("PROFILE PICTURE")){
                    Button(action: {
                        self.showImagePicker = true
                    }){
                        catphoto?
                            .resizable()
                            .scaledToFill()
                    }
                }
                
                    NavigationLink(destination: ContentView(), isActive: $isLinkActive) {
                        Button(action: {
                            self.isLinkActive = true
                        }){
                            Text("Done!")
                        }
                    }
                
            }
            .padding()
            .navigationTitle("Your Cat")
            .sheet(isPresented: self.$showImagePicker) {
                PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$catphoto)
                
                
            }
        }
    }
}

struct FirstLaunch_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunch()
    }
}
