import SwiftUI

struct Event: Codable, Identifiable {
	let id: String
	let name: String
	var startTime: Double
	var markets: [Market]
	
	var startTimeFormatted: String {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		dateFormatter.locale = NSLocale.current
		dateFormatter.dateFormat = "yyyy/MM/dd, HH:mm a"
		return dateFormatter.string(from: Date(timeIntervalSince1970: startTime))
	}
}
