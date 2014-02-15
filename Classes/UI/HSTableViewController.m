//
//  HSTableViewController.m
//  HelpApp
//
//  Created by Anand on 18/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTableViewController.h"
#import "HSTableViewHeaderCell.h"


@interface HSTableViewController ()


@end

@implementation HSTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    HSAppearance* appearance = [[HSHelpStack instance] appearance];
//    self.view.backgroundColor = [appearance getBackgroundColor];
    [appearance customizeNavigationBar:self.navigationController.navigationBar];
    [appearance customizeTableView:self.tableView];
    
    HSHelpStack* helpStack = [HSHelpStack instance];
    if(!helpStack.gear) {
        HALog(@"No gear found");
    }

    self.gear = helpStack.gear;

    if ([helpStack requiresNetwork]) {
        UIBarButtonItem* noNetworkItem = [[UIBarButtonItem alloc] initWithTitle:@"No Network" style:UIBarButtonItemStylePlain target:nil action:nil];
        [noNetworkItem setTintColor:[UIColor whiteColor]];
        [self setToolbarItems:@[noNetworkItem]];

        UIToolbar* currentToolbar = self.navigationController.toolbar;
        [currentToolbar setBarStyle:UIBarStyleBlackTranslucent];

        UINavigationController* currentNavController = self.navigationController;


        [self.gear.networkManager.reachabilityManager startMonitoring];

        [self.gear.networkManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

            if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
                currentNavController.toolbarHidden = NO;
            }else{
                currentNavController.toolbarHidden = YES;
            }
        }];
    }
}


- (void)noInternetPressed
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
