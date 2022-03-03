//
//  TheCalendarApp.swift
//  TheCalendar
//
//  Created by Joe on 2022/2/23.
//

import SwiftUI

@main
struct TheCalendarApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .undoRedo) {}
            CommandGroup(replacing: .pasteboard) {}
            MainCommands()
        }
        
    }
}
