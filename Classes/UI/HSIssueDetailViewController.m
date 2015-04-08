//  TicketDetailViewController.m
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


#import "HSIssueDetailViewController.h"
#import "HSAttachment.h"
#import "HSHelpStack.h"
#import "HSAttachmentsViewController.h"
#import "HSAttachmentsListViewController.h"
#import "HSChatBubbleLeft.h"
#import "HSChatBubbleRight.h"
#import "HSLabel.h"
#import "HSSmallLabel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HSEditImageViewController.h"

@interface HSIssueDetailViewController ()<HSEditImageViewControllerDelegate> {
    
}

@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSString *enteredMsg;
@property (nonatomic) CGRect messageFrame;
@property UIStatusBarStyle currentStatusBarStyle;

@property UIImagePickerController *imagePickerViewController;
@property HSEditImageViewController *editImageViewController;

@end

@implementation HSIssueDetailViewController

NSInteger attachmentButtonTagOffset = 1000;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.bubbleWidth = 240.0;
    
    self.chatTableView.backgroundColor = [UIColor clearColor];
    
    [self.loadingIndicator startAnimating];
    
    self.bottomMessageView.hidden = YES;
    self.sendReplyIndicator.hidden = YES;
    self.sendButton.enabled = NO;
    self.sendButton.alpha = 0.5;
    self.currentStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    self.navigationItem.title = self.selectedTicket.subject;
    
    /**
     Single tapping anywhere on the chat table view to hide the keyboard
     */
    UITapGestureRecognizer *hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    hideKeyboard.numberOfTapsRequired = 1;
    [self.chatTableView addGestureRecognizer:hideKeyboard];
    
    [self getTicketUpdates];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:self.currentStatusBarStyle];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.enteredMsg){
        self.messageText.text = self.enteredMsg;
        self.enteredMsg = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    /**
     To detect when user is sliding the screen to go back - iOS7 feature
     */
    if([self isMovingFromParentViewController]){
        self.messageText.text = @"";
        [self.messageText resignFirstResponder];
        [self removeInsetsOnChatTable];
    }
}


#pragma marks - View populating methods

- (void)addMessageView {
    //  self.messageText = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(35, 6, self.messageTextSuperView.frame.size.width, 40)];
    if(!self.messageText){
        self.messageText = [[HSGrowingTextView alloc] initWithFrame:CGRectMake(self.messageTextSuperView.frame.origin.x, self.messageTextSuperView.frame.origin.y, self.messageTextSuperView.frame.size.width, self.messageTextSuperView.frame.size.height)];
        self.messageText.editable = YES;
    }else{
        CGRect msgTextFrame = self.messageText.frame;
        msgTextFrame.size.width = self.messageTextSuperView.frame.size.width;
        msgTextFrame.size.height = self.messageTextSuperView.frame.size.height;
        self.messageText.frame = msgTextFrame;
    }
    self.messageText.isScrollable = NO;
    self.messageText.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.messageText.minNumberOfLines = 1;
    self.messageText.maxNumberOfLines = 10;
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(currentOrientation)){
        self.messageText.maxHeight = 50.0f;
    }else{
        self.messageText.maxHeight = 200.0f;
    }
    
    self.messageText.returnKeyType = UIReturnKeyGo;
    self.messageText.font = [UIFont systemFontOfSize:14.0f];
    self.messageText.delegate = self;
    self.messageText.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
    self.messageText.textColor = [UIColor darkGrayColor];
    
    if([[self ticketSource] draftReplyMessage]!=nil) {
        self.messageText.text = [[self ticketSource] draftReplyMessage];
    }
    else {
        self.messageText.text = @"";
        self.messageText.placeholder = @"Reply here";
    }
    
    self.messageText.internalTextView.layer.cornerRadius = 5.0;
    //  [self.messageTextSuperView addSubview:self.messageText];
    [self.messageText removeFromSuperview];
    [self.bottomMessageView addSubview:self.messageText];
    
    self.sendButton.titleLabel.textColor = [UIColor darkGrayColor];
}

