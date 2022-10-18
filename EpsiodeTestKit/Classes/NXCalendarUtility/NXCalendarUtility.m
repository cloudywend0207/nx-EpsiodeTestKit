//
//  NXCalendarUtility.m
//  NxStop
//
//  Created by Episode on 2020/8/3.
//  Copyright © 2020 jisheng. All rights reserved.
//

#import "NXCalendarUtility.h"

@implementation NXCalendarUtility

+ (instancetype)shareInstance {
    static NXCalendarUtility *weekCalendarUitility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weekCalendarUitility = [[NXCalendarUtility alloc] init];
        [weekCalendarUitility currentScopeWeek:1 dateFormat:@"YYYY.MM.dd"];
    });
    return weekCalendarUitility;
}

-(NSString *)transWeekName:(NSString *)orrignWeekName
{
    NSString *targetWeekName = @"";
    
    //转换文案
    if ([orrignWeekName isEqualToString:@"Sunday"]) {
        targetWeekName = @"SUN";
    }
    else if ([orrignWeekName isEqualToString:@"Monday"]) {
        targetWeekName = @"MON";
    }
    else if ([orrignWeekName isEqualToString:@"Tuesday"]) {
        targetWeekName = @"TUE";
    }
    else if ([orrignWeekName isEqualToString:@"Wednesday"]) {
        targetWeekName = @"WED";
    }
    else if ([orrignWeekName isEqualToString:@"Thursday"]) {
        targetWeekName = @"THU";
    }
    else if ([orrignWeekName isEqualToString:@"Friday"]) {
        targetWeekName = @"FRI";
    }else{
        targetWeekName = @"SAT";
    }
    
    return targetWeekName;
}

- (void)currentScopeWeek:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat {
    self.dateArray = [NSMutableArray arrayWithCapacity:0];
    self.intervalArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    // 1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    calendar.firstWeekday = firstWeekday;
    
    // 日历单元
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    unsigned unitNewFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowComponents = [calendar components:unitFlag fromDate:nowDate];
    // 获取今天是周几，需要用来计算
    NSInteger weekDay = [nowComponents weekday];
    // 获取今天是几号，需要用来计算
    NSInteger day = [nowComponents day];
    // 计算今天与本周第一天的间隔天数
    NSInteger countDays = 0;
    // 特殊情况，本周第一天firstWeekday比当前星期weekDay小的，要回退7天
    if (calendar.firstWeekday > weekDay) {
        countDays = 7 + (weekDay - calendar.firstWeekday);
    } else {
        countDays = weekDay - calendar.firstWeekday;
    }
    // 获取这周的第一天日期
    NSDateComponents *firstComponents = [calendar components:unitNewFlag fromDate:nowDate];
    [firstComponents setDay:day - countDays];
    
    // 输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    for (int i=0; i<5; i++) {
        NSDateComponents *tempComponents = firstComponents;
        [tempComponents setDay:firstComponents.day + 1];
        NSDate *tempDate = [calendar dateFromComponents:tempComponents];
        
        NSTimeInterval interval = [tempDate timeIntervalSince1970];
        NSString *intervalString = [NSString stringWithFormat:@"%f",interval];
        [self.intervalArray addObject:intervalString];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMM"];
        NSString *monthString = [monthFormatter stringFromDate:tempDate];
        monthString = [monthString uppercaseString];
        
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d"];
        NSString *dateString = [dateFormatter stringFromDate:tempDate];
                
        //星期
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];
        NSString *weekString = [self transWeekName:[weekFormatter stringFromDate:tempDate]];//周几
        
        BOOL isDateSelected = NO;
        if (i==2) {
            isDateSelected = YES;
        }else{
            isDateSelected = NO;
        }
        NSDictionary *dateDict = @{@"monthName":monthString,@"dayName":dateString,@"weekName":weekString,@"isDateSelected":@(isDateSelected)};
        [self.dateArray addObject:dateDict.mutableCopy];
    }
}

/**
 *  获取当前时间开始的一周日期
 *  注意：当天作为起点往后顺延的一周
 */
-(void)getDateFiveFromToday{
    self.dateArray = [NSMutableArray arrayWithCapacity:0];
    self.intervalArray = [NSMutableArray arrayWithCapacity:0];
    //日历格式
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    
    for (int i=0; i<5; i++) {
        //这一天
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * i]];
        NSDate *date = [calendar dateFromComponents:components];
        
        
        NSTimeInterval interval = [date timeIntervalSince1970];
        NSString *intervalString = [NSString stringWithFormat:@"%f",interval];
        [self.intervalArray addObject:intervalString];
        //月份
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMM"];
        NSString *monthString = [monthFormatter stringFromDate:date];
        monthString = [monthString uppercaseString];
        
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d"];
        NSString *dateString = [dateFormatter stringFromDate:date];
                
        //星期
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];
        NSString *weekString = [self transWeekName:[weekFormatter stringFromDate:date]];//周几
        
        BOOL isDateSelected = NO;
        if (i==2) {
            isDateSelected = YES;
        }else{
            isDateSelected = NO;
        }
        NSDictionary *dateDict = @{@"monthName":monthString,@"dayName":dateString,@"weekName":weekString,@"isDateSelected":@(isDateSelected)};
        [self.dateArray addObject:dateDict.mutableCopy];
    }

}

@end
