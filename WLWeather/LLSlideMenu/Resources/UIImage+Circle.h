//
//  UIImage+Circle.h
//  MusicPlayer
//
//  Created by tarena on 15/5/5.
//  Copyright (c) 2015年 tarena. All rights reserved.
// 可生成圆型图片的UIImage分类

#import <UIKit/UIKit.h>

@interface UIImage (Circle)
/**
 * 根据指定的图片文件名获取一个圆形的图片对象，并加边框
 * @param name  图片名
 * @param borderWidth  边框宽度
 * @param borderColor  边框颜色
 * @return 圆形图片对象
 */
+ (UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 * 根据指定的图片文件名获取一个圆形的图片对象，并加边框
 * @param image  图片对象
 * @param borderWidth  边框宽度
 * @param borderColor  边框颜色
 * @return 圆形图片对象
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 * 对图片对象进行缩放
 * @param image  要缩放的图片对象
 * @param size  缩放的目标大小
 * @return 缩放后的图片对象
 */
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
@end




