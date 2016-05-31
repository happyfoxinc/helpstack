//  HAZendDeskReportViewController.m
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

#import "HSNewIssueViewController.h"
#import "HSTextViewInternal.h"
#import "HSUserDetailsViewController.h"
#import "HSHelpStack.h"
#import "HSAttachment.h"
#import "HSNewIssueAttachmentViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HSTableFooterCreditsView.h"
#import "HSUtility.h"
#import "HSEditImageViewController.h"

@interface HSNewIssueViewController ()<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, HSEditImageViewControllerDelegate> {
    
    UITextField* subjectField;
    HSTextViewInternal* messageField;
    UIButton *attachmentImageBtn;
    UIBarButtonItem* submitBarItem;
}

@property (nonatomic, strong) UIView *messageAttachmentView;
@property (nonatomic, strong) UIButton *addAttachment;
@property (nonatomic, strong) NSMutableArray *attachments;
@property UIStatusBarStyle currentStatusBarStyle;

@property UIImagePickerController *imagePickerViewController;
@property HSEditImageViewController *editImageViewController;

@end

@implementation HSNewIssueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.ticketSource shouldShowUserDetailsFormWhenCreatingTicket]) {
        submitBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextPressed:)];
        self.navigationItem.rightBarButtonItem = submitBarItem;
    }
    else {
        submitBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitPressed:)];
        self.navigationItem.rightBarButtonItem = submitBarItem;
    }
    
    HSAppearance* appearance = [[HSHelpStack instance] appearance];
    self.view.backgroundColor = [appearance getBackgroundColor];
    
    self.currentStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [subjectField setText:[self.ticketSource draftSubject]];
    [messageField setText:[self.ticketSource draftMessage]];
    
    [self addCreditsToTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:self.currentStatusBarStyle];
}

- (void)addCreditsToTable {
    if ([[HSHelpStack instance] showCredits]) {
        HSTableFooterCreditsView* footerView = [[HSTableFooterCreditsView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        self.tableView.tableFooterView = footerView;
    }
}

-(void)setInputAccessoryView{
    self.messageAttachmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAttachments:(id)sender {
    if(self.attachments != nil && self.attachments.count > 0){
        
        //remove attachment.
        
        self.attachments = nil;
    }else{
        
        //add attachment.
        
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];
    }
}

- (IBAction)nextPressed:(id)sender {
    NSString* storyboardId = @"HSUserDetailsController";
    if ([HSAppearance isIOS6]) {
        storyboardId = @"HSUserDetailsController_ios6";
    }
    
    HSNewTicket* ticket = [[HSNewTicket alloc] init];
    
    if([self checkValidity]) {
        
        NSMutableString* messageContent = [[NSMutableString alloc] initWithString:messageField.text];
        [messageContent appendString:[HSUtility deviceInformation]];
        
        ticket.subject = subjectField.text;
        ticket.content = messageContent;
        ticket.attachments = self.attachments;
        HSUserDetailsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
        controller.createNewTicket = ticket;
        controller.delegate = self.delegate;
        controller.ticketSource = self.ticketSource;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)submitPressed:(id)sender {
    //Validate for name, email, subject and message
    
    UIBarButtonItem* submitButton = sender;
    if([self checkValidity]) {
        submitButton.enabled = NO;
        
        NSMutableString* messageContent = [[NSMutableString alloc] initWithString:messageField.text];
        [messageContent appendString:[HSUtility deviceInformation]];
        
        self.createNewTicket.subject = subjectField.text;
        self.createNewTicket.content = messageContent;
        self.createNewTicket.attachments = self.attachments;
        
        [self.delegate onNewIssueRequested:self.createNewTicket];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) checkValidity {
    if(subjectField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Missing Subject" message:@"Please enter a subject" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    if(messageField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Missing Message" message:@"Please enter a message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HSAttachment *attachment = [self.attachments objectAtIndex:0];
    
    HSNewIssueAttachmentViewController *attachmentsView = (HSNewIssueAttachmentViewController *)[segue destinationViewController];
    attachmentsView.attachmentImage = attachment.attachmentImage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SubjectCellIdentifier = @"Cell_Subject";
    static NSString *MessageCellIdentifier = @"Cell_Message";
    if(indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubjectCellIdentifier forIndexPath:indexPath];
        
        subjectField = (UITextField*) [cell viewWithTag:11];
        subjectField.delegate = self;
        
        if([[self ticketSource] draftSubject] != nil) {
            subjectField.text = [[self ticketSource] draftSubject];
        }
        
        [subjectField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        attachmentImageBtn = (UIButton *) [cell viewWithTag:2];
        [attachmentImageBtn addTarget:self action:@selector(handleAttachment) forControlEvents:UIControlEventTouchUpInside];
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [subjectField becomeFirstResponder];
        }
        
        return cell;
    }
    else if(indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier forIndexPath:indexPath];
        messageField = (HSTextViewInternal*) [cell viewWithTag:12];
        
        if([[self ticketSource] draftMessage] != nil) {
            messageField.text = [[self ticketSource] draftMessage];
        }
        
        CGRect messageFrame = messageField.frame;
        messageFrame.size.height = cell.frame.size.height - 40.0;
        messageField.frame = messageFrame;
        messageField.delegate = self;
        return cell;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([HSAppearance isIPad]){
        //For iPad
        if(indexPath.row == 0){
            return 44.0;
        }else if(indexPath.row == 1){
            return self.view.frame.size.height - 44.0;
        }else{
            return 44.0;
        }
    }else{
        if(indexPath.row == 0) {
            return 44.0;
        }
        else if(indexPath.row == 1) {
            float messageHeight;
            //Instead, get the keyboard height and calculate the message field height
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if (UIDeviceOrientationIsLandscape(orientation))
            {
                messageHeight = 68.0;
            }
            else {
                
                if ([HSAppearance isTall]) {
                    messageHeight = 249.0f;
                }else{
                    messageHeight = 155.0f + 44.0;
                }
            }
            // return self.view.bounds.size.height - 88.0;
            return messageHeight;
        }
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[HSAppearance instance] customizeNavigationBar:viewController.navigationController.navigationBar];
}


- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
                              usingDelegate: (id <UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    mediaUI.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == subjectField) {
        [messageField becomeFirstResponder];
        messageField.inputAccessoryView = self.messageAttachmentView;
        return YES;
    }
    
    return NO;
}


- (void)textFieldDidChange:(UITextField *)textField {
    [self.ticketSource saveTicketDraft:subjectField.text message:messageField.text];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.ticketSource saveTicketDraft:subjectField.text message:messageField.text];
}

- (void)handleAttachment {
    if (self.attachments != nil && self.attachments.count > 0) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Change",
                                @"Delete",
                                nil];
        if ([HSAppearance isIPad]) {
            [popup showFromRect:[attachmentImageBtn bounds] inView:attachmentImageBtn animated:YES];
        }
        else {
            [popup showInView:[UIApplication sharedApplication].keyWindow];
        }
        
    } else {
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];
    }
}

