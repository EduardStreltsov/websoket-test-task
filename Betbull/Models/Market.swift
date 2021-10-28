import SwiftUI

struct Market: Codable, Identifiable {
	let id: String
	let name: String
	var outcomes: [Outcome]
}
