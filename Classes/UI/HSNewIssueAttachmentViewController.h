//
//  HANewIssueAttachmentViewController.h
//  HelpApp
//
//  Created by Santhana Amuthan on 05/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSViewController.h"

/**
    HSNewIssueAttachmentViewController is responsible for showing the attachment selected in report issue screen
 */

@interface HSNewIssueAttachmentViewController : HSViewController

@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (nonatomic, strong) UIImage *attachmentImage;

@end
