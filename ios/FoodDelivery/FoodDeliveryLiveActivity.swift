//
//  FoodDeliveryLiveActivity.swift
//  FoodDelivery
//
//  Created by Victor Ama on 07/01/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FoodDeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FoodDeliveryLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FoodDeliveryAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
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
        FoodDeliveryAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FoodDeliveryAttributes.ContentState {
         FoodDeliveryAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FoodDeliveryAttributes.preview) {
   FoodDeliveryLiveActivity()
} contentStates: {
    FoodDeliveryAttributes.ContentState.smiley
    FoodDeliveryAttributes.ContentState.starEyes
}
