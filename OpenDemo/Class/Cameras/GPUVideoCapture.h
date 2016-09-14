//
//  GPUVideoCapture.h
//  OpenDemo
//
//  Created by QMTV on 16/9/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUVideoConfiguration.h"

@class GPUVideoCapture;
/** LFVideoCapture callback videoData */
@protocol GPUVideoCaptureDelegate <NSObject>
- (void)captureOutput:(nullable GPUVideoCapture *)capture pixelBuffer:(nullable CVPixelBufferRef)pixelBuffer;
@end

@interface GPUVideoCapture : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

/** The delegate of the capture. captureData callback */
@property (nullable, nonatomic, weak) id<GPUVideoCaptureDelegate> delegate;

/** The running control start capture or stop capture*/
@property (nonatomic, assign) BOOL running;

/** The preView will show OpenGL ES view*/
@property (null_resettable, nonatomic, strong) UIView *preView;

/** The captureDevicePosition control camraPosition ,default front*/
@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;

@property (nonatomic, strong, nullable) UIImage *currentImage;

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 The designated initializer. Multiple instances with the same configuration will make the
 capture unstable.
 */
- (nullable instancetype)initWithVideoConfiguration:(GPUVideoConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
@end


