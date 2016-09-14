//
//  FaceDetector.h
//  OpenDemo
//
//  Created by QMTV on 16/9/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceDetector : NSObject
/**
 *  用coreImage的CIDetector检测图片中的人脸
 *
 *  @param picture          需要监测的图片
 *  @param faceBounds       检测到的人脸的边框
 *  @param leftEyePoint     检测到的左眼的位置
 *  @param rightEyePosition 检测到的右眼的位置
 *  @param mouthPosition    检测到的嘴的位置
 */
- (void)detectorFaceWithImage:(UIImage *)picture faceBounds:(CGRect *)faceBounds  leftEyePosition:(CGPoint *)leftEyePoint rightEyePoint:(CGPoint *)rightEyePosition mouthPosition:(CGPoint *)mouthPosition;

@end
