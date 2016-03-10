//
//  WLHeaderView.h
//  WLWeather
//
//  Created by tarena on 16/3/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *maxtempCLabel;
@property (nonatomic,strong) UILabel *mintempCLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayMaxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayMinTempLabel;




@end
