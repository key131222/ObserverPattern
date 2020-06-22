
import UIKit

class ViewController: UIViewController, ObservedProtocol {
    
    @IBOutlet weak var topBox: UIView!
    @IBOutlet weak var middleBox: UIView!
    @IBOutlet weak var bottomBox: UIView!
    
    var networkConnectionHandler0: NetworkConnectionHandler?
    var networkConnectionHandler1: NetworkConnectionHandler?
    var networkConnectionHandler2: NetworkConnectionHandler?
    
    let statusKey: StatusKey = StatusKey.networkStatusKey
    let notification: Notification.Name = .networkConnection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkConnectionHandler0 = NetworkConnectionHandler(view: topBox)
        networkConnectionHandler1 = NetworkConnectionHandler(view: middleBox)
        networkConnectionHandler2 = NetworkConnectionHandler(view: bottomBox)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        
        let swtich:UISwitch = sender as! UISwitch
        
        if swtich.isOn {
            notifyObservers(about: NetworkConnectionStatus.connected.rawValue)
        }
        else {
            notifyObservers(about: NetworkConnectionStatus.disconnected.rawValue)
        }
    }
}
