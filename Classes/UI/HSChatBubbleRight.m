//
//  HSChatBubbleRight.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSChatBubbleRight.h"

@interface HSChatBubbleRight ()

@property (nonatomic, strong) UITextView *messageTextView;

@end

@implementation HSChatBubbleRight

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, -5, frame.size.width, frame.size.height)];
        self.messageTextView.userInteractionEnabled = NO;
        [self addSubview:self.messageTextView];
        [[[HSHelpStack instance] appearance] customizeRightBubble:self];
        [[[HSHelpStack instance] appearance] customizeRightBubbleText:self.messageTextView];
        self.layer.cornerRadius = 5.0;
    }
    
    return self;
}

-(UITextView *)getChatTextView {
    
    if(!self.messageTextView) {
        self.messageTextView = [[UITextView alloc] init];
    }
    self.messageTextView.frame = CGRectMake(0, -2, self.frame.size.width, self.frame.size.height);
    self.messageTextView.userInteractionEnabled = NO;
    [[[HSHelpStack instance] appearance] customizeRightBubble:self];
    [[[HSHelpStack instance] appearance] customizeRightBubbleText:self.messageTextView];
    self.layer.cornerRadius = 10.0;
    [self addSubview:self.messageTextView];
    return self.messageTextView;
}

@end
