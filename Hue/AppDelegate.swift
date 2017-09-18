import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	let net = Networking(baseURL: "http://192.168.1.2/")

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		net.request(method: .post, path: "api", args: ["devicetype": "huebeats#mbp"]) { (response: Response<[String: String]>) in

		}
	}
}
