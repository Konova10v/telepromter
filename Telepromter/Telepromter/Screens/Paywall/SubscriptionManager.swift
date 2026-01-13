//
//  SubscriptionManager.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 25.08.2025.
//

import Foundation
import RevenueCat
import UIKit

final class SubscriptionManager: NSObject, ObservableObject, PurchasesDelegate {
	@Published var isSubscribed: Bool = false
	@Published var hasSingleGeneration: Bool = false

	private let entitlementID = "pro"
	private let singleGenerationKey = "hasSingleGeneration"

	override init() {
		super.init()
		Purchases.shared.delegate = self
		self.hasSingleGeneration = UserDefaults.standard.bool(forKey: singleGenerationKey)

		Task {
			await checkSubscriptionStatus()
		}

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(appDidBecomeActive),
			name: UIApplication.willEnterForegroundNotification,
			object: nil
		)
	}

	@objc private func appDidBecomeActive() {
		Task {
			await checkSubscriptionStatus()
		}
	}

	func checkSubscriptionStatus() async {
		do {
			let customerInfo = try await Purchases.shared.customerInfo()
			let active = customerInfo.entitlements[entitlementID]?.isActive == true
			DispatchQueue.main.async {
				self.isSubscribed = active
			}
		} catch {
			print("❌ Ошибка при проверке подписки: \(error)")
		}
	}

	func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
		let active = customerInfo.entitlements[entitlementID]?.isActive == true
		DispatchQueue.main.async {
			self.isSubscribed = active
		}
	}

	func setSingleGenerationPurchased() {
		UserDefaults.standard.set(true, forKey: singleGenerationKey)
		DispatchQueue.main.async {
			self.hasSingleGeneration = true
		}
	}

	func consumeSingleGeneration() {
		UserDefaults.standard.set(false, forKey: singleGenerationKey)
		DispatchQueue.main.async {
			self.hasSingleGeneration = false
		}
	}
}
