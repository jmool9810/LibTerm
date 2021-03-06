// This source file is part of the https://github.com/ColdGrub1384/Pisth open source project
//
// Copyright (c) 2017 - 2018 Adrian Labbé
// Licensed under Apache License v2.0
//
// See https://raw.githubusercontent.com/ColdGrub1384/Pisth/master/LICENSE for license information

import Foundation
import StoreKit

/// Helper used to request app review based on app launches.
class ReviewHelper {
    
    /// Request review, reset points and append current date to `reviewRequests`.
    func requestReview() {
        if launches >= minLaunches {
            launches = 0
            SKStoreReviewController.requestReview()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                if UIApplication.shared.windows.count > 1 {
                    ((UIApplication.shared.keyWindow?.rootViewController as? TerminalTabViewController)?.visibleViewController as? LTTerminalViewController)?.terminalTextView.resignFirstResponder()
                }
            })
        }
    }
    
    // MARK: - Singleton
    
    /// Shared and unique instance.
    static let shared = ReviewHelper()
    private init() {}
    
    // MARK: - Launches tracking
    
    /// App launches incremented in `AppDelegate.application(_:, didFinishLaunchingWithOptions:)`.
    ///
    /// Launches are saved to `UserDefaults`.
    var launches: Int {
        
        get {
            return UserDefaults.standard.integer(forKey: "launches")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "launches")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Minimum launches for asking for review.
    var minLaunches = 10
}
