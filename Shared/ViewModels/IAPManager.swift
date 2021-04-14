//
//  IAPManager.swift
//  yournal
//
//  Created by Patrick Johnson on 4/13/21.
//

import Purchases
import SwiftUI

class IAPManager: ObservableObject {
    static let shared = IAPManager()

    @Published var packages: [Purchases.Package] = []
    @Published var inPaymentProgress = false
    @Published var purchasedItemCounter = 0
    @Published var purchasedItem = false
    init() {
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "bFWQKQooZtMuYyHTPBZkErVOIwItRejt")
        Purchases.shared.offerings { (offerings, _) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
            }
        }
    }

    func purchase(product: Purchases.Package) {
        guard !inPaymentProgress else { return }
        inPaymentProgress = true
        Purchases.shared.purchasePackage(product) { (_, purchaserInfo, _, userCancelled) in
            self.inPaymentProgress = false
            print(userCancelled)
            if !userCancelled {
                print("PURCHASED ITEM!!!")
                self.purchasedItem = true
                self.purchasedItemCounter = self.purchasedItemCounter + 1
            }
        }
    }
}
