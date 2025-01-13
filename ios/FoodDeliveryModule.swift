//
//  FoodDeliveryModule.swift
//  delivery
//
//  Created by Victor Ama on 07/01/2025.
//

import Foundation
import ActivityKit

@objc(FoodDelivery)
class FoodDelivery: NSObject {
    private var deliverySteps = ["Preparing", "On the Way", "At the Address", "Delivered"]
    private var startTime: Date?
    
    @objc(startActivity)
    func startActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        do {
            if #available(iOS 16.1, *) {
                startTime = Date()
                
                let attributes = FoodDeliveryAttributes(
                    orderDetails: "Ofada Rice x2",
                    totalAmount: "N32,000"
                )
                
                let initialState = FoodDeliveryAttributes.ContentState(
                    deliveryProgress: 0.0,
                    deliveryStatus: "Preparing",
                    remainingTime: 60.0,
                    startedAt: startTime ?? Date()
                )
                
                let _ = try Activity<FoodDeliveryAttributes>.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil)
                )
            }
        } catch {
            print("Failed to start activity: \(error)")
        }
    }
    
  @objc(updateActivity:progress:remainingTime:)
  func updateActivity(_ status: String, progress: Double, remainingTime: Double) {
      let elapsedTime = Date().timeIntervalSince(startTime ?? Date())
      let adjustedRemainingTime = max(60.0 - elapsedTime, 0)
      
      let state = FoodDeliveryAttributes.ContentState(
          deliveryProgress: progress,
          deliveryStatus: status,
          remainingTime: adjustedRemainingTime,
          startedAt: startTime ?? Date()
      )
      
      Task {
          for activity in Activity<FoodDeliveryAttributes>.activities {
              await activity.update(ActivityContent(state: state, staleDate: nil))
          }
      }
  }
    @objc(endActivity)
    func endActivity() {
        startTime = nil
        
        Task {
            for activity in Activity<FoodDeliveryAttributes>.activities {
                await activity.end(.init(state: activity.content.state, staleDate: nil),
                                 dismissalPolicy: .immediate)
            }
        }
    }
}
