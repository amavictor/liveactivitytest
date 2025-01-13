//
//  FoodDeliveryModule.swift
//  delivery
//
//  Created by Victor Ama on 07/01/2025.
//

import Foundation
import ActivityKit
import BackgroundTasks
import UIKit

@objc(FoodDelivery)
class FoodDelivery: NSObject {
    private var deliverySteps = ["Preparing", "On the Way", "At the Address", "Delivered"]
    private var startTime: Date?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var timer: Timer?
    
    override init() {
        super.init()
        registerBackgroundTask()
    }
    
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.yourapp.refresh",
            using: nil
        ) { task in
            self.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
    }
    
    private func handleBackgroundTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        self.updateLiveActivity()
        scheduleNextBackgroundTask()
        
        task.setTaskCompleted(success: true)
    }
    
    private func scheduleNextBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15) // Schedule for 15 seconds later
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
    
    private func startBackgroundExecution() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundExecution()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateLiveActivity()
        }
    }
    
    private func endBackgroundExecution() {
        timer?.invalidate()
        timer = nil
        
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    private func updateLiveActivity() {
        guard let startTime = startTime else { return }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        let progress = min(elapsedTime / 60.0, 1.0)
        let remainingTime = max(60.0 - elapsedTime, 0)
        
        let status: String
        if progress >= 0.75 {
            status = "Delivered"
        } else if progress >= 0.5 {
            status = "At the Address"
        } else if progress >= 0.25 {
            status = "On the Way"
        } else {
            status = "Preparing"
        }
        
        let state = FoodDeliveryAttributes.ContentState(
            deliveryProgress: progress,
            deliveryStatus: status,
            remainingTime: remainingTime,
            startedAt: startTime
        )
        
        Task {
            for activity in Activity<FoodDeliveryAttributes>.activities {
                await activity.update(ActivityContent(state: state, staleDate: nil))
            }
        }
    }
    
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
                
                startBackgroundExecution()
                scheduleNextBackgroundTask()
            }
        } catch {
            print("Failed to start activity: \(error)")
        }
    }
    
    @objc(endActivity)
    func endActivity() {
        startTime = nil
        endBackgroundExecution()
        
        Task {
            for activity in Activity<FoodDeliveryAttributes>.activities {
                await activity.end(.init(state: activity.content.state, staleDate: nil),
                                 dismissalPolicy: .immediate)
            }
        }
    }
    
    @objc(updateActivity:progress:remainingTime:)
    func updateActivity(_ status: String, progress: Double, remainingTime: Double) {
        // This method is now mainly for manual updates from React Native if needed
        let state = FoodDeliveryAttributes.ContentState(
            deliveryProgress: progress,
            deliveryStatus: status,
            remainingTime: remainingTime,
            startedAt: startTime ?? Date()
        )
        
        Task {
            for activity in Activity<FoodDeliveryAttributes>.activities {
                await activity.update(ActivityContent(state: state, staleDate: nil))
            }
        }
    }
}
