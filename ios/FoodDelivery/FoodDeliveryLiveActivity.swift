 //
//  FoodDeliveryLiveActivity.swift
//  FoodDelivery
//
//  Created by Victor Ama on 07/01/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FoodDeliveryLiveActivity: Widget {
    var body: some WidgetConfiguration {
      ActivityConfiguration(for: FoodDeliveryAttributes.self) { context in
          // Lock screen/banner UI
          VStack(spacing: 20) {
              HStack {
                  VStack(alignment: .leading, spacing: 5) {
                      Text("Mama Nkechi")
                          .font(.system(size: 12, weight: .regular))
                          .foregroundColor(.white)
                      
                      Text(context.attributes.totalAmount)
                          .font(.system(size: 14))
                          .foregroundColor(.white)
                  }
                  
                  Spacer()
                  
                  Image(systemName: getStatusIcon(status: context.state.deliveryStatus))
                      .font(.system(size: 24))
                      .foregroundColor(.green)
              }
              
            VStack(alignment: .center, spacing: 5) {
                  Text(progressViewText(status: context.state.deliveryStatus))
                      .font(.system(size: 12, weight: .regular))
                      .lineLimit(1)
                      .foregroundColor(.white)
                  
                  Text(context.attributes.orderDetails)
                      .font(.system(size: 18, weight: .bold))
                      .lineLimit(1)
                      .foregroundColor(.white)
              }
              
              StepsProgressView(progress: context.state.deliveryProgress)
          }
          .padding()
          .activityBackgroundTint(Color.black)
          .activitySystemActionForegroundColor(Color.black)
      } dynamicIsland: { context in
          DynamicIsland {
              // Expanded UI
              DynamicIslandExpandedRegion(.leading) {
                  VStack(alignment: .leading, spacing: 1) {
                      Text("Mama Nkechi")
                          .font(.system(size: 12, weight: .regular))
                          .foregroundColor(.secondary)
                          .padding(_:5)
                      
                      Text(context.attributes.totalAmount)
                          .font(.system(size: 14))
                          .foregroundColor(.secondary)
                          .padding(_:5)

                  }
              }
              
              DynamicIslandExpandedRegion(.trailing) {
                  VStack(alignment: .trailing, spacing: 2) {
                      Text("ETA")
                          .font(.system(size: 12))
                          .foregroundColor(.secondary)
                    Text(formatTime(context.state.remainingTime))
                      .font(.caption)
                        .monospacedDigit()
                        .foregroundColor(.white)
                      
                      // New status icon
                      Image(systemName: getStatusIcon(status: context.state.deliveryStatus))
                          .font(.system(size: 20))
                          .foregroundColor(.green)
                  }
                  .padding([.trailing], 5)
              }
            
            DynamicIslandExpandedRegion(.center) {
              VStack{
                Text(progressViewText(status:context.state.deliveryStatus))
                  .font(.system(size: 12, weight: .regular))
                    .lineLimit(1)
                    .padding([.leading], 5)
                    .foregroundColor(.gray)

                Text(context.attributes.orderDetails)
                  .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .padding([.leading], 5)
              }
             

            }
              
              DynamicIslandExpandedRegion(.bottom) {
                  VStack() {
                      StepsProgressView(progress: context.state.deliveryProgress)
                  }
                  .padding(.top, 20)
              }
          } compactLeading: {
                HStack(spacing: 4) {
                    Circle()
                        .fill(.white)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: getStatusIcon(status: context.state.deliveryStatus))
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                        )
                    Text(context.state.deliveryStatus)
                        .font(.caption2)
                        .foregroundColor(.white)
                }
            } compactTrailing: {
                Text(formatTime(context.state.remainingTime))
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundColor(.white)
            } minimal: {
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: getStatusIcon(status: context.state.deliveryStatus))
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    )
            }
        }
    }
    
    // Helper function to get status-appropriate icon
    private func getStatusIcon(status: String) -> String {
        switch status {
        case "Preparing":
            return "frying.pan"
        case "On the Way":
            return "bicycle"
        case "At the Address":
            return "location.fill"
        case "Delivered":
            return "house.fill"
        default:
            return "circle.fill"
        }
    }
}

struct StepsProgressView: View {
    let progress: Double
    private let steps = ["Preparing", "On the Way", "At the Address", "Delivered"]
    
  var body: some View {
      VStack(spacing: 4) {
          // Progress dots and lines
          HStack(spacing: 0) {
              ForEach(0..<steps.count, id: \.self) { index in
                  HStack(spacing: 0) {
                      // Dot
                      Circle()
                          .fill(progress >= Double(index) / Double(steps.count - 1) ? Color.green : Color.gray.opacity(0.3))
                          .frame(width: 8, height: 8)
                      
                      // Line
                      if index < steps.count - 1 {
                          Rectangle()
                              .fill(progress > Double(index) / Double(steps.count - 1) ? Color.green : Color.gray.opacity(0.3))
                              .frame(height: 2)
                              .frame(maxWidth: .infinity)
                      }
                  }
              }
          }
          
      }
      .padding(.horizontal, 5)
  }
}

private func progressViewText(status: String) -> String {
    switch status {
    case "Preparing":
        return "Chef is preparing your meal"
    case "On the Way":
        return "Your order is on the way"
    case "At the Address":
        return "Driver is at your address"
    case "Delivered":
        return "Enjoy your meal!"
    default:
        return "Preparing your order"
    }
}

private func getStatusColor(status: String) -> Color {
    switch status {
    case "Preparing":
        return .red
    case "On the Way":
        return .orange
    case "At the Address":
        return .blue
    case "Delivered":
        return .green
    default:
        return .primary
    }
}



// Preview provider
extension FoodDeliveryAttributes {
    fileprivate static var preview: FoodDeliveryAttributes {
        FoodDeliveryAttributes(
            orderDetails: "Ofada Rice x2",
            totalAmount: "N32,000"
        )
    }
}

extension FoodDeliveryAttributes.ContentState {
    fileprivate static var initialState: FoodDeliveryAttributes.ContentState {
        FoodDeliveryAttributes.ContentState(
            deliveryProgress: 0.0,
            deliveryStatus: "Preparing",
            remainingTime: 60.0,
            startedAt: Date()
        )
    }
    
    fileprivate static var midDelivery: FoodDeliveryAttributes.ContentState {
        FoodDeliveryAttributes.ContentState(
            deliveryProgress: 0.5,
            deliveryStatus: "On the Way",
            remainingTime: 30.0,
            startedAt: Date()
        )
    }
}

#Preview("Notification", as: .content, using: FoodDeliveryAttributes.preview) {
    FoodDeliveryLiveActivity()
} contentStates: {
    FoodDeliveryAttributes.ContentState.initialState
    FoodDeliveryAttributes.ContentState.midDelivery
}
