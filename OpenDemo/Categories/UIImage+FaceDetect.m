//
//  UIImage+FaceDetect.m
//  OpenDemo
//
//  Created by QMTV on 16/9/12.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "UIImage+FaceDetect.h"

@implementation UIImage (FaceDetect)

- (void)detectFaceWithImage:(UIImage *)originImage {
    CIImage *image = [[CIImage alloc] initWithImage:originImage];
    
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    NSArray *features = [faceDetector featuresInImage:image];
    
    for (CIFaceFeature *faceFeature in features) {
        if (faceFeature.hasLeftEyePosition) {
            
        }
        
        if (faceFeature.hasRightEyePosition) {
    
        }
    }
}

@end
