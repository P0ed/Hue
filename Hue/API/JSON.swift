enum JSON {
	case dictionary([String: JSON])
	case array([JSON])
	case string(String)
	case int(Int)
	case float(Float)
	case bool(Bool)
	case null
}

struct DynamicKeys: CodingKey {

	var stringValue: String
	var intValue: Int?

	init?(stringValue: String) {
		self.stringValue = stringValue
	}

	init?(intValue: Int) {
		return nil
	}

	static func string(_ value: String) -> DynamicKeys {
		return DynamicKeys(stringValue: value)!
	}
}

extension JSON: Encodable {

	func encode(to encoder: Encoder) throws {
		switch self {
		case .dictionary(let d):
			var c = encoder.container(keyedBy: DynamicKeys.self)
			for x in d { try c.encode(x.value, forKey: .string(x.key)) }
		case .array(let a):
			var c = encoder.unkeyedContainer()
			for x in a { try c.encode(x) }
		case .string(let s):
			var c = encoder.singleValueContainer()
			try c.encode(s)
		case .int(let i):
			var c = encoder.singleValueContainer()
			try c.encode(i)
		case .float(let f):
			var c = encoder.singleValueContainer()
			try c.encode(f)
		case .bool(let b):
			var c = encoder.singleValueContainer()
			try c.encode(b)
		case .null:
			var c = encoder.singleValueContainer()
			try c.encodeNil()
		}
	}
}
