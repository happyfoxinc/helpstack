//
//  HSTableViewHeaderCell.m
//  HelpApp
//
//  Created by Nalin on 23/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTableViewHeaderCell.h"
#import "HSHelpStack.h"
#import "HSAppearance.h"

@interface HSTableViewHeaderCell ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation HSTableViewHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        float leftPadding = 15.0;
        if ([HSAppearance isIOS6]) {
            leftPadding = 10.0;
        }
        
        UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, 0, 200.0, 30.0)];
        [self addSubview:headerTitle];
        self.titleLabel = headerTitle;
        // Initialization code
        [self refreshCellProperties];
    }
    
    return self;
}

- (void)refreshCellProperties
{
    [[[HSHelpStack instance] appearance] customizeTableHeader:self];
    [[[HSHelpStack instance] appearance] customizeHeaderTitle:self.titleLabel];
}

@end
