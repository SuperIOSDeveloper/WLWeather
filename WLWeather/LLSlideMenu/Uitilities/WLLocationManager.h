//
//  WLLocationManager.h
//  WLWeather
//
//  Created by tarena on 16/3/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLLocationManager : NSObject

//用户的经纬度
+ (void)getUserLocation:(void(^)(double lat, double log))locationBlock;

//用户的城市的名字(反地理编码)
+ (void)getUserCityName:(void(^)(NSString *cityName))cityBlock;

@end
