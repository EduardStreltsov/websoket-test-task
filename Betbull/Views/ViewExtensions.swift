import SwiftUI

struct HideRowSeparatorModifier: ViewModifier {
	static let defaultListRowHeight: CGFloat = 30
	var insets: EdgeInsets
	var background: Color
	
	init(insets: EdgeInsets, background: Color) {
		self.insets = insets
		var alpha: CGFloat = 0
		UIColor(background).getWhite(nil, alpha: &alpha)
		assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
		self.background = background
	}
	
	func body(content: Content) -> some View {
		content
			.padding(insets)
			.frame(
				minWidth: 0, maxWidth: .infinity,
				minHeight: Self.defaultListRowHeight,
				alignment: .leading
			)
			.listRowInsets(EdgeInsets())
			.background(background)
	}
}

struct EdgeBorder: Shape {
	
	var width: CGFloat
	var edges: [Edge]
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		for edge in edges {
			var x: CGFloat {
				switch edge {
				case .top, .bottom, .leading: return rect.minX
				case .trailing: return rect.maxX - width
				}
			}
			
			var y: CGFloat {
				switch edge {
				case .top, .leading, .trailing: return rect.minY
				case .bottom: return rect.maxY - width
				}
			}
			
			var w: CGFloat {
				switch edge {
				case .top, .bottom: return rect.width
				case .leading, .trailing: return self.width
				}
			}
			
			var h: CGFloat {
				switch edge {
				case .top, .bottom: return self.width
				case .leading, .trailing: return rect.height
				}
			}
			path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
		}
		return path
	}
}

extension EdgeInsets {
	static let defaultListRowInsets = Self(top: 0, leading: 10, bottom: 0, trailing: 10)
}

extension View {
	func hideRowSeparator(insets: EdgeInsets = .defaultListRowInsets, background: Color = .white) -> some View {
		modifier(HideRowSeparatorModifier(insets: insets, background: background))
	}
	
	func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
		overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
	}
}