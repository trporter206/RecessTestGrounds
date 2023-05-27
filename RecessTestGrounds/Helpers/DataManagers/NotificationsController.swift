//
//  NotificationsController.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-26.
//

import Foundation
import FirebaseMessaging
import UserNotifications
import UIKit

class NotificationsController: UIResponder, MessagingDelegate, UNUserNotificationCenterDelegate, UIApplicationDelegate, ObservableObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                print("Error: \(error)")
            } else if success {
                print("Authorization successful")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        self.resetBadgeNumber()
        return true
    }
    
    func resetBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().delegate = self
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
        }
    }
}

