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
        // Dynamic stateful properties about your activity go here!
        public var leadingTag: String
        
        // Add public initializer
        public init(leadingTag: String) {
            self.leadingTag = leadingTag
        }
    }

    // Fixed non-changing properties about your activity go here!
    public var name: String
    
    // Add public initializer
    public init(name: String) {
        self.name = name
    }
}
