//
//  Cat.swift
//  iMeow
//
//  Created by Francisco Arriagada on 05-10-20.
//

import Foundation
import Combine

class Cat: ObservableObject {
    @Published var catname: String {
        didSet{
            UserDefaults.standard.set(catname, forKey: "catname")
        }
    }
    
    @Published var catgender: String {
        didSet{
            UserDefaults.standard.set(catgender, forKey: "catgender")
        }
    }
    
    @Published var catbirthday: Date{
        didSet{
            UserDefaults.standard.set(catbirthday, forKey: "catbirthday")
        }
    }
    
    
    init(){
        self.catname = UserDefaults.standard.object(forKey: "catname") as? String ?? ""
        self.catgender = UserDefaults.standard.object(forKey: "catgender") as? String ?? ""
        self.catbirthday = UserDefaults.standard.object(forKey: "catbirthday") as? Date ?? Date()
    }
    
}
