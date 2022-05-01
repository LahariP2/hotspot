//
//  WeceHacksApp.swift
//  WeceHacks
//
//  Created by Lahari on 4/30/22.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSDataStorePlugin

@main
struct WeceHacksApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                EventsView()
                    .tabItem {
                        Label("Events", systemImage: "list.dash")
                    }
                
                TempView()
                    .tabItem {
                        Label("Starred Events", systemImage: "star")
                    }
                
                TempView()
                    .tabItem {
                        Label("Leaderboard", systemImage: "crown")
                    }
            }
            
        }
    }
    
    init() {
        configureAmplify()
    }
    
    func configureAmplify() {
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())

        do {
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: apiPlugin)
            try Amplify.configure()
            print("Initialized Amplify");
        } catch {
            print("Could not initialize Amplify: \(error)")
        }
    }
}


