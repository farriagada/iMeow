//
//  ImagePicker.swift
//  iMeow
//
//  Created by Francisco Arriagada on 08-10-20.
//

import Foundation
import SwiftUI



class ImagePickerCoordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @Binding var isShown    : Bool
    @Binding var image      : Image?
    
    init(isShown : Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image   = image
    }
//    Get Documents Directory URL
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       
        image = Image(uiImage: uiImage)
        let dirURL = getDocumentsDirectory()
        let catphotoURL = URL(fileURLWithPath: "catphoto", relativeTo: dirURL).appendingPathExtension("png")
        if let data = uiImage.jpegData(compressionQuality: 1)
        {
            do {
                try data.write(to: catphotoURL)
            } catch {
                print("Error in trying to save photo")
            }
        }
        isShown = false
    }
    
    //Image selection got cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown    : Bool
    @Binding var image      : Image?
       
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
           
    }
    
    func makeCoordinator() -> ImagePickerCoordinator{
        //Make Coordinator which will commnicate with the    ImagePickerViewController
        return ImagePickerCoordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
}
