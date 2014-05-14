//  HSChatBubbleRight.m
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Initialization code
        self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
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
