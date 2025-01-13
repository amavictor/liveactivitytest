//
//  FoodDeliveryModuleHeader.m
//  delivery
//
//  Created by Victor Ama on 07/01/2025.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FoodDelivery, NSObject)

+ (bool)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(startActivity)
RCT_EXTERN_METHOD(endActivity)
RCT_EXTERN_METHOD(updateActivity:(NSString *)status
                  progress:(double)progress
                  remainingTime:(double)remainingTime)
@end
