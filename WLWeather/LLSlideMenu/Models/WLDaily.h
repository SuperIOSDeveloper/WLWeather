//
//  WLDaily.h
//  WLWeather
//
//  Created by tarena on 16/3/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLDaily : NSObject

//日期
@property (nonatomic, strong) NSString *date;
//最高温
@property (nonatomic, strong) NSString *maxTempC;
//最低温
@property (nonatomic, strong) NSString *mintempC;
//图标url
@property (nonatomic, strong) NSString *iconUrl;

//给定每天字典，返回解析好的每天对象
+ (WLDaily *)parseDailyJson:(NSDictionary *)dic;

@end
