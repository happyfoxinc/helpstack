//
//  HSTableViewController.h
//  HelpApp
//
//  Created by Anand on 18/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSKBSource.h"
#import "HSTicketSource.h"
#import "HSHelpStack.h"

@interface HSTableViewController : UITableViewController



#pragma mark - Placeholders
@property (nonatomic, strong) HSGear* gear;

@property (nonatomic, strong) HSKBSource* kbSource;
@property (nonatomic, strong) HSTicketSource* ticketSource;


@end
