//
//  WLLocationManager.m
//  WLWeather
//
//  Created by tarena on 16/3/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface WLLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
//声明block(记录用户的位置)
@property (nonatomic, strong) void(^saveBlock)(double lat, double log);
//地理编码属性
@property (nonatomic, strong) CLGeocoder *coder;
@end

@implementation WLLocationManager

+ (id)sharedLocationManager {
    static WLLocationManager *locationManager = nil;
    if (!locationManager) {
        locationManager = [[WLLocationManager alloc] init];
    }
    return locationManager;
}
//重写init方法(初始化manager+征求同意)
- (instancetype)init {
    if (self = [super init]) {
        self.manager = [CLLocationManager new];
        //初始化coder
        self.coder = [CLGeocoder new];
        //假定用户iOS>8.0(Info.plist添加key)
        [self.manager requestWhenInUseAuthorization];
        //设置代理
        self.manager.delegate = self;
    }
    return self;
}
+ (void)getUserLocation:(void (^)(double, double))locationBlock {
    //获取单例对象+调用私有实例方法
    WLLocationManager *locationManager = [WLLocationManager sharedLocationManager];
    [locationManager getUserLocation:locationBlock];
}
- (void)getUserLocation:(void(^)(double, double))locationBlock {
    //设定更新位置的频率
    self.manager.distanceFilter = 500;//米
    
    //假定用户同意定位(开始定位用户的位置)
    [self.manager startUpdatingLocation];
    
    _saveBlock = locationBlock;
}
#pragma mark - Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    //一定定位到用户的位置
    CLLocation *userLocation = [locations lastObject];
    //block调用的时候，相当于函数
    _saveBlock(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    //避免调用两次定位
    self.manager = nil;
}


+ (void)getUserCityName:(void (^)(NSString *))cityBlock {
    WLLocationManager *locationManger = [WLLocationManager sharedLocationManager];
    [locationManger getUserCityName:cityBlock];
}
- (void)getUserCityName:(void(^)(NSString *))cityBlock {
    //反地理编码
    [WLLocationManager getUserLocation:^(double lat, double log) {
        //获取用户的位置
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:log];
        [self.coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                //取数组中的最后一个
                CLPlacemark *placemark = [placemarks lastObject];
                //取城市的名字(City)
                NSString *cityName = placemark.addressDictionary[@"City"];
                //调用/执行cityBlock
                cityBlock(cityName);
            }
        }];
    }];
}
@end
