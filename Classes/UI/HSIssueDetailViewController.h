//  TicketDetailViewController.h
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

#import <UIKit/UIKit.h>
#import "HSTicket.h"
#import "HSGrowingTextView.h"
#import "HSTicketSource.h"
#import "HSViewController.h"
#import "HSButton.h"
#import <DBChooser/DBChooser.h>
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
@property (nonatomic, assign) float bubbleWidth;
@property (strong, nonatomic) IBOutlet HSGrowingTextView *messageText;
@property (weak, nonatomic) IBOutlet UIView *messageTextSuperView;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)sendReply:(id)sender;
- (IBAction)addAttachment:(id)sender;
- (void)scrollDownToLastMessage:(BOOL)animated;

@end
