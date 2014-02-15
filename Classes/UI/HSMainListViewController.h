//
//  HAZendDeskMainViewController.h
//  HelpApp
//
//  Created by Tenmiles on 22/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

/**
    This TableViewController class is responsible for showing the first list view screen, it shows the list of 
    KB Articles/Sections and earlier reported issues if any. 

 */

#import "HSTableViewController.h"

@interface HSMainListViewController : HSTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@end