/**
 Callback method whenever the messageTextView increases in size, accordingly push the chat tableView up
 */
- (void)growingTextView:(HSGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect msgViewFrame = self.bottomMessageView.frame;
    msgViewFrame.size.height -= diff;
    msgViewFrame.origin.y += diff;
    
    self.messageText.frame = growingTextView.frame;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.chatTableView.contentInset.bottom - diff , 0.0);
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    [self scrollDownToLastMessage:YES];
    
    self.bottomMessageView.frame = msgViewFrame;
    
}

-(void)growingTextViewDidChange:(HSGrowingTextView *)growingTextView{
    if([growingTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0){
        self.sendButton.enabled = YES;
        self.sendButton.alpha = 1.0;
        
        [self.ticketSource saveReplyDraft:growingTextView.text];
    }else{
        self.sendButton.enabled = NO;
        self.sendButton.alpha = 0.5;
    }
}

-(void)growingTextViewDidEndEditing:(HSGrowingTextView *)growingTextView{
    
    if([growingTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0){
        self.sendButton.enabled = YES;
        self.sendButton.alpha = 1.0;
    }else{
        self.sendButton.enabled = NO;
        self.sendButton.alpha = 0.5;
    }
}

-(void)removeInsetsOnChatTable{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0 , 0.0);
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    [self scrollDownToLastMessage:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self removeInsetsOnChatTable];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // [self.chatTableView reloadData];
    CGRect msgTextFrame = self.messageText.frame;
    msgTextFrame.size.width = self.messageTextSuperView.frame.size.width;
    msgTextFrame.size.height = self.messageTextSuperView.frame.size.height;
    self.messageText.frame = msgTextFrame;
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(currentOrientation)){
        self.messageText.maxHeight = 50.0f;
    }else{
        self.messageText.maxHeight = 200.0f;
    }
    
    NSString *msgAdded = self.messageText.text;
    self.messageText.text = msgAdded;
    
    [self.messageText setNeedsDisplay];
    [self.messageText.internalTextView setNeedsDisplay];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [[HSAppearance instance] customizeNavigationBar:viewController.navigationController.navigationBar];
}

#pragma mark - Attachment functions

/**
 Shows the attachment selected when adding a reply
 */
- (void)showAttachments{
    
    if(self.attachments.count == 0){
        self.messageText.internalTextView.inputAccessoryView = nil;
        [self.messageText.internalTextView reloadInputViews];
        UIImage *attachImage = [UIImage imageNamed:@"attach.png"];
        [self.addAttachmentButton setImage:attachImage forState:UIControlStateNormal];
    }else{
        HSAttachment *attachment = [self.attachments objectAtIndex:0];
        [self.addAttachmentButton setImage:attachment.attachmentImage forState:UIControlStateNormal];
    }
}

- (IBAction)addAttachment:(id)sender{
    
    if(self.attachments == nil || self.attachments.count == 0){
        [self openImagePicker];
    }else{
        //Show UIAction sheet menu
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Change",
                                @"Delete",
                                nil];
        if ([HSAppearance isIPad]) {
            [popup showFromRect:[self.addAttachmentButton bounds] inView:self.addAttachmentButton animated:YES];
        }
        else {
            [popup showInView:[self.navigationController view]];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch(buttonIndex){
        case 0:
            [self openImagePicker];
            break;
        case 1:
            [self.attachments removeAllObjects];
            [self showAttachments];
            break;
        case 2:
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        default:break;
    }
}

- (void)openImagePicker {
    
    self.enteredMsg = self.messageText.text;
    self.messageText.text = @"";
    [self.messageText resignFirstResponder];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if(self.attachments == nil){
        self.attachments = [[NSMutableArray alloc] init];
    }
    
    [self.attachments removeAllObjects]; // we are handling only 1 attachment for now.
    [self showAttachments];
    
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];

    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *assetRep = [imageAsset defaultRepresentation];
        CGImageRef cgImg = [assetRep fullResolutionImage];

        HSEditImageViewController *editImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditImage"];
        editImageViewController.attachmentImage = [UIImage imageWithCGImage:cgImg];
        [editImageViewController setDelegate:self];

        _imagePickerViewController = picker;
        [picker pushViewController:editImageViewController animated:YES];
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imagePath resultBlock:resultblock failureBlock:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.messageText.text = self.enteredMsg;
}

