//
//  HSLabel.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSSmallLabel.h"

@implementation HSSmallLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [[[HSHelpStack instance] appearance] customizeSmallTextLabel:self];
    }
    
    return self;
}


@end
