//
//  ViewController.m
//  Draw
//
//  Created by Anirudh S on 13/12/14.
//  Copyright (c) 2014 HappyFox. All rights reserved.
//

#import "HSEditImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HSEditImageViewController ()
@end

@implementation HSEditImageViewController

UIImage* resizedImage;

- (void)viewDidLoad {
    [self setInitialPaintAndBrushValues];
    
    [super viewDidLoad];
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"Done"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(save_clicked:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    [self drawAttachmentImage];
}

- (void)setInitialPaintAndBrushValues {
    redValue = 255.0/255.0;
    greenValue = 59.0/255.0;
    blueValue = 48.0/255.0;
    
    [[_redButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_redButton layer] setBorderWidth:2.0f];
    
    brush = 10.0;
    opacity = 1.0;
}

- (void)drawAttachmentImage {
    self.imageOnCanvas.image = _attachmentImage;
    
    CGFloat maxContainerWidth = self.imageOnCanvas.frame.size.width;
    CGFloat maxContainerHeight = self.imageOnCanvas.frame.size.height;
    
    float widthRatio = self.imageOnCanvas.bounds.size.width / _attachmentImage.size.width;
    float heightRatio = self.imageOnCanvas.bounds.size.height / _attachmentImage.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float resizedImageWidth = scale * _attachmentImage.size.width;
    float resizedImageHeight = scale * _attachmentImage.size.height;
    
    CGSize resizingSize = CGSizeMake(resizedImageWidth, resizedImageHeight);
    
    UIGraphicsBeginImageContextWithOptions(resizingSize, NO, 0.0);
    [_attachmentImage drawInRect:CGRectMake(0, 0, resizedImageWidth, resizedImageHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(maxContainerWidth, maxContainerHeight), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGPoint origin = CGPointMake((maxContainerWidth - resizedImageWidth) / 2.0f,
                                 (maxContainerHeight - resizedImageHeight) / 2.0f);
    [scaledImage drawAtPoint:origin];
    
    UIGraphicsPopContext();
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageOnCanvas.image = resizedImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.imageOnCanvas];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.imageOnCanvas];
    
    UIGraphicsBeginImageContextWithOptions(self.imageOnCanvas.frame.size, NO, 0.0);
    [self.imageOnCanvas.image drawInRect:CGRectMake(0, 0, self.imageOnCanvas.frame.size.width, self.imageOnCanvas.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redValue, greenValue, blueValue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageOnCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContextWithOptions(self.imageOnCanvas.frame.size, NO, 0.0);
        [self.imageOnCanvas.image drawInRect:CGRectMake(0, 0, self.imageOnCanvas.frame.size.width, self.imageOnCanvas.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redValue, greenValue, blueValue, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.imageOnCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContextWithOptions(self.imageOnCanvas.frame.size, NO, 0.0);

    [self.imageOnCanvas.image drawInRect:CGRectMake(0, 0, self.imageOnCanvas.frame.size.width, self.imageOnCanvas.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];

    self.imageOnCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)resetAllButtonBorders {
    [[_redButton layer] setBorderColor:[UIColor clearColor].CGColor];
    [[_greenButton layer] setBorderColor:[UIColor clearColor].CGColor];
    [[_blueButton layer] setBorderColor:[UIColor clearColor].CGColor];
    
    [[_redButton layer] setBorderWidth:2.0f];
    [[_greenButton layer] setBorderWidth:2.0f];
    [[_blueButton layer] setBorderWidth:2.0f];
}

- (IBAction)pencilPressed:(id)sender {
    
    [self resetAllButtonBorders];
    UIButton * PressedButton = (UIButton*)sender;
    
    [[sender layer] setBorderColor:[UIColor blackColor].CGColor];
    [[sender layer] setBorderWidth:3.0f];
    
    switch(PressedButton.tag)
    {
        case 0:
            [self setValueRed:255.0 Green:49.0 Blue:48.0];
            break;
        case 1:
            [self setValueRed:76.0 Green:217.0 Blue:100.0];
            break;
        case 2:
            [self setValueRed:0.0 Green:170.0 Blue:255.0];
            break;
    }
}

- (void)setValueRed:(CGFloat)valueRed Green:(CGFloat)valueGreen Blue:(CGFloat)valueBlue {
    redValue = valueRed/255.0;
    greenValue = valueGreen/255.0;
    blueValue = valueBlue/255.0;
}

- (IBAction)resetImage:(id)sender {
    self.imageOnCanvas.image = resizedImage;
}

- (IBAction)save_clicked:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.imageOnCanvas.bounds.size, NO,0.0);
    [self.imageOnCanvas.image drawInRect:CGRectMake(0, 0, self.imageOnCanvas.frame.size.width, self.imageOnCanvas.frame.size.height)];
    UIImage *savedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *viewImage = savedImage;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"error");
            [self.delegate editImageViewController:self didFinishEditingImage:nil];
        } else {
            [self.delegate editImageViewController:self didFinishEditingImage:assetURL];
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

