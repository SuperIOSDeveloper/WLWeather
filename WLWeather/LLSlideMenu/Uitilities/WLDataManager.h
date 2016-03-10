//
//  WLDataManager.h
//  WLWeather
//
//  Created by tarena on 16/3/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLHeader.h"

@interface WLDataManager : NSObject

//获取所有的城市数组
+ (NSArray *)getAllCityGroups;

//给定服务器返回的responseObject，返回已经解析好的每天数组(TRDaily)
+ (NSArray *)getAllDailyData:(id)responseObject;

//给定responseObject,返回已经解析好的每小时数组(TRHourly)
+ (NSArray *)getAllHourlyData:(id)responseObject;

//给定responseObject,返回已经解析好的头部视图的模型对象
+ (WLHeader *)getHeaderData:(id)responseObject;

//给定daily数组
+ (void)getDailyArray:(NSArray *)dailyArray;

@end