- (void)editImageViewController:(HSEditImageViewController *)controller didFinishEditingImage:(NSURL *)imageURL {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if(self.attachments == nil){
        self.attachments = [[NSMutableArray alloc] init];
    }
    
    [self.attachments removeAllObjects]; // handling only one attachments
    [self showAttachments];

    
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
        
        [self showAttachments];
        
        [self.messageText becomeFirstResponder];
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
}


- (void)openAttachment:(UIButton *)sender{
    
    NSInteger sectionID = sender.tag-attachmentButtonTagOffset;
    HSUpdate* updateToShow = [self.ticketSource updateAtPosition:sectionID];
    if(updateToShow.attachments && updateToShow.attachments.count > 0){
        if(updateToShow.attachments.count > 1){
            [self performSegueWithIdentifier:@"showAttachments" sender:updateToShow.attachments];
        }else{
            [self performSegueWithIdentifier:@"showOneAttachment" sender:updateToShow.attachments];
        }
    }
}

#pragma mark - Keyboard functions

- (void)hideKeyboard{
    [self.messageText resignFirstResponder];
}


/**
 On keyboard Hide, restore the tableview and messageTextView frames
 */
-(void) keyboardWillHide:(NSNotification *)note{
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
        containerFrame.origin.y = kKeyBoardFrame.origin.y - containerFrame.size.height - 64;
    }
    else {
        // On ios 7 landscape x == ios 8 landscape y
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            containerFrame.origin.y = kKeyBoardFrame.origin.y - containerFrame.size.height - 32;
        }
        else {
            containerFrame.origin.y = kKeyBoardFrame.origin.x - containerFrame.size.height - 50;
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
            contentInsets.bottom-=keyboardHeightDiff;
        }
    }
    
    self.chatTableView.contentInset = contentInsets;
    self.chatTableView.scrollIndicatorInsets = contentInsets;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.bottomMessageView.frame = containerFrame;
    
    [UIView commitAnimations];
    [self scrollDownToLastMessage:YES];
}


#pragma mark - Ticket fetch and update functions

-(void)getTicketUpdates{
    
    [self.ticketSource prepareUpdate:self.selectedTicket success:^{
        self.bottomMessageView.hidden = NO;
        [self addMessageView];
        [self.loadingIndicator stopAnimating];
        self.loadingIndicator.hidden = YES;
        [self.chatTableView reloadData];
        [self scrollDownToLastMessage:NO];
    } failure:^(NSError* e){
        self.bottomMessageView.hidden = NO;
        [self.loadingIndicator stopAnimating];
        self.loadingIndicator.hidden = YES;
        [self addMessageView];
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldnt get replies" message:@"There was some error loading the replies. Please check if your internet connection is ON." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
    }];
}

-(void)updateTicket:(NSString *)ticketMessage{
    
    HSTicketReply *tickUpdate = [[HSTicketReply alloc] init];
    tickUpdate.content = self.messageText.text;
    if(self.attachments != nil && self.attachments.count > 0){
        tickUpdate.attachments = self.attachments;
    }
    self.sendButton.hidden = YES;
    self.sendReplyIndicator.hidden = NO;
    [self.sendReplyIndicator startAnimating];
    [self.messageText resignFirstResponder];
    HSIssueDetailViewController *weakSelf = self;
    
    [self.ticketSource addReply:tickUpdate ticket:self.selectedTicket success:^{
        [weakSelf onTicketUpdated];
    }failure:^(NSError* e){
        [weakSelf onTicketUpdateFailed];
    }];
}

