//
//  FaceDetector.m
//  OpenDemo
//
//  Created by QMTV on 16/9/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FaceDetector.h"
#import "opencv2/highgui/ios.h"
#import "flandmark_detector.h"

void detectFaceInImage(IplImage *orig, IplImage* input, CvHaarClassifierCascade* cascade, FLANDMARK_Model *model, int *bbox, double *landmarks)
{
    // Smallest face size.
    CvSize minFeatureSize = cvSize(40, 40);
    int flags =  CV_HAAR_DO_CANNY_PRUNING;
    // How detailed should the search be.
    float search_scale_factor = 1.1f;
    CvMemStorage* storage;
    CvSeq* rects;
    int nFaces;
    
    storage = cvCreateMemStorage(0);
    cvClearMemStorage(storage);
    
    // Detect all the faces in the greyscale image.
    rects = cvHaarDetectObjects(input, cascade, storage, search_scale_factor, 2, flags, minFeatureSize);
    nFaces = rects->total;
    
    double t = (double)cvGetTickCount();
    for (int iface = 0; iface < (rects ? nFaces : 0); ++iface)
    {
        CvRect *r = (CvRect*)cvGetSeqElem(rects, iface);
        
        bbox[0] = r->x;
        bbox[1] = r->y;
        bbox[2] = r->x + r->width;
        bbox[3] = r->y + r->height;
        
        flandmark_detect(input, bbox, model, landmarks);
        
        // display landmarks
        cvRectangle(orig, cvPoint(bbox[0], bbox[1]), cvPoint(bbox[2], bbox[3]), CV_RGB(255,0,0) );
        cvRectangle(orig, cvPoint(model->bb[0], model->bb[1]), cvPoint(model->bb[2], model->bb[3]), CV_RGB(0,0,255) );
        cvCircle(orig, cvPoint((int)landmarks[0], (int)landmarks[1]), 3, CV_RGB(0, 0,255), CV_FILLED);
        for (int i = 2; i < 2*model->data.options.M; i += 2)
        {
            cvCircle(orig, cvPoint(int(landmarks[i]), int(landmarks[i+1])), 3, CV_RGB(255,0,0), CV_FILLED);
            
        }
    }
    t = (double)cvGetTickCount() - t;
    int ms = cvRound( t / ((double)cvGetTickFrequency() * 1000.0) );
    
    if (nFaces > 0)
    {
        printf("Faces detected: %d; Detection of facial landmark on all faces took %d ms\n", nFaces, ms);
    } else {
        printf("NO Face\n");
    }
    
    cvReleaseMemStorage(&storage);
}

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

/**
 *  使用flandmark 检测人脸
 *
 *  @param image 要检测的图片
 */
- (void)landmarkDetectWithImage:(UIImage *)image {
    NSString *datPath = [[NSBundle mainBundle] pathForResource:@"flandmark_model" ofType:@"dat"];
    const char *datPathString = [datPath UTF8String];
    
    // load flandmark model structure and initialize
    FLANDMARK_Model *model = flandmark_init(datPathString);
    
    UIImage *meiNvImage = [UIImage imageNamed:@"Jackie_Chan_0004.jpg"];
    // load input image
    IplImage *img = [self createIplImageFromUIImage:meiNvImage];
    
    // convert image to grayscale
    IplImage *img_grayscale = cvCreateImage(cvSize(img->width, img->height), IPL_DEPTH_8U, 1);
    cvCvtColor(img, img_grayscale, CV_BGR2GRAY);
    
    // bbox with detected face (format: top_left_col top_left_row bottom_right_col bottom_right_row)
    int bbox[] = {72, 72, 183, 183};
    
    // detect facial landmarks (output are x, y coordinates of detected landmarks)
    double *landmarks = (double*)malloc(2*model->data.options.M*sizeof(double));
    
    flandmark_detect(img_grayscale, bbox, model, landmarks);
    
    cvRectangle(img, cvPoint(bbox[0], bbox[1]), cvPoint(bbox[2], bbox[3]), CV_RGB(255,0,0) );
    cvRectangle(img, cvPoint(model->bb[0], model->bb[1]), cvPoint(model->bb[2], model->bb[3]), CV_RGB(0,0,255) );
    cvCircle(img, cvPoint((int)landmarks[0], (int)landmarks[1]), 3, CV_RGB(0, 0,255), CV_FILLED);
    for (int i = 2; i < 2*model->data.options.M; i += 2)
    {
        cvCircle(img, cvPoint(int(landmarks[i]), int(landmarks[i+1])), 3, CV_RGB(255,0,0), CV_FILLED);
        
    }
    printf("detection = \t[");
    for (int ii = 0; ii < 2*model->data.options.M; ii+=2)
    {
        printf("%.2f ", landmarks[ii]);
    }
    printf("]\n");
    printf("\t\t[");
    for (int ii = 1; ii < 2*model->data.options.M; ii+=2)
    {
        printf("%.2f ", landmarks[ii]);
    }
    printf("]\n");
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self UIImageFromIplImage:img]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    NSLog(@"landmarks = %.1f", *landmarks);
}

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)createIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

@end
