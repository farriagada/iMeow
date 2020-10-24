//
//  ContentView.swift
//  iMeow
//
//  Created by Francisco Arriagada on 05-10-20.
//

import SwiftUI

extension UIImage {
//    This extension checks if the image saved is rotated by jpeg compression. If so, it gets corrected. 
    var upOrientationImage: UIImage {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result!
        }
    }
}

func getCatphotoURL() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    let fileURL = URL(fileURLWithPath: "catphoto", relativeTo: documentsDirectory).appendingPathExtension("png")
    return fileURL
}

func getCatPicture() -> Image {
    do{
//        Convert data into an Image
        if let savedImage = UIImage(contentsOfFile: getCatphotoURL().path){
            let fixedImage = savedImage.upOrientationImage
            let image = Image(uiImage: fixedImage)
            return image
        } else {
            print ("Error reading Image")
            let image = Image("uploadphoto2")
            return image;
        }
    }
}

func calcCatLivingDays(catbirth:Date) -> (Int, String) {
    let now = Date()
    let calendar = Calendar.current
    let dayComponents = calendar.dateComponents([.day], from: catbirth, to: now)
    let monthComponents = calendar.dateComponents([.month], from: catbirth, to: now)
    
    if dayComponents.day! < 30 {
        return (dayComponents.day!, "day")
    } else {
        return (monthComponents.month!, "month")
    }

}

func youngerThanOneYearAndAHalf(x: Double) -> Int {
    let x1:Double = 16.364
    let res = (x*x1)
    return Int(res.rounded(.down))
}

func olderThanOneYearAndAHalf(x: Double) -> Int {
    let res = (4.1364*x) + 15
    print(x)
    print(res)
    return Int(res.rounded(.down))
}

func calcCatHumanAge(years: Double) -> Int {
    print("catyears: "+String(years))
    if years < 1.5 {
        return youngerThanOneYearAndAHalf(x: years)
    } else {
        return olderThanOneYearAndAHalf(x: years)
    }
 }

func heOrShe(gender: String) -> String {
    if gender == "Male" {
        return "he"
    }
    else {
        return "she"
    }
}

struct ContentView: View {
    @ObservedObject var miCat = Cat()
    let catname = UserDefaults.standard.string(forKey: "catname")
    let catgender = UserDefaults.standard.string(forKey: "catgender")
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView{
            VStack{
            getCatPicture()
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding()
                .scaledToFit()
                .clipped()
                .navigationBarTitle(catname!)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.viewRouter.currentPage="FirstLaunch"
                                        }) {
                                            Text("Edit")
                                        }
                )
                
    
                if(catgender == "Male"){
                    Image("masculino")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 80, height: 80, alignment: .center)
                        
                } else {
                    Image("hembra")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 80, height: 80, alignment: .center)
                }
               
            
            // CAT YEARS - BOTH ANIMAL AND HUMAN.
            let tuple = calcCatLivingDays(catbirth: miCat.catbirthday)
            if tuple.1 == "day" {
                Text(catname!+" is just "+String(tuple.0)+" days old")
            }
            else {
                let years = Double(tuple.0)/Double(12)
                let humanyears = calcCatHumanAge(years:years)
                let heShe:String = heOrShe(gender: catgender!)
                if tuple.0 < 12 {
                    if tuple.0 == 1 {
                        Text(catname!)+Text(" is ")+Text(String(tuple.0))+Text(" month old")
                    } else {
                        Text(catname!)+Text(" is ")+Text(String(tuple.0))+Text(" months old")
                    }
                }
                else {
                    let y = Int(years.rounded(.down))
                    if y == 1 {
                        Text(catname!)+Text(" is a ")+Text(String(y))+Text(" year old")
                    }
                    else {
                        Text(catname!)+Text(" is ")+Text(String(y))+Text(" years old")
                    }
                    
                        
                }
                if Locale.current.languageCode == "en" {
                    Text("(And if ").fontWeight(.light)+Text(heShe).fontWeight(.light)+Text(" were human, ").fontWeight(.light)+Text(heShe).fontWeight(.light)+Text(" would be ").fontWeight(.light)+Text(String(humanyears)).fontWeight(.light)+Text(" years old)").fontWeight(.light) }
                else { // Esto va a funcionar solo en el caso de español.
                    if catgender! == "Male" {
                        Text("(And if it were male, ").fontWeight(.light)+Text("would be ").fontWeight(.light)+Text(String(humanyears)).fontWeight(.light)+Text(" years old)").fontWeight(.light)
                    }
                    else {
                        Text("(And if it were female, ").fontWeight(.light)+Text("would be ").fontWeight(.light)+Text(String(humanyears)).fontWeight(.light)+Text(" years old)").fontWeight(.light)
                    }
                    
                }
            }
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
