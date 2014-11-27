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
#import "HSMainListViewController.h"
#define drafts 1
@interface HSNewIssueViewController ()<UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    UITextField* subjectField;
    HSTextViewInternal* messageField;
    UIButton *attachmentImageBtn;
    UIBarButtonItem* submitBarItem;
    UIBarButtonItem* backBarItem;
    NSString *sub,*msg;
    
    
}

@property (nonatomic, strong) UIView *messageAttachmentView;
@property (nonatomic, strong) UIButton *addAttachment;
@property (nonatomic, strong) NSMutableArray *attachments;
@property UIStatusBarStyle currentStatusBarStyle;
@property(nonatomic) NSInteger cancelButtonIndex;
@end

@implementation HSNewIssueViewController

int count = 0;
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"drafts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_draftDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS DRAFTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, SUBJECT TEXT, MESSAGE TEXT)";
            
            if (sqlite3_exec(_draftDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(_draftDB);
        } else {
            NSLog(@"Failed to create table");
        }
    }
    
    
    submitBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitPressed:)];
    self.navigationItem.rightBarButtonItem = submitBarItem;
    
    backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    HSAppearance* appearance = [[HSHelpStack instance] appearance];
    self.view.backgroundColor = [appearance getBackgroundColor];
    
    self.currentStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [self addCreditsToTable];
    
    [self GetArticlesCount];
    
    if(count>0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Draft found" message:@"Would you like to use a previouly saved draft?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = drafts;
        [alertView show];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== drafts)
    {
        NSLog(@"Inside Alert View Action method");
        if (buttonIndex == 0)
        {
            NSLog(@"Alert view action method fired 1");
        }
        else
        {
            NSLog(@"Alert view action method fired 2");
            [self usedraft];
        }
    }
}




- (void) GetArticlesCount
{
    
    if (sqlite3_open([self.databasePath UTF8String], &_draftDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM DRAFTS";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(_draftDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_draftDB) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(_draftDB);
    }
    
    
}

- (void) usedraft
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_draftDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT SUBJECT, MESSAGE FROM DRAFTS WHERE ID=(SELECT MAX(ID) from DRAFTS)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_draftDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *sqlsubjectField = [[NSString alloc]
                                             initWithUTF8String:
                                             (const char *) sqlite3_column_text(
                                                                                statement, 0)];
                subjectField.text = sqlsubjectField;
                NSString *sqlmessageField = [[NSString alloc]
                                             initWithUTF8String:(const char *)
                                             sqlite3_column_text(statement, 1)];
                messageField.text = sqlmessageField;
                NSLog(@"SUCCESS");
            } else {
                NSLog(@"FAILED");
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_draftDB);
    }
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

- (IBAction)nextPressed:(id)sender {
    [self performSegueWithIdentifier:@"NameAndEmailSegue" sender:self];
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

- (IBAction)submitPressed:(id)sender {
    //Validate for name, email, subject and message
    
    UIBarButtonItem* submitButton = sender;
    if([self checkValidity]) {
        submitButton.enabled = NO;
        
        NSMutableString* messageContent = [[NSMutableString alloc] initWithString:messageField.text];
        [messageContent appendString:[self deviceInformation]];
        
        self.createNewTicket.subject = subjectField.text;
        self.createNewTicket.content = messageContent;
        self.createNewTicket.attachments = self.attachments;
        
        [self.delegate onNewIssueRequested:self.createNewTicket];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
- (IBAction)backPressed:(id)sender
{
    if ([subjectField.text length] > 0)
    {
        [self.view endEditing:YES];
        [self.view endEditing:YES];
        UIActionSheet *back = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:
                               @"Save as drafts",
                               nil];
        [back showInView:self.view];
        [back setTag:1];
    }
    else
    {
        //[self.navigationController popViewControllerAnimated:TRUE];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}





- (NSString*)deviceInformation
{
    NSString* deviceModel = [[UIDevice currentDevice] model];
    NSString* osVersion = [[UIDevice currentDevice] systemVersion];
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString* bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString* deviceInformation = [NSString stringWithFormat:@"\n\n-----\nDevice Information:\n%@\niOS %@\n\nApp information:\n%@\nVersion %@", deviceModel, osVersion, bundleName, bundleVersion];
    
    return deviceInformation;
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
        
        CGRect messageFrame = messageField.frame;
        messageFrame.size.height = cell.frame.size.height - 40.0;
        messageField.frame = messageFrame;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[HSAppearance instance] customizeNavigationBar:viewController.navigationController.navigationBar];
}


- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
                              usingDelegate: (id <UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>) delegate
{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    mediaUI.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == subjectField)
    {
        [messageField becomeFirstResponder];
        messageField.inputAccessoryView = self.messageAttachmentView;
        return YES;
    }
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    messageField.inputAccessoryView = self.messageAttachmentView;
    [messageField becomeFirstResponder];
}

- (void)handleAttachment
{
    if (self.attachments != nil && self.attachments.count > 0) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Change",
                                @"Delete",
                                nil];
        [popup setTag:2];
        if ([HSAppearance isIPad]) {
            [popup showFromRect:[attachmentImageBtn bounds] inView:attachmentImageBtn animated:YES];
        }
        else {
            [popup showInView:[UIApplication sharedApplication].keyWindow];
        }
        
    } else
    {
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];
    }
    
}

- (void)refreshAttachmentsImage
{
    if (self.attachments != nil && self.attachments.count > 0)
    {
        HSAttachment *attachment = [self.attachments objectAtIndex:0];
        [attachmentImageBtn setImage:attachment.attachmentImage forState:UIControlStateNormal];
        
        
    }
    else
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *attachImage = [UIImage imageNamed:@"attach.png"];
            [attachmentImageBtn setImage:attachImage forState:UIControlStateNormal];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
        UIImage *attachImage = [UIImage imageNamed:@"attach.png"];
        [attachmentImageBtn setImage:attachImage forState:UIControlStateNormal];
        
    }
}

#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(actionSheet.tag)
    {
            
        case 2:
        {
            switch(buttonIndex)
            {
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
            
        case 1:
        {
            switch(buttonIndex)
            {
                case 0: [self.navigationController popViewControllerAnimated:TRUE];
                    break;
                    
                case 1:
                {
                    sqlite3_stmt *statement;
                    const char *dbpath = [_databasePath UTF8String];
                    
                    if (sqlite3_open(dbpath, &_draftDB) == SQLITE_OK)
                    {
                        
                        NSString *insertSQL = [NSString stringWithFormat:
                                               @"INSERT INTO DRAFTS (subject, message) VALUES (\"%@\", \"%@\")",
                                               subjectField.text, messageField.text];
                        
                        const char *insert_stmt = [insertSQL UTF8String];
                        sqlite3_prepare_v2(_draftDB, insert_stmt,
                                           -1, &statement, NULL);
                        if (sqlite3_step(statement) == SQLITE_DONE)
                        {
                            NSLog(@"Draft added");
                            [self dismissViewControllerAnimated:YES completion:nil];
                            break;
                            
                            
                        } else {
                            NSLog(@"Failed to add Draft");
                        }
                        sqlite3_finalize(statement);
                        sqlite3_close(_draftDB);
                    }
                }
                    
            }
            break;
        }
        default:break;
    }
}

#pragma mark - UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    [assetslibrary assetForURL:imagePath resultBlock:resultblock failureBlock:nil];
}

@end