-(void)onTicketUpdated{
    [self.sendReplyIndicator stopAnimating];
    self.sendReplyIndicator.hidden = YES;
    self.sendButton.hidden = NO;
    [self.attachments removeAllObjects];
    [self showAttachments];
    [self.chatTableView reloadData];
    self.messageText.text = @"";
    [self.messageText resignFirstResponder];
    [self removeInsetsOnChatTable];
}

-(void)onTicketUpdateFailed{
    [self.sendReplyIndicator stopAnimating];
    self.sendReplyIndicator.hidden = YES;
    self.sendButton.hidden = NO;
    [self removeInsetsOnChatTable];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops! Some error." message:@"There was some error in sending your reply. Is your internet ON? Can you try after sometime?" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.ticketSource updateCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 2){
        UITableViewCell *cell = [self getInfoCellForTable:tableView forIndexPath:indexPath];
        return cell;
    }else if(indexPath.row == 1){
        UITableViewCell *cell = [self getMessageCellForTable:tableView forIndexPath:indexPath];
        return cell;
    }else{
        UITableViewCell *cell = [self getSenderInfoCellForTable:tableView forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2 || indexPath.row == 0){
        return 32.0;
    }
    HSUpdate* updateToShow = [self.ticketSource updateAtPosition:indexPath.section];
    NSString *messageText = updateToShow.content;
    
    if(messageText.length > 0){
        UIFont *bubbleTextFont = [[[HSHelpStack instance] appearance] getBubbleTextFont];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         bubbleTextFont, NSFontAttributeName,
                                         [UIColor blackColor], NSForegroundColorAttributeName,
                                         nil];
        
        NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:messageText attributes:attrsDictionary];
        CGSize maximumLabelSize = CGSizeMake(self.bubbleWidth - 20, CGFLOAT_MAX);
        CGRect newTextSize = [msgText boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        return newTextSize.size.height + 15;
    }
    return 50.0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.chatTableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    HSUpdate* updateToShow = [self.ticketSource updateAtPosition:indexPath.section];
    if(updateToShow.attachments != nil && updateToShow.attachments.count > 0){
        [self performSegueWithIdentifier:@"showAttachments" sender:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.chatTableView.frame.size.width, 5.0)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)refreshCell:(UITableViewCell *)cell{
    
    UILabel *senderLabel = (UILabel *)[cell viewWithTag:1];
    UITextView *messageLabel = (UITextView *)[cell viewWithTag:2];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:3];
    UIView *messageView = (UIView *)[cell viewWithTag:4];
    UILabel *attachmentLabel = (UILabel *)[cell viewWithTag:5];
    
    if(senderLabel){
        [senderLabel removeFromSuperview];
    }
    
    if(messageLabel){
        [messageLabel removeFromSuperview];
    }
    
    if(timeLabel){
        [timeLabel removeFromSuperview];
    }
    
    if(messageView){
        [messageView removeFromSuperview];
    }
    
    if(attachmentLabel){
        [attachmentLabel removeFromSuperview];
    }
}

-(UITableViewCell *)getInfoCellForTable:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    HSUpdate* updateToShow = [self.ticketSource updateAtPosition:indexPath.section];
    static NSString *CellIdentifier; // = @"InfoCell";
    
    if(updateToShow.updateType == HATypeStaffReply) {
        CellIdentifier = @"MessageDetails_Left";
    }else {
        CellIdentifier = @"MessageDetails_Right";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *cellView = [cell viewWithTag:3];
    NSArray *subviews = [cellView subviews];
    for(UIView *view in subviews){
        [view removeFromSuperview];
    }
    
    cellView.backgroundColor = [UIColor clearColor];
    HSSmallLabel *timestamp = [[HSSmallLabel alloc] initWithFrame:CGRectMake(cellView.frame.size.width - 120.0, -6.0, 120.0, 20.0)];
    timestamp.font = [UIFont fontWithName:timestamp.font.fontName size:10.0];
    timestamp.textAlignment = NSTextAlignmentRight;
    timestamp.text =   [updateToShow updatedAtString];
    [cellView addSubview:timestamp];
    
    if(updateToShow.attachments != nil && updateToShow.attachments.count > 0){
        UIButton *attachmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0, 25.0)];
        UIImage *btnImage = [UIImage imageNamed:@"attach.png"];
        [attachmentBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [attachmentBtn setTag:attachmentButtonTagOffset+indexPath.section];
        [attachmentBtn addTarget:self action:@selector(openAttachment:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:attachmentBtn];
    }
    [cell.contentView addSubview:cellView];
    return cell;
}

