//
//  FaceDetector.m
//  OpenDemo
//
//  Created by QMTV on 16/9/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FaceDetector.h"
#import "opencv2/highgui/ios.h"

@interface FaceDetector (){
    cv::CascadeClassifier faceDetector;
}

@end

@implementation FaceDetector

/**
 *  用coreImage的CIDetector检测图片中的人脸
 *
 *  @param picture          需要检测的图片
 *  @param faceBounds       检测到的人脸的边框
 *  @param leftEyePoint     检测到的左眼的位置
 *  @param rightEyePosition 检测到的右眼的位置
 *  @param mouthPosition    检测到的嘴的位置
 */
- (void)ciDetectorFaceWithImage:(UIImage *)picture faceBounds:(CGRect *)faceBounds leftEyePosition:(CGPoint *)leftEyePoint rightEyePoint:(CGPoint *)rightEyePosition mouthPosition:(CGPoint *)mouthPosition {
    
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

/**
 *  使用Opencv的人脸监测
 *
 *  @param image      要检测的图片
 *  @param faceBounds 检测到的人脸的边框
 */
- (void)cvDetectorWithImage:(UIImage *)image faceBounds:(CGRect *)faceBounds {
    if (!image) {
        return;
    }
    
    // Load cascade classifier from the XML file
    NSString* cascadePath = [[NSBundle mainBundle]
                             pathForResource:@"haarcascade_frontalface_alt"
                             ofType:@"xml"];
    faceDetector.load([cascadePath UTF8String]);

    //Load image with face
    cv::Mat faceImage;
    UIImageToMat(image, faceImage);
    
    
    // Convert to grayscale
    cv::Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    // Detect faces
    std::vector<cv::Rect> faces;
    faceDetector.detectMultiScale(gray, faces, 1.1,
                                  2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    
    // Draw first detected faces
    const cv::Rect& face = faces[0];
    
    *faceBounds = CGRectMake(face.x, face.y, face.width, face.height);
}

@end
