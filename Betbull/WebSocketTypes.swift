import SwiftUI

struct EventSocketType: Codable {
	let event: String
	let startTime: Double
}

struct OutcomeSocketType: Codable {
	let outcome: String
	let price: String
}