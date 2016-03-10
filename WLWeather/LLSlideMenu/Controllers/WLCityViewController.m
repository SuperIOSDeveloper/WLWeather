//
//  WLCityViewController.m
//  WLWeather
//
//  Created by tarena on 16/3/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WLCityViewController.h"
#import "WLCityGroup.h"
#import "WLDataManager.h"
#import "MBProgressHUD+KR.h"


@interface WLCityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *cityGroupsArray;
@property (nonatomic,strong) WLCityGroup *cityGroup;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WLCityViewController

- (NSArray *)cityGroupsArray
{
    if (!_cityGroupsArray) {
        _cityGroupsArray = [WLDataManager getAllCityGroups];
    }
    return _cityGroupsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clcikBack)];
    [self createTableView];
}

- (void) createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)clcikBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroupsArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.cityGroup = self.cityGroupsArray[section];
    return self.cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WLCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    return cell;
}

//设置sectionHeader标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WLCityGroup *cityGroupHeader = self.cityGroupsArray[section];
    NSString *headerTitle = cityGroupHeader.title;
    return headerTitle;
}

//设置tableView的索引数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //需求:NSArray[@"热门",@"A",...@"Z"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (WLCityGroup *cityGroup in self.cityGroupsArray)
    {
        [mutableArray addObject:cityGroup.title];
    }
    return [mutableArray copy];
    
    //    return [self.cityGroupArray valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取用户选择的那个城市名字(plist文件中item和section对应)
    WLCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    //发送通知(通知中心)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCityChange" object:self userInfo:@{@"CityName" : cityName}];
    //收回
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = 0.5;
    
    CGAffineTransform transformScale = CGAffineTransformMakeScale(0.3,0.8);
    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0.5, 0.6);
    
    cell.transform = CGAffineTransformConcat(transformScale, transformTranslate);
    
    [tableView bringSubviewToFront:cell];
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.alpha = 1;
                         //清空 transform
                         cell.transform = CGAffineTransformIdentity;
                     } completion:nil];
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
