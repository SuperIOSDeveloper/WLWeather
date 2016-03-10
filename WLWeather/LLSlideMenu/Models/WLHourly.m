//
//  WLHourly.m
//  WLWeather
//
//  Created by tarena on 16/3/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLHourly.h"

@implementation WLHourly

+ (WLHourly *)parseHourlyJson:(NSDictionary *)dic {
    return [[self alloc] parseHourlyJson:dic];
}

- (WLHourly *)parseHourlyJson:(NSDictionary *)dic {
    self.iconUrl = dic[@"weatherIconUrl"][0][@"value"];
#warning 此处使用本地图片
    //    NSString *url = dic[@"weatherIconUrl"][0][@"value"];
    //    self.iconUrl = [TRDataManager imageMap][url];
    int time = [dic[@"time"] intValue] / 100;
    self.time = [NSString stringWithFormat:@"%d:00", time];
    self.tempC = [NSString stringWithFormat:@"%@˚", dic[@"tempC"]];
    
    return self;
}

@end
