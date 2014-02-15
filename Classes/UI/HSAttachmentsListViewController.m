//
//  HSAttachmentsListViewController.m
//  HelpApp
//
//  Created by Santhana Amuthan on 18/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSAttachmentsListViewController.h"
#import "HSAttachmentsViewController.h"
#import "HSAttachment.h"
#import "HSHelpStack.h"
#import "HSTableViewCell.h"

@interface HSAttachmentsListViewController ()

@end

@implementation HSAttachmentsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* This dummy footer view is added to the table view to remove the separator lines between empty cells */
    self.tableView.tableFooterView = [UIView new];
    
    HSAppearance* appearance = [[HSHelpStack instance] appearance];
    self.view.backgroundColor = [appearance getBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attachmentsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttachmentCell";
    HSTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    HSAttachment *attachment = [self.attachmentsList objectAtIndex:indexPath.row];
    cell.textLabel.text = attachment.fileName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showAttachmentView" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    HSAttachment *attachment = [self.attachmentsList objectAtIndex:indexPath.row];
    NSString *attachmentUrl = attachment.url;
    HSAttachmentsViewController *viewController = (HSAttachmentsViewController *)[segue destinationViewController];
    viewController.url = attachmentUrl;
}

@end
