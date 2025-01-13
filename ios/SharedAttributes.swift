  //
  //  SharedAttributes.swift
  //  delivery
  //
  //  Created by Victor Ama on 08/01/2025.
  //

  import Foundation
  import ActivityKit

public struct FoodDeliveryAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
          public var deliveryProgress: Double
          public var deliveryStatus: String
          public var remainingTime: TimeInterval
          public var startedAt: Date
          
          public init(
              deliveryProgress: Double = 0.0,
              deliveryStatus: String = "Preparing",
              remainingTime: TimeInterval = 60.0,
              startedAt: Date = Date()
          ) {
              self.deliveryProgress = deliveryProgress
              self.deliveryStatus = deliveryStatus
              self.remainingTime = remainingTime
              self.startedAt = startedAt
          }
      }
      
      public var orderDetails: String
      public var totalAmount: String
      
  public init(orderDetails: String, totalAmount: String) {
          self.orderDetails = orderDetails
          self.totalAmount = totalAmount
      }
}


public func formatTime(_ timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%d:%02d", minutes, seconds)
}
