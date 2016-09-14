//
//  GPUVideoCapture.m
//  OpenDemo
//
//  Created by QMTV on 16/9/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "GPUVideoCapture.h"
#import <GPUImage/GPUImage.h>

@interface GPUVideoCapture ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUVideoConfiguration *configuration;
@property (nonatomic, strong) GPUImageView *gpuImageView;

@end

@implementation GPUVideoCapture

#pragma mark --- life circle
- (instancetype)initWithVideoConfiguration:(GPUVideoConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        
    }
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count != 0)
    {
        //在这里执行检测到人脸后要执行的代码
        /*人脸数据存在metadataObjects这个数组里，数组中每一个元素对应一个metadataObject对象，该对象的各种属性对应人脸各种信息，具体可以查看API*/
        
    }
}

#pragma mark -- setter

- (void)setRunning:(BOOL)running {
    if (_running == running) return;
    _running = running;
    
    if (!_running) {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [self.videoCamera stopCameraCapture];
    } else {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [self.videoCamera startCameraCapture];
    }
}

- (void)setPreView:(UIView *)preView {
    if (self.gpuImageView.superview) [self.gpuImageView removeFromSuperview];
    [preView insertSubview:self.gpuImageView atIndex:0];
    self.gpuImageView.frame = CGRectMake(0, 0, preView.frame.size.width, preView.frame.size.height);
}

- (UIView *)preView {
    return self.gpuImageView.superview;
}

- (void)setCaptureDevicePosition:(AVCaptureDevicePosition)captureDevicePosition {
    [self.videoCamera rotateCamera];
    self.videoCamera.frameRate = (int32_t)_configuration.videoFrameRate;
}



#pragma mark ----  getter

- (GPUImageVideoCamera *)videoCamera{
    if(!_videoCamera){
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:_configuration.avSessionPreset cameraPosition:AVCaptureDevicePositionFront];
        UIInterfaceOrientation statusBar = [[UIApplication sharedApplication] statusBarOrientation];
        if (self.configuration.landscape) {
            if (statusBar != UIInterfaceOrientationLandscapeLeft && statusBar != UIInterfaceOrientationLandscapeRight) {
                @throw [NSException exceptionWithName:@"当前设置方向出错" reason:@"LFLiveVideoConfiguration landscape error" userInfo:nil];
            } else {
                _videoCamera.outputImageOrientation = statusBar;
            }
        } else {
            if (statusBar != UIInterfaceOrientationPortrait && statusBar != UIInterfaceOrientationPortraitUpsideDown) {
                @throw [NSException exceptionWithName:@"当前设置方向出错" reason:@"LFLiveVideoConfiguration landscape error" userInfo:nil];
            } else {
                _videoCamera.outputImageOrientation = statusBar;
            }
        }
        
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.horizontallyMirrorRearFacingCamera = NO;
        _videoCamera.frameRate = (int32_t)_configuration.videoFrameRate;
    }
    return _videoCamera;
}

- (GPUImageView *)gpuImageView{
    if(!_gpuImageView){
        _gpuImageView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_gpuImageView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
        [_gpuImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _gpuImageView;
}




@end
