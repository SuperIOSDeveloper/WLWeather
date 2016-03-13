//
//  WLMainViewController.m
//  WLWeather
//
//  Created by tarena on 16/3/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLMainViewController.h"
#import "LLSlideMenu.h"
#import "UIImage+Circle.h"
#import "WLCityViewController.h"
#import "WLHeaderView.h"
#import "FlatUIKit.h"
#import "WLDaily.h"
#import "WLHourly.h"
#import "WLDataManager.h"
#import "WLLocationManager.h"
#import "WLNetworkManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MJRefresh.h"
#import "MBProgressHUD+KR.h"


@interface WLMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) LLSlideMenu *slideMenu;

//主视图控制器的tableView
@property (nonatomic, strong ,nullable) UITableView *mainTableView;
@property (nonatomic, strong) WLHeaderView *headerView;

//每天和每小时数组
@property (nonatomic, strong) NSArray *dailyArray;
@property (nonatomic, strong) NSArray *hourlyArray;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CLLocation *userLocation;
//用于地理编码和反地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;
//请求数据的url
@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, strong) CAShapeLayer *maxTempShapeLayer;
@property (nonatomic, strong) CAShapeLayer *minTempShapeLayer;
@property (nonatomic, strong) UIView *tempView;

//最高温最低温label
@property (nonatomic, strong) UILabel *maxTempLabel;
@property (nonatomic, strong) UILabel *minTempLabel;


@end

@implementation WLMainViewController

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(WLHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"WLHeaderView" owner:self options:nil] firstObject];
    }
    return _headerView;
}

- (UILabel *)maxTempLabel
{
    if (!_maxTempLabel) {
        _maxTempLabel = [[UILabel alloc] init];
    }
    return _maxTempLabel;
}

- (UILabel *)minTempLabel
{
    if (!_minTempLabel) {
        _minTempLabel = [[UILabel alloc] init];
    }
    return _minTempLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建主界面的tableView
    [self createMainTableView];
    
    //创建headerView
    [self createHeaderView];
    
    //添加左滑手势
    [self addSwipeGesture];
    
    //创建下拉刷新的控件 刷新时会获取位置
    [self createBottomRefreshControl];
    
    //获取用户的位置并发送请求
//    [self getLocationAndSendRequest];
    //监听通知
    [self listenNotification];
}

#pragma mark - 通知相关方法
- (void)listenNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCityChange:) name:@"DidCityChange" object:nil];
}

- (void)didCityChange:(NSNotification *)notification{
    NSString *cityName = notification.userInfo[@"CityName"];
    [self.geocoder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        self.urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%f,%f&num_of_days=5&format=json&tp=4&key=edc969ea01d86e7d01050ad16eac7",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude];
        self.userLocation = placemark.location;
        self.headerView.cityLabel.text = placemark.addressDictionary[@"City"];
        //重新发送请求
        [self sendRequestToServer];
    }];
}

#pragma mark - 和服务器相关的方法
- (void) getLocationAndSendRequest
{
    [WLLocationManager getUserLocation:^(double lat, double log) {
        self.userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:log];
        //请求的url
        self.urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%f,%f&num_of_days=5&format=json&tp=4&key=edc969ea01d86e7d01050ad16eac7",lat,log];
        [MBProgressHUD showMessage:@"数据更新中..."];
        [self sendRequestToServer];
    }];
}

