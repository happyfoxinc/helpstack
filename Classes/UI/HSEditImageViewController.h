//
//  ViewController.h
//  Draw
//
//  Created by Anirudh S on 13/12/14.
//  Copyright (c) 2014 HappyFox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSEditImageViewController;
@protocol HSEditImageViewControllerDelegate <NSObject>
- (void)editImageViewController:(HSEditImageViewController *)controller didFinishEditingImage:(NSURL *)imageURL;
@end

@interface HSEditImageViewController : UIViewController {
    
    CGPoint lastPoint;
    CGFloat redValue;
    CGFloat greenValue;
    CGFloat blueValue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

- (IBAction)pencilPressed:(id)sender;
- (IBAction)resetImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *save;
@property (nonatomic, strong) UIImage *attachmentImage;
@property (nonatomic) IBOutlet UIImageView *imageOnCanvas;
@property (nonatomic, weak) id <HSEditImageViewControllerDelegate> delegate;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *redButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *greenButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *blueButton;

@end


