//
//  ViewController.m
//  OpenDemo
//
//  Created by QMTV on 16/9/4.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#define kPerSecondDetectCount 5 //每秒钟人脸监测的次数

#import "ViewController.h"
#import "CVVideoCapture.h"
#import "FaceDetector.h"

@interface ViewController ()<CVVideoCaptureDelegate>

@property (nonatomic, strong) FaceDetector *detector;
@property (nonatomic, strong) CVVideoCapture *cvCamera;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *faceFrameView;
@property (nonatomic, strong) UIView *leftEyeView;
@property (nonatomic, strong) UIView *rightEyeView;
@property (nonatomic, strong) UIView *mouthView;

@property (nonatomic, assign) int counter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setup];

    //使用CIDetector检测需要转换坐标系, 使用CVDectector则不需要转换坐标系
    // flip image on y-axis to match coordinate system used by core image
    [self.imageView setTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    // flip the entire window to make everything right side up
    [self.view setTransform:CGAffineTransformMakeScale(1.0, -1.0)];
}

- (void)setup {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.faceFrameView];
    [self.view addSubview:self.leftEyeView];
    [self.view addSubview:self.rightEyeView];
    [self.view addSubview:self.mouthView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.imageView.frame = CGRectMake(0.0, 0.0, 480.0, 640.0);
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.cvCamera startCapture];
}

#pragma mark ----private

- (void)detectorFaceByCIDetectorFromPicture:(UIImage *)picture {
    CGRect faceBounds;
    CGPoint leftEyePosition;
    CGPoint rightEyePosition;
    CGPoint mouthPosition;
    
    [self.detector ciDetectorFaceWithImage:picture faceBounds:&faceBounds leftEyePosition:&leftEyePosition rightEyePoint:&rightEyePosition mouthPosition:&mouthPosition];
    
    if (![[NSValue valueWithCGRect:faceBounds] isEqualToValue:[NSValue valueWithCGRect:CGRectZero]]) {
        self.faceFrameView.frame = faceBounds;
    }
    
    if (![[NSValue valueWithCGPoint:leftEyePosition] isEqualToValue:[NSValue valueWithCGPoint:CGPointZero]]) {
        self.leftEyeView.center = leftEyePosition;
    }

    if (![[NSValue valueWithCGPoint:rightEyePosition] isEqualToValue:[NSValue valueWithCGPoint:CGPointZero]]) {
        self.rightEyeView.center = rightEyePosition;
    }
    
    if (![[NSValue valueWithCGPoint:mouthPosition] isEqualToValue:[NSValue valueWithCGPoint:CGPointZero]]) {
        self.mouthView.center = mouthPosition;
    }
}

- (void)detectorFaceByCVDetectorFromPicture:(UIImage *)picture {
    CGRect faceBounds;
    
    [self.detector cvDetectorWithImage:picture faceBounds:&faceBounds];
    
    if (![[NSValue valueWithCGRect:faceBounds] isEqualToValue:[NSValue valueWithCGRect:CGRectZero]]) {
        self.faceFrameView.frame = faceBounds;
    }
}

#pragma mark ---- CVVideoCaptureDelegate
- (void)cvVideoCaptureDidCaptureImage:(UIImage *)image {
    self.counter++;
    if (15/self.counter == kPerSecondDetectCount) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self detectorFaceByCIDetectorFromPicture:image];
        });
        
        self.counter = 0;
    }
}

#pragma mark ----getter
- (CVVideoCapture *)cvCamera {
    if (!_cvCamera) {
        _cvCamera = [[CVVideoCapture alloc] initWithCameraView:self.imageView scale:2.0];
        _cvCamera.delegate = self;
    }
    return _cvCamera;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (FaceDetector *)detector {
    if (!_detector) {
        _detector = [[FaceDetector alloc] init];
    }
    return _detector;
}

- (UIView *)faceFrameView {
    if (!_faceFrameView) {
        _faceFrameView = [[UIView alloc] init];
        _faceFrameView.layer.borderColor = [UIColor redColor].CGColor;
        _faceFrameView.layer.borderWidth = 0.5;
    }
    return _faceFrameView;
}

- (UIView *)leftEyeView {
    if (!_leftEyeView) {
        _leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
        _leftEyeView.layer.borderWidth = 0.5;
        _leftEyeView.layer.cornerRadius = 15.0/2.0;
        _leftEyeView.layer.masksToBounds = YES;
        _leftEyeView.backgroundColor = [UIColor purpleColor];
    }
    return _leftEyeView;
}

- (UIView *)rightEyeView {
    if (!_rightEyeView) {
        _rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
        _rightEyeView.layer.borderWidth = 0.5;
        _rightEyeView.layer.cornerRadius = 15.0/2.0;
        _rightEyeView.layer.masksToBounds = YES;
        _rightEyeView.backgroundColor = [UIColor blueColor];
    }
    return _rightEyeView;
}

- (UIView *)mouthView {
    if (!_mouthView) {
        _mouthView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
        _mouthView.layer.borderWidth = 0.5;
        _mouthView.layer.cornerRadius = 15.0/2.0;
        _mouthView.layer.masksToBounds = YES;
        _mouthView.backgroundColor = [UIColor orangeColor];
    }
    return _mouthView;
}

@end