- (void)sendRequestToServer{
    [WLNetworkManager sendRequestWithUrl:self.urlStr parameters:nil success:^(id responseObject) {
        //成功返回,更新数据
        NSLog(@"成功返回");
        //创建动画图标
        [self createIcon];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"天气数据加载成功" toView:self.view];
        WLHeader *header = [WLDataManager getHeaderData:responseObject];
        //获取数据
        self.dailyArray = [WLDataManager getAllDailyData:responseObject];
        self.hourlyArray = [WLDataManager getAllHourlyData:responseObject];
        //更新头部视图数据
        [self updateHeaderView:header];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        //返回失败
        NSLog(@"返回失败");
        [MBProgressHUD showError:@"网络出错" toView:self.view];
        [self.mainTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 和界面相关方法
- (void)createBottomRefreshControl {
    //创建下拉刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getLocationAndSendRequest)];
    //显示动画(触发selector方法)
    [refreshHeader beginRefreshing];
    //显示到tableView
    self.mainTableView.mj_header = refreshHeader;
}

- (void)updateHeaderView:(WLHeader *)header
{
    //反地理编码
    if (self.userLocation) {
        [self.geocoder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *cityName = placemark.addressDictionary[@"City"];
            self.headerView.cityLabel.text = cityName;
            self.headerView.cityLabel.textColor = [UIColor whiteColor];
            self.headerView.cityLabel.font = [UIFont systemFontOfSize:30];
        }];
    }
    //更新头部视图的所有数据
    self.headerView.temperatureLabel.text = header.weatherTemp;
    self.headerView.todayDateLabel.text = header.todayDate;
    NSInteger integer = 5;
    WLDaily *daily = [[WLDaily alloc] init];//有问题
    daily = self.dailyArray[0];
    self.headerView.firstDayLabel.text = [daily.date substringFromIndex:integer];
    daily = self.dailyArray[1];
    self.headerView.secondDayLabel.text = [daily.date substringFromIndex:integer];
    daily = self.dailyArray[2];
    self.headerView.thirdDayLabel.text = [daily.date substringFromIndex:integer];
    daily = self.dailyArray[3];
    self.headerView.fourthDayLabel.text = [daily.date substringFromIndex:integer];
    daily = self.dailyArray[4];
    self.headerView.fifthDayLabel.text = [daily.date substringFromIndex:integer];
    [self createMaxTempChart];
    [self createMinTempChart];
}
- (void)createMaxTempChart{
    if (self.maxTempShapeLayer) {
        [self.maxTempShapeLayer removeFromSuperlayer];
        self.maxTempShapeLayer = nil;
    }
    self.tempView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREEN_BOUNDS.size.height*0.67, SCREEN_BOUNDS.size.width-40, 128)];
    self.tempView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.tempView];
    UIBezierPath *maxTempBezierPath = [UIBezierPath bezierPath];
    WLDaily *firstDaily = self.dailyArray[0];
    WLDaily *maxTempDaily = [[WLDaily alloc] init];
    CGFloat maxX = (SCREEN_BOUNDS.size.width-40)/10;
    
    //扩大y值使曲线看起来有坡度
    [maxTempBezierPath moveToPoint:CGPointMake(maxX, [firstDaily.maxTempC floatValue]*2)];
    //最高温label
    self.maxTempLabel.frame = CGRectMake(20, ([firstDaily.maxTempC floatValue]*2)-20, 100, 20);
    self.maxTempLabel.textColor = [UIColor whiteColor];
    self.maxTempLabel.font = [UIFont systemFontOfSize:13];
    self.maxTempLabel.text = [NSString stringWithFormat:@"最高温:%@",firstDaily.maxTempC];
    [self.tempView addSubview:self.maxTempLabel];
    
    for (maxTempDaily in self.dailyArray) {
        [maxTempBezierPath addLineToPoint:CGPointMake(maxX, [maxTempDaily.maxTempC floatValue]*2)];
        maxX += (SCREEN_BOUNDS.size.width-40)/5;
    }
    self.maxTempShapeLayer = [CAShapeLayer layer];
    self.maxTempShapeLayer.path = maxTempBezierPath.CGPath;
    self.maxTempShapeLayer.fillColor = nil;
    self.maxTempShapeLayer.lineWidth = 3;
    self.maxTempShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.tempView.layer addSublayer:self.maxTempShapeLayer];
    CABasicAnimation *animaton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animaton.duration = 2.0f;
    animaton.fromValue = @(0.0);
    animaton.toValue = @(1.0);
    [self.maxTempShapeLayer addAnimation:animaton forKey:@"stroke"];
    
}
- (void)createMinTempChart{
    if (self.minTempShapeLayer) {
        [self.minTempShapeLayer removeFromSuperlayer];
        self.minTempShapeLayer = nil;
    }
    UIBezierPath *minTempBezierPath = [UIBezierPath bezierPath];
    WLDaily *minTempDaily = [[WLDaily alloc] init];
    WLDaily *firstDaily = self.dailyArray[0];
    CGFloat minX = (SCREEN_BOUNDS.size.width-40)/10;
    [minTempBezierPath moveToPoint:CGPointMake(minX, ([firstDaily.mintempC floatValue])*2+80.0)];
    //创建最低温lebel
    self.minTempLabel.frame = CGRectMake(20, (([firstDaily.mintempC floatValue]*2)+80.0)+20, 100, 20);
    self.minTempLabel.textColor = [UIColor whiteColor];
    self.minTempLabel.font = [UIFont systemFontOfSize:13];
    self.minTempLabel.text = [NSString stringWithFormat:@"最低温:%@",firstDaily.mintempC];
    [self.tempView addSubview:self.minTempLabel];
    
    for (minTempDaily in self.dailyArray) {
        [minTempBezierPath addLineToPoint:CGPointMake(minX, ([minTempDaily.mintempC floatValue])*2+ 80.0)];
        minX += (SCREEN_BOUNDS.size.width-40)/5;
    }
    self.minTempShapeLayer = [CAShapeLayer layer];
    self.minTempShapeLayer.path = minTempBezierPath.CGPath;
    self.minTempShapeLayer.fillColor = nil;
    self.minTempShapeLayer.lineWidth = 3;
    self.minTempShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.tempView.layer addSublayer:self.minTempShapeLayer];
    CABasicAnimation *animaton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animaton.duration = 2.0f;
    animaton.fromValue = @(0.0);
    animaton.toValue = @(1.0);
    [self.minTempShapeLayer addAnimation:animaton forKey:@"stroke"];
}
- (void)addSwipeGesture{
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGR];
}
- (void)swipe:(UISwipeGestureRecognizer *)swipeGr{
    [self createLeftView];
}
- (void)createIcon{
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(220, 100, 60, 60)];
    [self.headerView addSubview:iconView];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint arcPoint = CGPointMake(30, 30);
    [bezierPath addArcWithCenter:arcPoint radius:10 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [bezierPath moveToPoint:CGPointMake(30, 16)];
    [bezierPath addLineToPoint:CGPointMake(30, 4)];
    
    [bezierPath moveToPoint:CGPointMake(40, 20)];
    [bezierPath addLineToPoint:CGPointMake(50, 10)];
    
    [bezierPath moveToPoint:CGPointMake(44, 30)];
    [bezierPath addLineToPoint:CGPointMake(58, 30)];
    
    [bezierPath moveToPoint:CGPointMake(40, 40)];
    [bezierPath addLineToPoint:CGPointMake(50, 50)];
    
    [bezierPath moveToPoint:CGPointMake(30, 44)];
    [bezierPath addLineToPoint:CGPointMake(30, 56)];
    
    [bezierPath moveToPoint:CGPointMake(20, 40)];
    [bezierPath addLineToPoint:CGPointMake(10, 50)];
    
    [bezierPath moveToPoint:CGPointMake(16, 30)];
    [bezierPath addLineToPoint:CGPointMake(2, 30)];
    
    [bezierPath moveToPoint:CGPointMake(20, 20)];
    [bezierPath addLineToPoint:CGPointMake(10, 10)];
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = bezierPath.CGPath;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.lineWidth = 3;
    self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    [iconView.layer addSublayer:self.shapeLayer];
    CABasicAnimation *animaton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animaton.duration = 2.0f;
    animaton.fromValue = @(0.0);
    animaton.toValue = @(1.0);
    [self.shapeLayer addAnimation:animaton forKey:@"stroke"];
    [UIView animateWithDuration:1.5 delay:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        iconView.frame = CGRectMake(SCREEN_BOUNDS.size.width - 60, 20, 60, 60);
    } completion:nil];
}
- (void)createMainTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.pagingEnabled = YES;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
}
- (void)createLeftView{
    if (_slideMenu.ll_isOpen) {
        [_slideMenu ll_closeSlideMenu];
    }
    else {
    _slideMenu = [[LLSlideMenu alloc] init];
    [self.view addSubview:_slideMenu];
    self.slideMenu.ll_menuWidth = 200.f;
    self.slideMenu.ll_menuBackgroundColor = [UIColor colorFromHexCode:@"#52BFFF"];
    self.slideMenu.ll_springDamping = 15;    //阻力
    self.slideMenu.ll_springVelocity = 15;   //速度
    self.slideMenu.ll_springFramesNum = 60;  //帧数
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 40, 80, 80)];
    UIImage *image = [UIImage imageNamed:@"head"];
    image = [UIImage scaleToSize:image size:CGSizeMake(80, 80)];
    image = [UIImage circleImageWithImage:image borderWidth:5 borderColor:[UIColor clearColor]];
    imageView.image = image;
    [self.slideMenu addSubview:imageView];
    
    //创建leftView中的两个按钮
    UIButton *cityButton = [[UIButton alloc] initWithFrame:CGRectMake(-150, 200, 150, 50)];
    [cityButton setTitle:@"选择城市" forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(clickCityButtonOpenCityView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 150, 50)];
    [setButton setTitle:@"个人设置" forState:UIControlStateNormal];
    [UIView animateWithDuration:1.3 delay:0.5 usingSpringWithDamping:0.15f initialSpringVelocity:4 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        cityButton.frame = CGRectMake(20, 200, 150, 50);
    } completion:nil];
    [self.slideMenu addSubview:cityButton];
    [self.slideMenu addSubview:setButton];
    }
}
- (void)createHeaderView{
    self.headerView.frame = SCREEN_BOUNDS;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 30, 30)];
    [button setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButtonOpenLeftView) forControlEvents:UIControlEventTouchUpInside];
     self.mainTableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:button];
}
- (void)clickButtonOpenLeftView{
    //创建左边的视图控制器
    [self createLeftView];
    // 打开左边视图
    if (_slideMenu.ll_isOpen) {
        [_slideMenu ll_closeSlideMenu];
    } else {
        [_slideMenu ll_openSlideMenu];
    }
}
- (void)clickCityButtonOpenCityView{
    WLCityViewController *cityViewController = [[WLCityViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate/UITableDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hourlyArray.count + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    //设置cell背景颜色/字体颜色/选中状态
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        //设置第0行
        cell.textLabel.text = @"今日天气概况如下:";
        cell.textLabel.font = [UIFont systemFontOfSize:25];
        cell.backgroundColor = [UIColor colorFromHexCode:@"#52BFFF"];
    } else {
        WLHourly *hourly = self.hourlyArray[indexPath.row - 1];
        cell.textLabel.text = hourly.time;
        cell.textLabel.font = [UIFont systemFontOfSize:30];
        cell.detailTextLabel.text = hourly.tempC;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:28];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:hourly.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.backgroundColor = [UIColor colorFromHexCode:@"#52BFFF"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    
    return SCREEN_HEIGHT / cellCount;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
