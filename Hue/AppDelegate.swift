import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	let api = API(baseURL: "http://192.168.1.2/api", username: "QgsXlbOGrAPcK-wJjpRtFCLMBlmo8K7XXmEl26WU")

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		api.allLights().onComplete { (r) in
			print(r)
		}
	}
}