- (void)refreshAttachmentsImage {
    if (self.attachments != nil && self.attachments.count > 0) {
        HSAttachment *attachment = [self.attachments objectAtIndex:0];
        [attachmentImageBtn setImage:attachment.attachmentImage forState:UIControlStateNormal];
    } else {
        UIImage *attachImage = [UIImage imageNamed:@"attach.png"];
        [attachmentImageBtn setImage:attachImage forState:UIControlStateNormal];
    }
}

#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:
            [self startMediaBrowserFromViewController: self
                                        usingDelegate: self];
            break;
        case 1:
            [self.attachments removeAllObjects];
            [self refreshAttachmentsImage];
            break;
        case 2:
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        default:break;
    }
}

#pragma mark - UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    if(self.attachments == nil){
        self.attachments = [[NSMutableArray alloc] init];
    }
    
    [self.attachments removeAllObjects]; // handling only one attachments
    [self refreshAttachmentsImage];
    
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];

    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *assetRep = [imageAsset defaultRepresentation];
        
        CGImageRef cgImg = [assetRep fullResolutionImage];
        
        _editImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditImage"];
        _editImageViewController.attachmentImage = [UIImage imageWithCGImage:cgImg];
        [_editImageViewController setDelegate:self];
        
        _imagePickerViewController = picker;
        [_imagePickerViewController pushViewController:_editImageViewController animated:YES];
    };

    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imagePath resultBlock:resultblock failureBlock:nil];
}

- (void)editImageViewController:(HSEditImageViewController *)controller didFinishEditingImage:(NSURL *)imageURL {
    

    [_editImageViewController dismissViewControllerAnimated:YES completion:nil];
    
    if(self.attachments == nil){
        self.attachments = [[NSMutableArray alloc] init];
    }

    [self.attachments removeAllObjects]; // handling only one attachments
    [self refreshAttachmentsImage];
    
    if (imageURL == nil) {
        return;
    }
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *assetRep = [imageAsset defaultRepresentation];
        
        CGImageRef cgImg = [assetRep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:cgImg];
        NSString *filename = [assetRep filename];
        NSData *data = UIImagePNGRepresentation(img);
        
        HSAttachment *attachment = [[HSAttachment alloc] init];
        attachment.fileName = filename;
        attachment.mimeType = @"image/png";
        attachment.attachmentImage = img;
        attachment.attachmentData = data;
        [self.attachments addObject:attachment];
        
        [self refreshAttachmentsImage];
        
        if ([subjectField.text length] == 0) {
            [subjectField becomeFirstResponder];
        }else{
            [messageField becomeFirstResponder];
        }
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
