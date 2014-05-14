//
//  HSLabel.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSLabel.h"

@implementation HSLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [[[HSHelpStack instance] appearance] customizeTextLabel:self];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[[HSHelpStack instance] appearance] customizeTextLabel:self];
    }
    return self;
    
}


@end
