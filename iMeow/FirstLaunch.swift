//
//  FirstLaunch.swift
//  iMeow
//
//  Created by Francisco Arriagada on 05-10-20.
//

import SwiftUI



func getCatPhoto() -> Image {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    let fileURL = URL(fileURLWithPath: "catphoto", relativeTo: documentsDirectory).appendingPathExtension("png")
    if !FileManager.default.fileExists(atPath: fileURL.path){
        return Image("uploadphoto2")
    }
    else {
         let savedImage = UIImage(contentsOfFile: fileURL.path)
         let image = Image(uiImage: savedImage!)
         return image
    }
}

struct FirstLaunch: View {
    @ObservedObject var miCat = Cat()
    private let genders = ["Male","Female"]
    @State var isLinkActive = false
    @State private var showImagePicker: Bool = false
    @State private var catphoto : Image? = getCatPhoto()
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NAME")){
                    TextField("", text: $miCat.catname)
                }
                Section{
                    Picker(selection: $miCat.catgender, label:Text("Gender")){
                        ForEach(genders, id: \.self) { catgender in
                            Text(LocalizedStringKey(catgender))
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
                            .scaledToFit()
                    }
                }
               
                Button(action: {
                    self.viewRouter.currentPage="ContentView"
                }) {
                    Text("Done!")
                }
                
            }
            .padding()
            .navigationTitle("Cat's info")
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
