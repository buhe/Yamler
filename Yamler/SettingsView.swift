//
//  SettingsView.swift
//  Yamler
//
//  Created by 顾艳华 on 2023/1/28.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
            Form{
                Section(){
                    Button{
                        #if os(iOS)
                        if let url = URL(string: "https://github.com/buhe/Yamler/blob/main/Support.md") {
                            UIApplication.shared.open(url)
                        }
                        #endif
                    } label: {
                        
                        Text("Feedback")
                        
                    }.buttonStyle(PlainButtonStyle())
                    Button{
                        requestReview()
                    } label: {
                        
                        Text("Rate")
                        
                    }.buttonStyle(PlainButtonStyle())
                    HStack{
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.releaseVersionNumber!)
                    }
                    HStack{
                        Text("License")
                        Spacer()
                        Text("GPLv3")
                    }
                
                
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
