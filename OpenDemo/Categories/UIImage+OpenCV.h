//
//  UIImageView+OpenCV.h
//  OpenDemo
//
//  Created by QMTV on 16/9/5.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)mat;

@end
