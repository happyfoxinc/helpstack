//
//  HAAttachmentsViewController.m
//  HelpApp
//
//  Created by Santhana Amuthan on 04/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSAttachmentsViewController.h"

@interface HSAttachmentsViewController ()

@end

@implementation HSAttachmentsViewController

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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
