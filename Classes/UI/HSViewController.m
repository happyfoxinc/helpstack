//
//  HSViewController.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSViewController.h"

@interface HSViewController ()

@end

@implementation HSViewController

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
    HSAppearance* appearance = [[HSHelpStack instance] appearance];
    self.view.backgroundColor = [appearance getBackgroundColor];
    [appearance customizeNavigationBar:self.navigationController.navigationBar];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
