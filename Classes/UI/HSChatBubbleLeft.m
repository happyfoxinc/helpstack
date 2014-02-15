//
//  HSChatBubbleLeft.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSChatBubbleLeft.h"

@implementation HSChatBubbleLeft

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, -5, frame.size.width, frame.size.height)];
        self.messageTextView.userInteractionEnabled = NO;
        [self addSubview:self.messageTextView];
        [[[HSHelpStack instance] appearance] customizeLeftBubble:self];
        [[[HSHelpStack instance] appearance] customizeLeftBubbleText:self.messageTextView];
        self.layer.cornerRadius = 5.0;
    }
    
    return self;
}

@end
