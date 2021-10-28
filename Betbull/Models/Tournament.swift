import SwiftUI

struct Tournament: Codable, Identifiable {
	let id: String
	var name: String
	let icon: String
	var events: [Event]
}
