//
//  HAiPadTicketDetailViewController.m
//  HelpApp
//
//  Created by Santhana Amuthan on 12/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTicketDetailViewControlleriPad.h"

@interface HSTicketDetailViewControlleriPad ()

@end

@implementation HSTicketDetailViewControlleriPad

float keyboardH;

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
    super.bubbleWidth = 350.0;
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

#pragma mark - Handle keyboard delegate

- (void) keyboardWillShow:(NSNotification *)note{
    CGRect formsheetFrame = self.navigationController.view.bounds;
    CGRect viewFrame = [UIScreen mainScreen].bounds;
    CGPoint centreP = CGPointMake(viewFrame.size.width/2, viewFrame.size.height/2);
    
    float bottomspace = 0;
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(currentOrientation)){
        float topspace = centreP.x - (formsheetFrame.size.width/2);
        bottomspace = viewFrame.size.width - topspace - formsheetFrame.size.width;
        
    }else{
        float topspace = centreP.y - (formsheetFrame.size.height/2);
        bottomspace = viewFrame.size.height - topspace - formsheetFrame.size.height;
    }
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

    keyboardH = keyboardBounds.size.height - bottomspace;
    // get a rect for the textView frame
	CGRect containerFrame = self.bottomMessageView.frame;
    
    if (UIInterfaceOrientationIsLandscape(currentOrientation)){
         containerFrame.origin.y = self.view.bounds.size.height - (keyboardH + containerFrame.size.height) + 14.0;
    }else{
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardH + containerFrame.size.height) - 10.0;
    }
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardH, 0.0);
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    [super scrollDownToLastMessage];
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.bottomMessageView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.bottomMessageView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
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
    [super scrollDownToLastMessage];
}

#pragma mark - Handle orientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if([self.messageText isFirstResponder]){
        [self.messageText resignFirstResponder];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
   // [self.messageText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


