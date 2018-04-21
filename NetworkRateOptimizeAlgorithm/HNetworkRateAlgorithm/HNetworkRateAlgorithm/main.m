//
//  main.m
//  HNetworkRateAlgorithm
//
//  Created by Rocky on 2018/4/20.
//  Copyright © 2018年 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetworkRateEntity.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int receivedDataArr[30] = {56, 114, 137, 140, 50, 30, 0, 0, 0, 50, 80, 130, 120, 90, 130, 154, 180, 160, 170, 115, 117, 118, 115, 147, 111, 90, 92, 60, 56, 30};
        
        u_int64_t totalReceivedDataSize = 0;
        
        
        // 算法1
        HNetworkRateEntity *networkRateEntity1 = [[HNetworkRateEntity alloc] init];
        
        for (int index = 0; index < 30; index++) {
            totalReceivedDataSize += receivedDataArr[index];
            
            u_int64_t dataRate = [networkRateEntity1 calculateAverageNetworkRateWithSumDataSize:totalReceivedDataSize];
            NSLog(@"smooth1 :%@", @(dataRate));
        }
        
        NSLog(@"\n******************************************\n");
        
        // 算法2
        HNetworkRateEntity *networkRateEntity2 = [[HNetworkRateEntity alloc] init];
        totalReceivedDataSize = 0;
        for (int index = 0; index < 30; index++) {
            totalReceivedDataSize += receivedDataArr[index];
            
            u_int64_t dataRate = [networkRateEntity2 calculateSquareNetworkRateWithSumDataSize:totalReceivedDataSize];
            NSLog(@"smooth2 :%@", @(dataRate));
        }
        
        NSLog(@"\n******************************************\n");
        
        // 算法3
        HNetworkRateEntity *networkRateEntity3 = [[HNetworkRateEntity alloc] init];
        totalReceivedDataSize = 0;
        for (int index = 0; index < 30; index++) {
            totalReceivedDataSize += receivedDataArr[index];
            
            u_int64_t dataRate = [networkRateEntity3 calculateThreeAverNetworkRateWithSumDataSize:totalReceivedDataSize];
            NSLog(@"smooth3 :%@", @(dataRate));
        }
        
    }
    return 0;
}
