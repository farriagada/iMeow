//
//  ViewRouter.swift
//  iMeow
//
//  Created by Francisco Arriagada on 06-10-20.
//

import Foundation

class ViewRouter: ObservableObject {
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "FirstLaunch"
        } else {
            currentPage = "ContentView"
        }
    }
    
    @Published var currentPage: String
}
