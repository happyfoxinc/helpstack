//  HAiPadTicketDetailViewController.m
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

#import "HSTicketDetailViewControlleriPad.h"

@interface HSTicketDetailViewControlleriPad ()
{
    NSString *msgEntered;

}


@end

@implementation HSTicketDetailViewControlleriPad


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
    super.bubbleWidth = 270.0;
    msgEntered = nil;
    
	// Do any additional setup after loading the view.
}

- (void)addMessageView{
    
    self.messageText = [[HSGrowingTextView alloc] initWithFrame:CGRectMake(57, 5, 420, 42)];
    self.messageText.isScrollable = NO;
    self.messageText.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	self.messageText.minNumberOfLines = 1;
	self.messageText.maxNumberOfLines = 10;
    self.messageText.maxHeight = 200.0f;
	self.messageText.returnKeyType = UIReturnKeyGo; //just as an example
	self.messageText.font = [UIFont systemFontOfSize:14.0f];
	self.messageText.delegate = self;
    self.messageText.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.messageText.backgroundColor = [UIColor whiteColor];
    self.messageText.textColor = [UIColor darkGrayColor];
    self.messageText.placeholder = @"Reply here";
    self.messageText.layer.cornerRadius = 5.0;
    [self.bottomMessageView addSubview:self.messageText];
    
}

- (void)growingTextView:(HSGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect msgViewFrame = self.bottomMessageView.frame;
    msgViewFrame.size.height -= diff;
    msgViewFrame.origin.y += diff;
    
    self.messageText.frame = growingTextView.frame;
    
    UIEdgeInsets contentInsets = self.chatTableView.contentInset;
    if(contentInsets.bottom == 0 && diff > 0) {   //This change for ipad
        self.bottomMessageView.frame = msgViewFrame;
        return;
    }
    contentInsets.bottom-=diff;
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    [self scrollDownToLastMessage:YES];
    
	self.bottomMessageView.frame = msgViewFrame;
}

#pragma mark - Handle keyboard delegate

- (void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.bottomMessageView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.bottomMessageView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    [self scrollDownToLastMessage:YES];
}

- (void)keyboardFrameWillChange: (NSNotification *)notification {

    NSDictionary* info = [notification userInfo];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.bottomMessageView.frame;
    
    float originalMessageOrigin = containerFrame.origin.y;
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        containerFrame.origin.y = kKeyBoardFrame.origin.y - containerFrame.size.height - 256;
    }
    else  {
        // On ios 7 landscape x == ios 8 landscape y
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            containerFrame.origin.y = kKeyBoardFrame.origin.y - containerFrame.size.height - 64;
        }
        else {
            containerFrame.origin.y = kKeyBoardFrame.origin.y - containerFrame.size.height - 50;
        }
    }
    
    NSInteger keyboardHeightDiff = containerFrame.origin.y - originalMessageOrigin;
    
    UIEdgeInsets contentInsets = self.chatTableView.contentInset;
    
    // On ios 7 landscape x == ios 8 landscape y
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0 && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        if(kKeyBoardFrame.origin.x > 0) {
            contentInsets.bottom-=keyboardHeightDiff;
        }
    }
    else {
        if(kKeyBoardFrame.origin.y > 0) {
            contentInsets.bottom -= keyboardHeightDiff;
        }
    }
    
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    [self scrollDownToLastMessage:YES];
    
    self.bottomMessageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.bottomMessageView.translatesAutoresizingMaskIntoConstraints = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.bottomMessageView.frame = containerFrame;
    
    [UIView commitAnimations];
}


#pragma mark - Handle orientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
   
    msgEntered = self.messageText.text;
    self.messageText.text = @"";
    self.messageText.placeholder = @"";
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    if(msgEntered) {
        self.messageText.text = msgEntered;
        msgEntered = nil;
    }
    self.messageText.placeholder = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


