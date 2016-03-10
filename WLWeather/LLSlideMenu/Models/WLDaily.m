//
//  WLDaily.m
//  WLWeather
//
//  Created by tarena on 16/3/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLDaily.h"

@implementation WLDaily

+ (WLDaily *)parseDailyJson:(NSDictionary *)dic {
    return [[self alloc] parseDailyJson:dic];
}
- (WLDaily *)parseDailyJson:(NSDictionary *)dic {
    self.date = dic[@"date"];
    //option/alt + k => ˚
    self.maxTempC = [NSString stringWithFormat:@"%@˚", dic[@"maxtempC"]];
    self.mintempC = [NSString stringWithFormat:@"%@˚", dic[@"mintempC"]];
    self.iconUrl = dic[@"hourly"][0][@"weatherIconUrl"][0][@"value"];
    return self;
}

@end
