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
  
  @objc(startActivity)
  func startActivity() {
      do {
          if #available(iOS 16.1, *) {
              let foodDeliveryAttributes = FoodDeliveryAttributes(name: "Food Delivery")
              let foodDeliveryContentState = FoodDeliveryAttributes.ContentState(leadingTag: "Leading Name")
              
              let activity = try Activity<FoodDeliveryAttributes>.request(
                  attributes: foodDeliveryAttributes,
                  content: .init(state: foodDeliveryContentState, staleDate: nil),
                  pushType: nil
              )
              
              // Add debug prints
              print("Activity started successfully!")
              print("Activity ID: \(activity.id)")
              print("Content State: \(foodDeliveryContentState.leadingTag)")
              
          } else {
              print("Dynamic Island and live activity not supported")
          }
      } catch let error {
          // More detailed error printing
          print("Failed to start activity: \(error.localizedDescription)")
          print("Error details: \(error)")
      }
  }
  
  @objc(updateActivity:)
  func updateActivity(name: String) {
      if #available(iOS 16.1, *) {
          let foodDeliveryContentState = FoodDeliveryAttributes.ContentState(leadingTag: name)
          
          Task {
              for activity in Activity<FoodDeliveryAttributes>.activities {
                  do {
                      await activity.update(ActivityContent(state: foodDeliveryContentState, staleDate: nil))
                  } catch {
                      print("Error updating activity: \(error)")
                  }
              }
          }
      } else {
          print("Live activities not supported")
      }
  }
  @objc(endActivity)
  func endActivity() {
      Task {
          for activity in Activity<FoodDeliveryAttributes>.activities {
              await activity.end(
                .init(state: activity.content.state, staleDate: nil),
                  dismissalPolicy: .immediate
              )
          }
      }
  }
  
}
