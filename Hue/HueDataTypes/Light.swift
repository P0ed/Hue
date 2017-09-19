import Fx

struct Light: Decodable {

	struct XY: Decodable {
		let x: Float
		let y: Float
	}

	struct State: Decodable {
		let on: Bool
		let bri: Int
		let hue: Int
		let sat: Int
		let xy: XY
		let ct: Int
		let colormode: String
		let reachable: Bool
	}

	let state: State
	let type: String
	let name: String
	let modelid: String
}

extension Light.XY {

	init(from decoder: Decoder) throws {
		var c = try decoder.unkeyedContainer()
		x = try c.decode(Float.self)
		y = try c.decode(Float.self)
	}
}
