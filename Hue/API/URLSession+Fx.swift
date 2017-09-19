import Foundation
import Fx

extension URLSession {

	func dataTask(with request: URLRequest) -> Promise<Data> {
		return Promise { resolve in
			let task = dataTask(with: request) { (data, response, error) in
				if let error = error {
					resolve(.error(error))
				} else {
					resolve(.value(data ?? Data()))
				}
			}
			task.resume()
		}
	}
}
