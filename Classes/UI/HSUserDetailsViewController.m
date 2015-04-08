//  HAZenDeskNewNameViewController.m
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

#import "HSUserDetailsViewController.h"
#import "HSHelpStack.h"
#import "HSActivityIndicatorView.h"
#import "HSUtility.h"

@interface HSUserDetailsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;


@property (strong, nonatomic) UIBarButtonItem* nextButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;

@end

@implementation HSUserDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitPressed:)];
    self.navigationItem.rightBarButtonItem = self.nextButtonItem;
    
    HSAppearance* appearance = [[HSHelpStack instance] appearance];
    self.view.backgroundColor = [appearance getBackgroundColor];
    
    self.title = @"Creating New Issue";
    
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _emailField.delegate = self;
    
    [_firstNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_lastNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if([[self ticketSource] draftUserFirstName]!=nil) {
        _firstNameField.text = [[self ticketSource] draftUserFirstName];
    }
    
    if([[self ticketSource] draftUserLastName]!=nil) {
        _lastNameField.text = [[self ticketSource] draftUserLastName];
    }
    
    if([[self ticketSource] draftUserEmail]!=nil) {
        _emailField.text = [[self ticketSource] draftUserEmail];
    }
}

- (IBAction)submitPressed:(id)sender
{
    if([self checkValidity]) {
        
        [self.delegate registerUserAndCreateTicket:self.createNewTicket forUserFirstName:self.firstNameField.text lastName:self.lastNameField.text email:self.emailField.text];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger cancelButtonIndex = [alertView cancelButtonIndex];
    if (cancelButtonIndex != -1 && cancelButtonIndex == buttonIndex) {
        [self cancelPressed:nil];
    }
}

- (IBAction)cancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*Validates the email address entered by the user */
- (BOOL)checkValidity {
    
    if(self.firstNameField.text ==nil || self.firstNameField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Missing First Name" message:@"Please give your first name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    if(self.lastNameField.text ==nil || self.lastNameField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Missing Last Name" message:@"Please give your last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    if(self.emailField.text == nil || self.emailField.text.length == 0 || ![HSUtility isValidEmail:self.emailField.text]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Missing Email" message:@"Please give your valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}


- (void)startIssueReportController {
    HSNewIssueViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HSReportIssue"];
    controller.createNewTicket = self.createNewTicket;
    controller.delegate = self.delegate;
    controller.ticketSource = self.ticketSource;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.firstNameField) {
        [self.lastNameField becomeFirstResponder];
        return YES;
    }else if (textField == self.lastNameField){
        [self.emailField becomeFirstResponder];
        return YES;
    }else if(textField == self.emailField) {
        [self submitPressed:nil];
        return YES;
    }
    
    return NO;
}


- (void)textFieldDidChange:(UITextField *)textField {
    [self.ticketSource saveUserDraft:self.firstNameField.text lastName:self.lastNameField.text email:self.emailField.text];
}


@end
