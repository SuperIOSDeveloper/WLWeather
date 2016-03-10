//
//  WLNetworkManager.h
//  WLWeather
//
//  Created by tarena on 16/3/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLNetworkManager : NSObject

//封装AFNetworking的get方法
+ (void)sendRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)dic success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
