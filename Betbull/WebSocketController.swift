import SwiftUI

struct AlertWrapper: Identifiable {
	let id = UUID()
	let alert: Alert
}

final class WebSocketController: ObservableObject {
	
	//private var id: UUID!
	private let session: URLSession
	var socketTask: URLSessionWebSocketTask!
	private let decoder = JSONDecoder()
	let webSocketURL = "ws://0.0.0.0:8080/socket"
	
	@Published var alertWrapper: AlertWrapper?
	
	var alert: Alert? {
		didSet {
			guard let a = self.alert else { return }
			DispatchQueue.main.async {
				self.alertWrapper = .init(alert: a)
			}
		}
	}
	
	@Published var tournamentsVM: TournamentsViewModel
	
	init(tournamentsVM: TournamentsViewModel) {
		self.tournamentsVM = tournamentsVM
		self.alertWrapper = nil
		self.alert = nil
		
		self.session = URLSession(configuration: .default)
		self.connect()
	}
	
	func connect() {
		socketTask = session.webSocketTask(with: URL(string: webSocketURL)!)
		listen()
		socketTask.resume()
	}
	
	func listen() {
		// 1
		self.socketTask.receive { [weak self] (result) in
			guard let self = self else { return }
			// 2
			switch result {
			case .failure(let error):
				print(error)
				// 3
				let alert = Alert(
					title: Text("Unable to connect to server!"),
					dismissButton: .default(Text("Retry")) {
						self.alert = nil
						self.socketTask.cancel(with: .goingAway, reason: nil)
						self.connect()
					}
				)
				self.alert = alert
				return
			case .success(let message):
				// 4
				switch message {
				case .string(let str):
					self.handle(str)
				@unknown default:
					break
				}
			}
			// 5
			self.listen()
		}
	}
	
	func handle(_ string: String) {
		
		print("handling \(string)")
		
		guard let data = string.data(using: .utf8) else { return }
		
		do {
			if string.contains("event") {
				let event = try decoder.decode(EventSocketType.self, from: data)
				tournamentsVM.updateEvent(event)
			} else if string.contains("outcome") {
				let outcome = try decoder.decode(OutcomeSocketType.self, from: data)
				tournamentsVM.updateOutcome(outcome)
			}
		} catch {
			print(error)
		}
	}
	
	deinit {
		socketTask.cancel(with: .normalClosure, reason: nil)
	}
}
