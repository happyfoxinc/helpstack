//  HSTableViewController.m
//
//Copyright (c) 2014 HelpStack (http://helpstack.io)
//
//Permission is hereby granted, free of charge, to any person obtaining a cop
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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
