//
//  HAZendDeskReportViewController.h
//  HelpApp
//
//  Created by Tenmiles on 22/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSNewTicket.h"
#import "HSTicketSource.h"
#import "HSTableViewController.h"

/**
    HSNewIssueViewController is reponsible for showing the reportIssue screen
 */

@protocol HSNewIssueViewControllerDelegate;

@interface HSNewIssueViewController : HSTableViewController

@property (nonatomic, weak) id<HSNewIssueViewControllerDelegate> delegate;
@property (nonatomic, strong) HSNewTicket* createNewTicket;

@end

@protocol HSNewIssueViewControllerDelegate <NSObject>

- (void)onNewIssueRequested:(HSNewTicket *)createNewTicket;

@end