-(UITableViewCell *)getMessageCellForTable:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    HSUpdate* updateToShow = [self.ticketSource updateAtPosition:indexPath.section];
    static NSString *CellIdentifier; // = @"MessageCell";
    
    if(updateToShow.updateType == HATypeStaffReply) {
        CellIdentifier = @"MessageCell_Left";
    }else {
        CellIdentifier = @"MessageCell_Right";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIView *messageView;
    UITextView *messageTextView;
    
    messageView = [cell viewWithTag:3];
    CGRect bubbleFrame = messageView.frame;
    bubbleFrame.size.height = cell.frame.size.height;
    messageView.frame = bubbleFrame;
    
    if(updateToShow.updateType == HATypeStaffReply){
        messageTextView = [((HSChatBubbleLeft *)messageView) getChatTextView];
    }else{
        messageTextView = [((HSChatBubbleRight *)messageView) getChatTextView];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    NSString *messageContent = [updateToShow content];
    if([messageContent stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        messageContent = @"No Message";
        messageTextView.textColor = [UIColor grayColor];
        messageTextView.font = [UIFont fontWithName:messageTextView.font.fontName size:12.0];
    }
    
    messageTextView.text = messageContent;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(UITableViewCell *)getSenderInfoCellForTable:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    HSUpdate* updateToShow = [self.ticketSource updateAtPosition:indexPath.section];
    
    static NSString *CellIdentifier; // = @"MessageDetails_Right";
    
    if(updateToShow.updateType == HATypeStaffReply) {
        CellIdentifier = @"InfoCell_Left";
    }else {
        CellIdentifier = @"InfoCell_Right";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *cellView = [cell viewWithTag:3];
    NSArray *subviews = [cellView subviews];
    for(UIView *view in subviews){
        [view removeFromSuperview];
    }
    
    HSSmallLabel *nameLabel = [[HSSmallLabel alloc] init];
    nameLabel.tag = 1;
    
    NSString *nameString = @"";
    nameLabel.frame = CGRectMake(0, 4.0, 120.0, 20.0);
    if(updateToShow.updateType == HATypeStaffReply){
        if(updateToShow.from){
            nameString = updateToShow.from;
        }else{
            nameString = @"Staff";
        }
    }else{
        nameString = @"Me";
    }
    [cellView addSubview:nameLabel];
    //Overriding timestamp font and size
    nameLabel.font = [UIFont fontWithName:nameLabel.font.fontName size:10.0];
    nameLabel.text = nameString;
    
    return cell;
}

/**
 Scrolls the table view to the last item
 */
- (void)scrollDownToLastMessage:(BOOL)animated
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    if([self.chatTableView numberOfSections] > 0){
        [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

/**
 Gets the last index path of the table view
 */
- (NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.chatTableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.chatTableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

- (IBAction)sendReply:(id)sender{
    NSString *replyMsg = self.messageText.text;
    [self updateTicket:replyMsg];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSArray *attachments = sender;
    if(attachments.count > 1){
        HSAttachmentsListViewController *viewController = (HSAttachmentsListViewController *)[segue destinationViewController];
        viewController.attachmentsList = attachments;
    }else if(attachments.count == 1){
        HSAttachmentsViewController *attachmentsVC = (HSAttachmentsViewController *)[segue destinationViewController];
        HSAttachment *attachment = [attachments objectAtIndex:0];
        attachmentsVC.attachment = attachment;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

