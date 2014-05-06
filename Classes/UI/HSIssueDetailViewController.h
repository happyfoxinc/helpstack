//
//  TicketDetailViewController.h
//  HelpApp
//
//  Created by Santhana Amuthan on 22/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTicket.h"
#import "HSGrowingTextView.h"
#import "HSTicketSource.h"
#import "HSViewController.h"
#import "HSButton.h"
/**
    HSIssueDetailViewController class is responsible for showing up the issue details where the user can also update or reply back
 */

@interface HSIssueDetailViewController : HSViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, HPGrowingTextViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) HSTicketSource* ticketSource;
@property (nonatomic, strong, readwrite) HSTicket* selectedTicket;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomMessageView;
@property (weak, nonatomic) IBOutlet HSButton *sendButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendReplyIndicator;
@property (weak, nonatomic) IBOutlet UIButton *addAttachmentButton;
//@property (nonatomic, strong) HPGrowingTextView *messageText;
@property (nonatomic, assign) float bubbleWidth;
@property (strong, nonatomic) IBOutlet HSGrowingTextView *messageText;
@property (weak, nonatomic) IBOutlet UIView *messageTextSuperView;

- (IBAction)sendReply:(id)sender;
- (IBAction)addAttachment:(id)sender;
- (void)scrollDownToLastMessage;

@end
