//
//  HAIPadZendDeskNewIssueViewController.m
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSNewIssueViewControlleriPad.h"

@interface HSNewIssueViewControlleriPad ()

@end

@implementation HSNewIssueViewControlleriPad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        return 44.0;
    }
    else if(indexPath.row == 1) {
        return 262.0;
    }
    else if(indexPath.row == 2) {
        return 44.0;
    }
    
    return 0.0;
}

@end
