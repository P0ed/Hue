enum HueResult<A: Decodable>: Decodable {
	case value(A)
	case error(Error)

	private enum CodingKeys: String, CodingKey {
		case success
		case error
	}

	struct HueSuccess: Decodable {}

	struct HueError: Decodable, Error {
		let type: Int
		let address: String
		let description: String
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		if let value = try container.decodeIfPresent(A.self, forKey: .success) {
			self = .value(value)
		}
		else if let error = try container.decodeIfPresent(HueError.self, forKey: .error) {
			self = .error(error)
		}
		else {
			self = .error("Unknown error")
		}
	}

	func unwrap() throws -> A {
		switch self {
		case .value(let v): return v
		case .error(let e): throw e
		}
	}
}
