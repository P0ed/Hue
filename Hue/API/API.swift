import Fx
import Foundation

extension String: Error {}

struct API {

	enum Method: String {
		case get = "GET"
		case post = "POST"
	}

	let baseURL: String
	let username: String?

	func request<Response: Decodable>(method: Method, path: String? = nil, args: JSON? = nil, response: Response.Type) -> Promise<Response> {
		var url = URL(string: baseURL)!

		if let username = username {
			url.appendPathComponent(username)
		}

		if let path = path {
			if username != nil {
				url.appendPathComponent(path)
			} else {
				return Promise(error: "username is nil")
			}
		}

		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue

		if let args = args {
			request.httpBody = try! JSONEncoder().encode(args)
		}

		return URLSession.shared.dataTask(with: request).tryMap { data in
			try JSONDecoder().decode(Response.self, from: data)
		}
	}
}
