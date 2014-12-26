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
    red = 255.0/255.0;
    green = 59.0/255.0;
    blue = 48.0/255.0;
    
    [[_redButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_redButton layer] setBorderWidth:2.0f];
    
    brush = 10.0;
    opacity = 1.0;
    
    [super viewDidLoad];
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"Save"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(save_clicked:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    self.tempDrawImage.image = _attachmentImage;
    
    CGFloat maxContainerWidth = self.tempDrawImage.frame.size.width;
    CGFloat maxContainerHeight = self.tempDrawImage.frame.size.height;
    
    float widthRatio = self.tempDrawImage.bounds.size.width / _attachmentImage.size.width;
    float heightRatio = self.tempDrawImage.bounds.size.height / _attachmentImage.size.height;
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

    self.tempDrawImage.image = resizedImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.tempDrawImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tempDrawImage];
    
    UIGraphicsBeginImageContextWithOptions(self.tempDrawImage.frame.size, NO, 0.0);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContextWithOptions(self.tempDrawImage.frame.size, NO, 0.0);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContextWithOptions(self.tempDrawImage.frame.size, NO, 0.0);

    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];

    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
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
    [[sender layer] setBorderWidth:2.0f];
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 255.0/255.0;
            green = 49.0/255.0;
            blue = 48.0/255.0;
            break;
        case 1:
            red = 76.0/255.0;
            green = 217.0/255.0;
            blue = 100.0/255.0;
            break;
        case 2:
            red = 0.0/255.0;
            green = 170.0/255.0;
            blue = 255.0/255.0;
            break;
    }
}

- (IBAction)resetImage:(id)sender {
    self.tempDrawImage.image = resizedImage;
}

- (IBAction)save_clicked:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.tempDrawImage.bounds.size, NO,0.0);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    UIImage *savedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *viewImage = savedImage;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"error");
        } else {
            [self.delegate editImageViewController:self didFinishEditingImage:assetURL];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end

