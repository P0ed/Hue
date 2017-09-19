import Fx

extension API {

	struct CreateUserResponse: Decodable {
		let username: String
	}

	func createUser() -> Promise<CreateUserResponse> {
		let r = request(
			method: .post,
			args: .dictionary(["devicetype": .string("huebeats#mbp")]),
			response: [HueResult<CreateUserResponse>].self
		)

		return r.tryMap { x in
			guard x.count == 1 else { throw "Unkown response" }
			return try x[0].unwrap()
		}
	}
}
