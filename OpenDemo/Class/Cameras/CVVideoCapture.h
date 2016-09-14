//
//  CVCamera.h
//  OpenDemo
//
//  Created by QMTV on 16/9/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
@protocol CVVideoCaptureDelegate;

@interface CVVideoCapture : NSObject <CvVideoCameraDelegate>

@property (nonatomic, strong) CvVideoCamera *videoCamera;
@property (nonatomic, weak) id<CVVideoCaptureDelegate> delegate;

- (instancetype)initWithCameraView:(UIImageView *)view scale:(CGFloat)scale;

- (void)startCapture;
- (void)stopCapture;

@end

@protocol CVVideoCaptureDelegate <NSObject>

@optional
- (void)cvVideoCaptureDidCaptureImage:(UIImage *)image;

@end
