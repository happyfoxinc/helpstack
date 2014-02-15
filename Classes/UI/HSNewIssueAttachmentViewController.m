//
//  HANewIssueAttachmentViewController.m
//  HelpApp
//
//  Created by Santhana Amuthan on 05/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSNewIssueAttachmentViewController.h"

@interface HSNewIssueAttachmentViewController ()

@end

@implementation HSNewIssueAttachmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.attachmentImageView setImage:self.attachmentImage];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
