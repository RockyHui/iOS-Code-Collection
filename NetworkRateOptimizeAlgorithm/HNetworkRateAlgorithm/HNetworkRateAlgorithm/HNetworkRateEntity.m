//
//  HNetworkRateEntity.m
//  HNetworkRateAlgorithm
//
//  Created by Rocky on 2018/4/20.
//  Copyright © 2018年 Rocky. All rights reserved.
//

#import "HNetworkRateEntity.h"

#define H_ZERO_DATA_UP_LIMIT            4
#define H_NET_DATA_WEIGHT               0.5

@interface HNetworkRateEntity()

//! 上一次时间点数据量
@property (nonatomic, assign) int64_t lastTimeCompletedDataSize;

//! 当前时间点数据量
@property (nonatomic, assign) int64_t realCompletedDataSize;

//! 连续无数据量变化次数
@property (nonatomic, assign) NSInteger continueZeroDataTimes;

//! 单位时间内的网速
@property (nonatomic, assign) int64_t networkDataRate;

//! 上上一次时间点数据量
@property (nonatomic, assign) int64_t beforeLastTimeCompletedDataSize;

//! 计算次数
@property (nonatomic, assign) int64_t calcuateTimes;

@end

@implementation HNetworkRateEntity

- (instancetype)init
{
    if(self = [super init]) {
        self.lastTimeCompletedDataSize = 0;
        self.realCompletedDataSize = 0;
        self.continueZeroDataTimes = 0;
    }
    
    return self;
}


- (int64_t)calculateAverageNetworkRateWithSumDataSize:(u_int64_t)dataSize
{
    _lastTimeCompletedDataSize = _realCompletedDataSize;
    _realCompletedDataSize = dataSize;
    
    u_int64_t dataSizeOffset = _realCompletedDataSize - _lastTimeCompletedDataSize;
    
    if (dataSizeOffset == 0) {
        if (_continueZeroDataTimes < H_ZERO_DATA_UP_LIMIT) {
            _continueZeroDataTimes++;
        }
    } else {
        _continueZeroDataTimes = 0;
    }
    
    if (_continueZeroDataTimes >= H_ZERO_DATA_UP_LIMIT) {
        _networkDataRate = 0;
    } else {
        _networkDataRate = _networkDataRate * H_NET_DATA_WEIGHT + dataSizeOffset * (1 - H_NET_DATA_WEIGHT);
    }
    
    return _networkDataRate;
}


- (int64_t)calculateSquareNetworkRateWithSumDataSize:(u_int64_t)dataSize
{
    _lastTimeCompletedDataSize = _realCompletedDataSize;
    _realCompletedDataSize = dataSize;
    
    u_int64_t dataSizeOffset = _realCompletedDataSize - _lastTimeCompletedDataSize;
    
    if (_calcuateTimes >= 1) {
        _networkDataRate = sqrt(_networkDataRate * _networkDataRate + dataSizeOffset * dataSizeOffset) * 0.618;
    } else {
        _networkDataRate = dataSizeOffset;
        _calcuateTimes++;
    }
    
    return _networkDataRate;
}

- (int64_t)calculateThreeAverNetworkRateWithSumDataSize:(u_int64_t)dataSize
{
    int64_t lastDataOffset =  _lastTimeCompletedDataSize - _beforeLastTimeCompletedDataSize;
    
    _beforeLastTimeCompletedDataSize = _lastTimeCompletedDataSize;
    _lastTimeCompletedDataSize = dataSize;
    
    int64_t dataOffset = _lastTimeCompletedDataSize - _beforeLastTimeCompletedDataSize;
    
    if (_calcuateTimes >= 2) {
        _networkDataRate = (lastDataOffset + dataOffset + _networkDataRate)/3;
    } else if (_calcuateTimes == 1 ) {
        _networkDataRate = (dataOffset + _networkDataRate)/2;
        _calcuateTimes++;
    } else if (_calcuateTimes == 0) {
        _networkDataRate = dataOffset;
        _calcuateTimes++;
    }
    
    
    return _networkDataRate;
}

@end
