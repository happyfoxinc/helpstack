//  HAZendDeskMainViewController.m
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

#import "HSMainListViewController.h"
#import "HSArticleDetailViewController.h"
#import "HSNewIssueViewController.h"
#import "HSUserDetailsViewController.h"
#import "HSGroupViewController.h"
#import "HSHelpStack.h"
#import "HSNewTicket.h"
#import "HSIssueDetailViewController.h"
#import "HSTicketDetailViewControlleriPad.h"
#import "HSKBSource.h"
#import "HSTicketSource.h"
#import "HSAppearance.h"
#import "HSTableView.h"
#import "HSTableViewCell.h"
#import "HSLabel.h"
#import "HSTableViewHeaderCell.h"
#import <MessageUI/MessageUI.h>
#import "HSActivityIndicatorView.h"
#import "HSReportIssueCell.h"
#import "HSTableFooterCreditsView.h"
#import "HSUtility.h"

/*
 To report issue using email:
 ->If ticketDelegate is not set, default email client is open and mail is prepared using given companyEmailAddress.
 */

@interface HSMainListViewController () <HSNewIssueViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    UINavigationController* newTicketNavController;
}

@property(nonatomic, strong) HSActivityIndicatorView *loadingView;

@end

@implementation HSMainListViewController

BOOL finishedLoadingKB = NO;
BOOL finishedLoadingTickets = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.kbSource = [HSKBSource createInstance];
    self.ticketSource = [HSTicketSource createInstance];
    
    self.loadingView = [[HSActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.loadingView];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    HSAppearance* appearance = [[HSHelpStack instance] appearance];
    self.view.backgroundColor = [appearance getBackgroundColor];
    self.tableView.tableFooterView = [UIView new];
    // Fetching KB and Tickets
    [self startLoadingAnimation];
    [self refreshKB];
    [self refreshMyIssue];
    
    [self addCreditsToTable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - KBArticles and Issues Fetch

- (void)refreshKB
{
    // Fetching latest KB article from server.
    [self.kbSource prepareKB:^{
        finishedLoadingKB = YES;
        [self onKBorTicketsFetched];
        [self reloadKBSection];
    } failure:^(NSError* e){
        finishedLoadingKB = YES;
        [self onKBorTicketsFetched];

        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Couldnt load articles" message:@"Error in loading articles. Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)refreshMyIssue
{
    // Fetching latest Tickets from server.
    [self.ticketSource prepareTicket:^{
        finishedLoadingTickets = YES;
        [self onKBorTicketsFetched];
        // If there are no ticket, no need to reload table
        if([self.ticketSource ticketCount]!=0){
            [self reloadTicketsSection];
        }
    } failure:^(NSError* e){
        finishedLoadingTickets = YES;
        [self onKBorTicketsFetched];

        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading the previous issues." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];

    }];
}

- (void)reloadKBSection
{
    NSIndexSet *sectionSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:sectionSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTicketsSection{
    [self.tableView reloadData];
}

- (void)onKBorTicketsFetched{
    if(finishedLoadingKB && finishedLoadingTickets){
        [self stopLoadingAnimation];
    }
}

- (void)startLoadingAnimation
{
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)stopLoadingAnimation
{
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void)addCreditsToTable {
    if ([[HSHelpStack instance] showCredits]) {
        HSTableFooterCreditsView* footerView = [[HSTableFooterCreditsView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        self.tableView.tableFooterView = footerView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return 2+([self.ticketSource ticketCount]!=0);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.kbSource kbCount:HAGearTableTypeSearch];
    }else{
        if (section == 0) {
            return [self.kbSource kbCount:HAGearTableTypeDefault];
        }
        else if (section == 1){
            if([self.ticketSource ticketCount] != 0){
                return [self.ticketSource ticketCount];
            }else{
                return 1;
            }
        }
        else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        static NSString *CellIdentifier = @"Cell";
        
        HSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[HSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        HSKBItem* article = [self.kbSource table:HAGearTableTypeSearch kbAtPosition:indexPath.row];
        cell.textLabel.text = article.title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"HelpCell";
        static NSString *ReportCellIdentifier = @"RepostIssueCell";
        if (indexPath.section == 2 || (indexPath.section == 1 && ([self.ticketSource ticketCount] == 0))) {
            HSReportIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportCellIdentifier];
            if (cell == nil) {
                cell = [[HSReportIssueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReportCellIdentifier];
            }
            
            cell.textLabel.text = @"Report an issue";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            return cell;
        }
        else {
            
            HSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[HSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            if (indexPath.section == 1 && ([self.ticketSource ticketCount] > 0)){
                HSTicket* ticket = [self.ticketSource ticketAtPosition:indexPath.row];
                cell.textLabel.text = ticket.subject;
            } else if (indexPath.section == 0) {
                HSKBItem* article = [self.kbSource table:HAGearTableTypeDefault kbAtPosition:indexPath.row];
                cell.textLabel.text = article.title;
            }

            return cell;
        }
        return nil;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollView.scrollEnabled = true;
}



#pragma mark - TableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self table:HAGearTableTypeSearch articleSelectedAtIndexPath:indexPath.row];
        
    } else {
        if (indexPath.section == 0) {
            [self table:HAGearTableTypeDefault articleSelectedAtIndexPath:indexPath.row];
        } else if(indexPath.section == 1){
            if([self.ticketSource ticketCount] > 0){
                HSTicket* ticket = [self.ticketSource ticketAtPosition:indexPath.row];
                [self performSegueWithIdentifier:@"MyIssueDetail" sender:ticket];
            }else{
                [self reportIssue];
            }
        } else {
            [self reportIssue];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.0;
    }

    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }


    HSTableViewHeaderCell* cell = nil;
    CGRect tableRect = CGRectMake(0, 0, self.tableView.frame.size.width, 30.0);
    if(section == 0){
        cell = [[HSTableViewHeaderCell alloc] initWithFrame:tableRect];
        cell.titleLabel.text = @"FAQ";
    } else if(section == 1 && [self.ticketSource ticketCount] != 0){
        cell = [[HSTableViewHeaderCell alloc] initWithFrame:tableRect];
        cell.titleLabel.text = @"ISSUES";
    }
    else {
        return nil;
    }

    return cell;
}



- (void)table:(HAGearTableType)table articleSelectedAtIndexPath:(NSInteger) position
{
    HSKBItem* selectedKB = [self.kbSource table:table kbAtPosition:position];
    HSKBItemType type = HSKBItemTypeArticle;
    type = selectedKB.itemType;

    // KB is section, so need to call another tableviewcontroller
    if (type == HSKBItemTypeSection) {
        HSKBSource* newSource = [self.kbSource sourceForSection:selectedKB];
        HSGroupViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HAGroupController"];
        controller.kbSource = newSource;
        controller.selectedKB = selectedKB;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        HSArticleDetailViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HAArticleController"];
        controller.article = selectedKB;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReportIssue"]) {
        HSNewIssueViewController* reportViewController = (HSNewIssueViewController*) [segue destinationViewController];
        reportViewController.delegate = self;
        reportViewController.ticketSource = self.ticketSource;
    }
    else if ([[segue identifier] isEqualToString:@"MyIssueDetail"]) {
        HSIssueDetailViewController* viewController = (HSIssueDetailViewController*)segue.destinationViewController;
        viewController.selectedTicket = sender;
        viewController.ticketSource = self.ticketSource;
    }
}

- (void)reportIssue{
    if([self.ticketSource isTicketProtocolImplemented]) {
        [self startReportAnIssue];
    }
    else {
        [self startMailClient];
    }
}

- (void) startReportAnIssue {
    HSNewTicket* ticket = [[HSNewTicket alloc] init];
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(newTicketCancelPressed:)];
    
    
    HSNewIssueViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HSReportIssue"];
    controller.createNewTicket = ticket;
    controller.delegate = self;
    controller.ticketSource = self.ticketSource;
    controller.navigationItem.leftBarButtonItem = cancelItem;
    newTicketNavController = [[UINavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:[UIToolbar class]];
    newTicketNavController.viewControllers = [NSArray arrayWithObject:controller];
    newTicketNavController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:newTicketNavController animated:YES completion:nil];
}


- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)newTicketCancelPressed:(id)sender
{
    [newTicketNavController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterArticlesforSearchString:searchString];
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];

    UIButton* reportIssueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, footerView.frame.size.width, 30)];
    [reportIssueButton setTitle:@"Report An Issue" forState:UIControlStateNormal];
    [reportIssueButton setTitleColor:[UIColor colorWithRed:233.0/255.0f green:76.0/255.0f blue:67.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [reportIssueButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [[reportIssueButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
    [reportIssueButton addTarget:self action:@selector(reportIssueFromSearch) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:reportIssueButton];

    tableView.tableFooterView = footerView;
}

- (void)reportIssueFromSearch {
    //dismiss search
    [self.searchDisplayController setActive:NO animated:NO];
    [self reportIssue];
}

- (void)filterArticlesforSearchString:(NSString*)string
{
    [self.kbSource filterKBforSearchString:string success:^{
        [self.searchDisplayController.searchResultsTableView reloadData];
    } failure:^(NSError* e){
        
    }];
}

#pragma mark - HSNewIssueViewControllerDelegate

- (void)onNewIssueRequested:(HSNewTicket *)createNewTicket
{
    [self startLoadingAnimation];
    
    [self.ticketSource createNewTicket:createNewTicket success:^{
        
        [self reloadTicketsSection];
        [self stopLoadingAnimation];
        
    } failure:^(NSError* e){
        [self stopLoadingAnimation];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops! Some error." message:@"There was some error in reporting your issue. Is your internet ON? Can you try after sometime?" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }];

}

- (void)registerUserAndCreateTicket:(HSNewTicket *)createNewTicket forUserFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email {
    
    [self startLoadingAnimation];
    
    [self.ticketSource registerUserWithFirstName:firstName lastName:lastName email:email success:^ {
        
        [self stopLoadingAnimation];
        [self onNewIssueRequested:createNewTicket];
        
        
    } failure:^(NSError *error) {
        [self stopLoadingAnimation];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops! Some error." message:@"There was some error registering you. Can you try some other email address?" delegate:self cancelButtonTitle:@"No, Leave it." otherButtonTitles:@"Ok", nil];
        
        alertView.tag = 20;
        [alertView show]; 
    }];
}

#pragma mark - MailClient
- (void) startMailClient
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setToRecipients:@[[self.ticketSource supportEmailAddress]]];
        [mailer setSubject:@"Help"];
        [mailer setMessageBody:[HSUtility deviceInformation] isHTML:NO];
        
        mailer.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        [self presentViewController:mailer animated:YES completion:nil];
    } else
    {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to send email" message:@"Have you configured any email account in your phone? Please check." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        UIAlertView* mailSentAlert = [[UIAlertView alloc] initWithTitle:@"Mail sent." message:@"Thanks for contacting me. Will reply asap." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [mailSentAlert show];
    }
    
}

@end
