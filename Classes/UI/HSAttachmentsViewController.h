//
//  HAAttachmentsViewController.h
//  HelpApp
//
//  Created by Santhana Amuthan on 04/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSViewController.h"

/**
    HSAttachmentsViewController class is used to show the attachments of Issues, if any
 */
@interface HSAttachmentsViewController : HSViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *url;

@end
