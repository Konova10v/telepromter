//
//  PaywallView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 05.08.2025.
//

import SwiftUI
import RevenueCat

struct Plan: Identifiable {
	let id = UUID()
	let title: String
	let subtitle: String
	let price: String
	let type: TypeSubscribe
}

enum TypeSubscribe {
	case week
	case year
}

struct PaywallView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	
	let plans = [
		Plan(title: "FLEXIBLE", subtitle: "Weekly Plan", price: "$9.99", type: .week),
		Plan(title: "POPULAR", subtitle: "Yearly Plan", price: "$44.99", type: .year)
	]
	
	@State var typeSubscribe: TypeSubscribe = .week
	@State private var weeklyPackage: Package?
	@State private var yearPackage: Package?
	@State private var error: String?
	
	@State private var selectedPlanIndex = 0
	
    var body: some View {
		VStack {
			VStack(spacing: 20) {
				HStack(alignment: .top) {
					Spacer()
					
					Image(.logoPaywall)
						.padding(.top)
						.padding(.leading, 60)
					
					Spacer()
					
					Button {
						viewModel.showPaywall.toggle()
					} label: {
						Image(.closeButton)
					}
					.padding(.trailing, 20)

				}
				
				Image(.starRating)
				
				Text("#1 Top Choice")
					.font(.system(size: 14, weight: .light, design: .default))
					.foregroundStyle(.white)
				
				Text("Record Professional Videos")
					.font(.h3)
					.foregroundStyle(.white)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
				
				Text("Create flawless scripts, auto-scroll like magic, and stay focused on your delivery — we handle the rest.")
					.font(.system(size: 18, weight: .regular, design: .default))
					.foregroundStyle(.white)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 20)
				
			}
			
			Spacer()
			
			VStack(spacing: 20) {
				HStack(alignment: .bottom, spacing: 16) {
					ForEach(plans.indices, id: \.self) { index in
						let isSelected = selectedPlanIndex == index
						VStack(alignment: .leading, spacing: 8) {
							Text(plans[index].title.uppercased())
								.font(.pretitle)
								.foregroundColor(isSelected ? .primaryOrange : .white)
							
							Text(plans[index].subtitle)
								.font(.labelSmall)
								.foregroundColor(.white)
							
							Text(plans[index].price)
								.font(.h4)
								.foregroundColor(.white)
						}
						.padding()
						.frame(maxWidth: .infinity,
							   minHeight: isSelected ? 160 : 120, alignment: .leading)
						.background(
							RoundedRectangle(cornerRadius: 16)
								.fill(isSelected ? Color.primaryOrange.opacity(0.15) : Color.white.opacity(0.05))
						)
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(isSelected ? Color.primaryOrange : Color.clear, lineWidth: 2)
						)
						.animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
						.onTapGesture {
							selectedPlanIndex = index
							
							typeSubscribe = plans[index].type
						}
					}
				}
				.padding(.horizontal, 10)
				
				HStack {
					Button {
						if let url = URL(string: "https://sites.google.com/view/tlprmptr/terms-of-use") {
							UIApplication.shared.open(url)
						}
					} label: {
						Text("Terms of Use")
							.font(.labelSmall)
							.foregroundColor(.neutralGrey)
					}
					
					Spacer()
					
					Button {
						if let url = URL(string: "https://sites.google.com/view/tlprmptr/support") {
							UIApplication.shared.open(url)
						}
					} label: {
						Text("Restore")
							.font(.labelSmall)
							.foregroundColor(.neutralGrey)
					}
					
					Spacer()
					
					Button {
						if let url = URL(string: "https://sites.google.com/view/tlprmptr/privacy-policy") {
							UIApplication.shared.open(url)
						}
					} label: {
						Text("Privacy Policy")
							.font(.labelSmall)
							.foregroundColor(.neutralGrey)
					}
				}
				.padding(.horizontal, 10)
				
				ZStack {
					Image(.buttonContainer)
						.resizable()
						.frame(width: SizeScreen().width, height: 90)
					
					Button(action: {
						purchaseSelectedProduct()
					}) {
						HStack {
							Spacer()
							
							Text("Subscribe")
								.font(.bodyMedium)
								.bold()
								.foregroundColor(.white)
							
							Spacer()
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(
							LinearGradient(
								gradient: Gradient(colors: [
									Color(red: 1, green: 0.39, blue: 0.22),
									Color.primaryOrange
								]),
								startPoint: .leading,
								endPoint: .trailing
							)
						)
						.clipShape(RoundedRectangle(cornerRadius: 16))
						.shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 3)
						.cornerRadius(16)
						.padding(.horizontal, 30)
					}
				}
			}
			.padding(.top, 40)
			.background(
				Image(.darkBkg)
					.resizable()
					.frame(width: SizeScreen().width)
					.clipShape(RoundedCorner(radius: 35, corners: [.topLeft, .topRight]))
					.ignoresSafeArea(edges: .bottom)
			)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.orangeBkg)
				.resizable()
				.ignoresSafeArea(edges: .top)
		)
    }
	
	func purchaseSelectedProduct() {
		Task {
			do {
				let offerings = try await Purchases.shared.offerings()
				guard let offering = offerings.current else {
					print("⚠️ No current offering found")
					return
				}

				var package: Package?

				switch typeSubscribe {
				case .week:
					package = offering.availablePackages.first { $0.storeProduct.productIdentifier == "tlprmptr_week_premium" }
				case .year:
					package = offering.availablePackages.first { $0.storeProduct.productIdentifier == "tlprmptr_annual_premium" }
				default:
					break
				}

				guard let selectedPackage = package else {
					print("⚠️ Package not found for selected type")
					offering.availablePackages.forEach {
						print("🧾 \($0.storeProduct.productIdentifier)")
					}
					return
				}

				let result = try await Purchases.shared.purchase(package: selectedPackage)

				// Проверка на подписку
				if result.customerInfo.entitlements["pro"]?.isActive == true {
					viewModel.showPaywall = false
				}

			} catch {
				print("❌ Purchase failed: \(error.localizedDescription)")
			}
		}
	}

	
	private func loadOfferings() {
		Purchases.shared.getOfferings { offerings, error in
			DispatchQueue.main.async {
				if error != nil {
					
				} else if let offering = offerings?.current {
					weeklyPackage = offering.package(identifier: "$rc_weekly")
					yearPackage = offering.package(identifier: "$rc_annual")
				} else {
					self.error = "Не найден текущий offering"
				}
			}
		}
	}
}

#Preview {
    PaywallView()
		.environmentObject(TelepromterViewModel())
}


import SwiftUI

struct RoundedCorner: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius)
		)
		return Path(path.cgPath)
	}
}

extension View {
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape( RoundedCorner(radius: radius, corners: corners) )
	}
}
