//
//  NXCalendarUtility.h
//  NxStop
//
//  Created by Episode on 2020/8/3.
//  Copyright © 2020 jisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXCalendarUtility : NSObject

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *intervalArray;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
