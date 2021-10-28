import SwiftUI

struct TournamentView: View {
	
	@ObservedObject var tournamentsVM: TournamentsViewModel
	@ObservedObject var socket: WebSocketController
	
	init() {
		let tournaments = TournamentsViewModel()
		tournamentsVM = tournaments
		socket = WebSocketController(tournamentsVM: tournaments)
	}
	
	var body: some View {
		
		NavigationView {
			List {
				ForEach(tournamentsVM.tournaments) { tournament in
					Text(tournament.name)
						.bold()
						.hideRowSeparator(background: Color(.systemGray5))
					
					ForEach(tournament.events) { event in
						HStack {
							Text(event.name)
							Spacer()
							Text("\(event.startTimeFormatted)")
								.font(.caption)
								.foregroundColor(.gray)
						}
							.hideRowSeparator()
							.border(width: 1, edges: [.top], color: Color(.systemGray5))
						
						ForEach(event.markets) { market in
							ForEach(market.outcomes) { outcome in
								HStack {
									Text(outcome.name)
									Spacer()
									Text(outcome.price)
								}
									.hideRowSeparator()
							}
						}
					}
				}
				if tournamentsVM.tournaments.count > 0 {
					Text("")
						.hideRowSeparator()
						.border(width: 1, edges: [.top], color: Color(.systemGray5))
				}
			}
				.navigationBarTitle("Sportsbook", displayMode: .inline)
				.environment(\.defaultMinListRowHeight, 10)
		}
			.onAppear() {
				tournamentsVM.fetchTestingData()
			}
			.alert(item: $socket.alertWrapper) { $0.alert }
	}
}
