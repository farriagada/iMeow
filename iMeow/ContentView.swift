//
//  ContentView.swift
//  iMeow
//
//  Created by Francisco Arriagada on 05-10-20.
//

import SwiftUI

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
            let image = Image(uiImage: savedImage)
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

struct ContentView: View {
    @ObservedObject var miCat = Cat()
    let catname = UserDefaults.standard.string(forKey: "catname")
    let catgender = UserDefaults.standard.string(forKey: "catgender")
    @State private var showDetails = false
    var body: some View {

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
                
            HStack{
                Text(catname!)
                    .bold()
                    .font(.title)
                    .padding()
                if(catgender == "Male"){
                    Image("masculino")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 60, height: 60, alignment: .center)
                        
                } else {
                    Image("hembra")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 60, height: 60, alignment: .center)
                }
               
            }
            // CAT YEARS - BOTH ANIMAL AND HUMAN.
            let tuple = calcCatLivingDays(catbirth: miCat.catbirthday)
            if tuple.1 == "day" {
                Button(action: {
                    self.showDetails.toggle()
                }) {
                    if showDetails{
                        // If cat's been living less than a month.
                        Text(String(tuple.0)+" cat days")
                    } else {
                        Text("Your cat is too young to have a human age yet")
                    }
                }
               
            } else { // if cat's been living more than a month.
                let years = Double(tuple.0)/Double(12)
                let humanyears = calcCatHumanAge(years: years)
                // if less than a year show cat's months.
                if tuple.0 < 12 {
                    Button(action: {
                        self.showDetails.toggle()
                    }) {
                        if showDetails{
                            Text(String(humanyears)+" human years")
                        }
                        else {
                            Text(String(tuple.0)+" cat months")
                        }
                    }
                }
                // more than a year, show cat's years.
                else {
                    Button(action: {
                        self.showDetails.toggle()
                    }) {
                        if showDetails{
                            Text(String(humanyears)+" human years")
                        }
                        else {
                            Text(String(Int(years.rounded(.down)))+" cat years")
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
