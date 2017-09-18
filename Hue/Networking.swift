import Foundation

typealias Sink<A> = (A) -> ()

extension String: Error {}

enum Response<A: Decodable>: Decodable {
	case value(A)
	case error(Error)

	private enum CodingKeys: String, CodingKey {
		case success
		case error
	}

	struct HUEError: Decodable, Error {
		let type: Int
		let address: String
		let description: String
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		if let value = try? container.decode(A.self, forKey: .success) {
			self = .value(value)
		}
		else if let error = try? container.decode(HUEError.self, forKey: .error) {
			self = .error(error)
		}
		else {
			self = .error("Unknown error")
		}
	}
}

struct Networking {

	enum Method: String {
		case get = "GET"
		case post = "POST"
	}

	let baseURL: String

	func request<A: Encodable, B>(method: Method, path: String, args: A, handler: @escaping Sink<Response<B>>) {
		let url = URL(string: baseURL)!.appendingPathComponent(path)
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.httpBody = try! JSONEncoder().encode(args)

		let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
			if let data = data {
				do {
					let response = try JSONDecoder().decode([Response<B>].self, from: data)
					handler(response[0])
				} catch {
					handler(.error(error))
				}
			}
			else if let error = error {
				handler(.error(error))
			}
			else {
				handler(.error("Error"))
			}
		}
		task.resume()
	}
}
