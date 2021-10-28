import SwiftUI

class TournamentsViewModel: ObservableObject {
	
	@Published var tournaments = [Tournament]()
	
	func fetchTestingData() {
		tournaments = Bundle.main.decode("data.json")
	}
	
	func updateEvent(_ updateData: EventSocketType) {
		for (t, tournament) in tournaments.enumerated() {
			for (e, event) in tournament.events.enumerated() {
				if event.id == updateData.event && event.startTime != updateData.startTime {
					DispatchQueue.main.async {
						self.tournaments[t].events[e].startTime = updateData.startTime
					}
					return
				}
			}
		}
	}
	
	func updateOutcome(_ updateData: OutcomeSocketType) {
		for (t, tournament) in tournaments.enumerated() {
			for (e, event) in tournament.events.enumerated() {
				for (m, market) in event.markets.enumerated() {
					for (o, outcome) in market.outcomes.enumerated() {
						if outcome.id == updateData.outcome && outcome.price != updateData.price {
							DispatchQueue.main.async {
								self.tournaments[t].events[e].markets[m].outcomes[o].price = updateData.price
							}
							return
						}
					}
				}
			}
		}
	}
}
