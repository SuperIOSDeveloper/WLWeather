//
//  WLNetworkManager.m
//  WLWeather
//
//  Created by tarena on 16/3/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLNetworkManager.h"
#import "AFNetworking.h"

@implementation WLNetworkManager

+ (void)sendRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)dic success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
