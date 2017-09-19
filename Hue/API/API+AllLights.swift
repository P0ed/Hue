import Fx

extension API {

	func allLights() -> Promise<[String: Light]> {
		return request(method: .get, path: "lights", response: [String: Light].self)
	}
}
