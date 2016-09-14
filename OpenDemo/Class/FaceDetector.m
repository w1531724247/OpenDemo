//
//  FaceDetector.m
//  OpenDemo
//
//  Created by QMTV on 16/9/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FaceDetector.h"

@interface FaceDetector ()

@end

@implementation FaceDetector

- (void)detectorFaceWithImage:(UIImage *)picture faceBounds:(CGRect *)faceBounds leftEyePosition:(CGPoint *)leftEyePoint rightEyePoint:(CGPoint *)rightEyePosition mouthPosition:(CGPoint *)mouthPosition {
    
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:picture.CGImage];
    
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face.  CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.  Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for(CIFaceFeature* faceFeature in features)
    {
        // set value to faceBounds
        *faceBounds = faceFeature.bounds;
        
        if(faceFeature.hasLeftEyePosition)
        {
            //set value to leftEyeposition
            *leftEyePoint = faceFeature.leftEyePosition;
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            //set value to rightEyeposition
            *rightEyePosition = faceFeature.rightEyePosition;
        }
        
        if(faceFeature.hasMouthPosition)
        {
            //set value to rightEyeposition
            *mouthPosition = faceFeature.mouthPosition;
        }
    }
}

@end
