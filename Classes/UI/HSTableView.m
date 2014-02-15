//
//  HSTableView.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTableView.h"
#import "HSTableViewCell.h"

@implementation HSTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        HSAppearance* appearance = [[HSHelpStack instance] appearance];
        [appearance customizeTableView:self];
        
    }
    return self;
}

-(UIView *)getHeaderViewforFrame:(CGRect)frame forTitle:(NSString *)title{
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, 200.0, 30.0)];
    [headerView addSubview:headerTitle];
    headerTitle.text = title;
    [[[HSHelpStack instance] appearance] customizeTableHeader:headerView];
    [[[HSHelpStack instance] appearance] customizeHeaderTitle:headerTitle];
    return headerView;
}

@end
