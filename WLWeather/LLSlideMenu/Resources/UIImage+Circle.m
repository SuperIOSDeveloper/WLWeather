//
//  UIImage+Circle.m
//  MusicPlayer
//
//  Created by tarena on 15/5/5.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

+ (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    //2. 开启上下文
    CGFloat imageWidth = sourceImage.size.width + 2 * borderWidth;
    CGFloat imageHeight = sourceImage.size.height + 2 * borderWidth;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    //3. 获取当前上下文
    UIGraphicsGetCurrentContext();
    //4. 画圆圈
    CGFloat radius = (sourceImage.size.width < sourceImage.size.height?sourceImage.size.width:sourceImage.size.height)*0.5;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeight * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bezierPath.lineWidth = borderWidth;
    [borderColor setStroke];
    [bezierPath stroke];
    
    //5. 使用bezierPath进行剪切
    [bezierPath addClip];
    
    //6. 画图
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    
    //7. 从内存中创建新图片对象
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //8. 结束上下文
    UIGraphicsEndImageContext();
    
    return image;

}
+ (UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    //1. 创建原图片对象
    UIImage *sourceImage = [UIImage imageNamed:name];
    return [self circleImageWithImage:sourceImage borderWidth:borderWidth borderColor:borderColor];
}

+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}





@end



