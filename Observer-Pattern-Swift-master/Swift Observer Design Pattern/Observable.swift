

import Foundation
import UIKit

extension Notification.Name {
    
    static let networkConnection = Notification.Name("networkConnection")
    static let batteryStatus = Notification.Name("batteryStatus")
    static let locationChange = Notification.Name("locationChange")
}

enum NetworkConnectionStatus: String {
    
    case connected
    case disconnected
    case connecting
    case disconnecting
    case error
    
}

enum StatusKey: String {
    case networkStatusKey
}

protocol ObserverProtocol {
    
    var statusValue: String { get set }
    var statusKey: String { get }
    var notificationOfInterest: Notification.Name { get }
    func subscribe()
    func unsubscribe()
    func handleNotification()
    
}

class Observer: ObserverProtocol {
    
    var statusValue: String
    
    let statusKey: String
    
    let notificationOfInterest: Notification.Name
    
    init(statusKey: StatusKey, notification: Notification.Name) {
        
        self.statusValue = "N/A"
        self.statusKey = statusKey.rawValue
        self.notificationOfInterest = notification
        
        subscribe()
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: notificationOfInterest, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: notificationOfInterest, object: nil)
    }
    
    @objc func receiveNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo, let status = userInfo[statusKey] as? String {
            
            statusValue = status
            handleNotification()
            
            print("Notification \(notification.name) received; status: \(status)")
        }
    }
    
    func handleNotification() {
        fatalError("ERROR: You must override the [handleNotification] method.")
    }
    deinit {
        print("Observer unsubscribing from notifications.")
        unsubscribe()
    }
}

class NetworkConnectionHandler: Observer {
    
    var view: UIView
    
    init(view: UIView) {
        
        self.view = view
        
        super.init(statusKey: .networkStatusKey, notification: .networkConnection)
    }
    
    override func handleNotification() {
        
        if statusValue == NetworkConnectionStatus.connected.rawValue {
            view.backgroundColor = UIColor.green
        }
        else {
            view.backgroundColor = UIColor.red
        }
    }
}


protocol ObservedProtocol {
    var statusKey: StatusKey { get }
    var notification: Notification.Name { get }
    func notifyObservers(about changeTo: String) -> Void
}

extension ObservedProtocol {
    func notifyObservers(about changeTo: String) -> Void {
        NotificationCenter.default.post(name: notification, object: self, userInfo: [statusKey.rawValue : changeTo])
    }
}
