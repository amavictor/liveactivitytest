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
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cyan.opacity(0.3))
                
                VStack {
                    Text("Delivery Status")
                        .font(.headline)
                    Text(context.state.leadingTag)
                        .font(.subheadline)
                }
                .padding()
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.leadingTag)
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Active")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Delivery in progress")
                }
            } compactLeading: {
                Text("🚚")
            } compactTrailing: {
                Text(context.state.leadingTag)
            } minimal: {
                Text("🚚")
            }
        }
    }
}

extension FoodDeliveryAttributes {
    fileprivate static var preview: FoodDeliveryAttributes {
        FoodDeliveryAttributes(name: "World")
    }
}

extension FoodDeliveryAttributes.ContentState {
    fileprivate static var smiley: FoodDeliveryAttributes.ContentState {
      FoodDeliveryAttributes.ContentState(leadingTag: "😀")
     }
     
     fileprivate static var starEyes: FoodDeliveryAttributes.ContentState {
       FoodDeliveryAttributes.ContentState(leadingTag: "🤩")
     }
}

#Preview("Notification", as: .content, using: FoodDeliveryAttributes.preview) {
   FoodDeliveryLiveActivity()
} contentStates: {
  FoodDeliveryAttributes.ContentState.smiley
  FoodDeliveryAttributes.ContentState.starEyes
}
