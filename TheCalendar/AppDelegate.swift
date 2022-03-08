//
//  AppDelegate.swift
//  TheCalendar
//
//  Created by Joe on 2022/3/2.
//

import Foundation
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let statusBar = NSStatusBar.system
        
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = self.calendarDateDesc()
        statusBarItem.button?.action = #selector(bringAppForeActivation)
        statusBarItem.button?.target = self
    }
    
    @objc
    func calendarDateDesc() -> String {
        return Date().string("M月d日")!
    }
    
    @objc
    func bringAppForeActivation() {
        // 检查窗口是否已最小化。若已最小化，则设定恢复窗口
        let window = NSApplication.shared.orderedWindows[0]
        deminiaturizeWin(window)
        
        // App 设定为激活状态
        if (NSApplication.shared.isActive == false) {
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
        
        // TODO: step3: 多个屏时，虽然可以恢复窗口。但左上角三个系统按键仍然为灰色。需要修正
    }
    
    func deminiaturizeWin(_ window: NSWindow) {
        if (window.isMiniaturizable == true) {
            if (window.isMiniaturized == true) {
                window.deminiaturize(nil)
            }
        }
    }
    
}
