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
 *  @param picture          需要检测的图片
 *  @param faceBounds       检测到的人脸的边框
 *  @param leftEyePoint     检测到的左眼的位置
 *  @param rightEyePosition 检测到的右眼的位置
 *  @param mouthPosition    检测到的嘴的位置
 */
- (void)ciDetectorFaceWithImage:(UIImage *)picture faceBounds:(CGRect *)faceBounds  leftEyePosition:(CGPoint *)leftEyePoint rightEyePoint:(CGPoint *)rightEyePosition mouthPosition:(CGPoint *)mouthPosition;

/**
 *  使用Opencv的人脸监测
 *
 *  @param image      要检测的图片
 *  @param faceBounds 检测到的人脸的边框
 */
- (void)cvDetectorWithImage:(UIImage *)image faceBounds:(CGRect *)faceBounds;

@end
