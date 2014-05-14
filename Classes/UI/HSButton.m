//
//  HSButton.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSButton.h"

@implementation HSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [[[HSHelpStack instance] appearance] customizeButton:self];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[[HSHelpStack instance] appearance] customizeButton:self];
    }
    return self;
    
}

@end
