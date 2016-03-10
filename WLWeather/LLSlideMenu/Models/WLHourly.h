//
//  WLHourly.h
//  WLWeather
//
//  Created by tarena on 16/3/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLHourly : NSObject

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *tempC;
@property (nonatomic, strong) NSString *iconUrl;

+ (WLHourly *)parseHourlyJson:(NSDictionary *)dic;

@end
