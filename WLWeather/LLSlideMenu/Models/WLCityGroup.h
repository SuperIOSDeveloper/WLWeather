//
//  WLCityGroup.h
//  WLWeather
//
//  Created by tarena on 16/3/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLCityGroup : NSObject

//记录plist文件中的城市数组和标题
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *cities;

@end
