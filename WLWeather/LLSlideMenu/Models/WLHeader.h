//
//  WLHeader.h
//  WLWeather
//
//  Created by tarena on 16/3/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLHeader : NSObject
//城市名字
@property (nonatomic, strong) NSString *cityName;
//天气图标
@property (nonatomic, strong) NSString *iconUrl;
//天气描述
@property (nonatomic, strong) NSString *weatherDesc;
//当前温度值
@property (nonatomic, strong) NSString *weatherTemp;
//最高温
//@property (nonatomic, strong) NSString *maxTemp;
//最低温
//@property (nonatomic, strong) NSString *minTemp;
//当日日期
@property (nonatomic, strong) NSString *todayDate;
////5天日期
//@property (nonatomic, strong) NSArray *fiveDaysDate;
////最高温
//@property (nonatomic, strong) NSArray *maxTempCArray;
////最低温
//@property (nonatomic, strong) NSArray *mintempCArray;

@end
