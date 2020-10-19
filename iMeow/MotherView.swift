//
//  MotherView.swift
//  iMeow
//
//  Created by Francisco Arriagada on 06-10-20.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack{
            if viewRouter.currentPage == "FirstLaunch" {
                FirstLaunch()
            } else if viewRouter.currentPage == "ContentView" {
                ContentView()
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
