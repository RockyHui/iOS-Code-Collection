//
//  HNetworkRateEntity.h
//  HNetworkRateAlgorithm
//
//  Created by Rocky on 2018/4/20.
//  Copyright © 2018年 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNetworkRateEntity : NSObject

//! 计算网速
- (int64_t)calculateAverageNetworkRateWithSumDataSize:(u_int64_t)dataSize;

//! 开平方
- (int64_t)calculateSquareNetworkRateWithSumDataSize:(u_int64_t)dataSize;

//! 3次平均
- (int64_t)calculateThreeAverNetworkRateWithSumDataSize:(u_int64_t)dataSize;
@end
