//
//  HAZenDeskNewNameViewController.h
//  HelpApp
//
//  Created by Tenmiles on 25/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSNewIssueViewController.h"
#import "HSNewTicket.h"

/** 
    HSUserDetailsViewController is loaded when a new user wants to report an issue, 
    to get the user details - User name and User Email
 */

@interface HSUserDetailsViewController : HSTableViewController <UIAlertViewDelegate>


@property (nonatomic, strong) id<HSNewIssueViewControllerDelegate> delegate;
@property (nonatomic, strong) HSNewTicket* createNewTicket;

@end
