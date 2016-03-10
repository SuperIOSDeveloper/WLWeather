//
//  WLDataManager.m
//  WLWeather
//
//  Created by tarena on 16/3/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLDataManager.h"
#import "WLCityGroup.h"
#import "WLDaily.h"
#import "WLHourly.h"

@implementation WLDataManager

static NSArray *_cityGroups = nil;
+ (NSArray *)getAllCityGroups
{
    if (_cityGroups == nil) {
        //从plist文件中读取数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:plistPath];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic in cityGroupArray) {
            WLCityGroup *cityGroup = [[WLCityGroup alloc] init];
            [cityGroup setValuesForKeysWithDictionary:dic];
            [mutableArray addObject:cityGroup];
        }
        _cityGroups = [mutableArray copy];
    }
    return _cityGroups;
}

+ (NSArray *)getAllDailyData:(id)responseObject {
    //从resoponseObject取出weather对应值(数组)
    NSArray *weatherArray = responseObject[@"data"][@"weather"];
    //字典 -> TRDaily
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in weatherArray) {
        WLDaily *daily = [WLDaily parseDailyJson:dic];
        [array addObject:daily];
    }
    //返回
    return [array copy];
}

+ (NSArray *)getAllHourlyData:(id)responseObject {
    NSArray *hourlyArray = responseObject[@"data"][@"weather"][0][@"hourly"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in hourlyArray) {
        WLHourly *hourly = [WLHourly parseHourlyJson:dic];
        [mutableArray addObject:hourly];
    }
    return [mutableArray copy];
}

+ (WLHeader *)getHeaderData:(id)responseObject {
    return [[self alloc] getHeaderData:responseObject];
}

- (WLHeader *)getHeaderData:(id)responseObject {
    WLHeader *header = [WLHeader new];
    header.cityName = responseObject[@"data"][@"request"][0][@"query"];
    header.weatherDesc = responseObject[@"data"][@"current_condition"][0][@"weatherDesc"][0][@"value"];
    header.iconUrl = responseObject[@"data"][@"current_condition"][0][@"weatherIconUrl"][0][@"value"];
    header.weatherTemp = [NSString stringWithFormat:@"  %@˚", responseObject[@"data"][@"current_condition"][0][@"temp_C"]];
//    header.maxTemp = [NSString stringWithFormat:@"%@˚",responseObject[@"data"][@"weather"][0][@"maxtempC"]];
//    header.minTemp = [NSString stringWithFormat:@"%@˚",responseObject[@"data"][@"weather"][0][@"mintempC"]];
    header.todayDate = responseObject[@"data"][@"weather"][0][@"date"];
//    header.fiveDaysDate = responseObject[@"data"][@"weather"];
//    header.maxTempCArray = responseObject[@"data"][@"weather"][3];
//    header.mintempCArray = responseObject[@"data"][@"weather"][5];
    
    return header;
}

@end
