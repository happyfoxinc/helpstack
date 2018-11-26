//
//  HPTextView.m
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "HSGrowingTextView.h"
#import "HSTextViewInternal.h"

@interface HSGrowingTextView(private)
-(void)commonInitialiser;
-(void)resizeTextView:(NSInteger)newSizeH;
-(void)growDidStop;
@end

@implementation HSGrowingTextView
@synthesize internalTextView;
@synthesize delegate;
@synthesize maxHeight;
@synthesize minHeight;
@synthesize font;
@synthesize textColor;
@synthesize textAlignment; 
@synthesize selectedRange;
@synthesize editable;
@synthesize dataDetectorTypes;
@synthesize animateHeightChange;
@synthesize animationDuration;
@synthesize returnKeyType;
@dynamic placeholder;
@dynamic placeholderColor;

// having initwithcoder allows us to use HPGrowingTextView in a Nib. -- aob, 9/2011
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInitialiser];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialiser];
        [[[HSHelpStack instance] appearance] customizeTextView:self.internalTextView];
    }
    return self;
}

-(void)commonInitialiser
{
    // Initialization code
    CGRect r = self.frame;
    r.origin.y = 0;
    r.origin.x = 0;
    internalTextView = [[HSTextViewInternal alloc] initWithFrame:r];
    internalTextView.delegate = self;
    internalTextView.scrollEnabled = NO;
    internalTextView.font = [UIFont fontWithName:@"Helvetica" size:13]; 
    internalTextView.contentInset = UIEdgeInsetsZero;		
    internalTextView.showsHorizontalScrollIndicator = NO;
    internalTextView.text = @"-";
    [self addSubview:internalTextView];
    
    minHeight = internalTextView.frame.size.height;
    minNumberOfLines = 1;
    
    animateHeightChange = YES;
    animationDuration = 0.1f;
    
    internalTextView.text = @"";
    
    [self setMaxNumberOfLines:3];

    [self setPlaceholderColor:[UIColor lightGrayColor]];
    internalTextView.displayPlaceHolder = YES;
}

-(void)refreshFrame:(CGRect)newFrame {
    internalTextView.frame = newFrame;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    if (self.text.length == 0) {
        size.height = minHeight;
    }
    return size;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
	CGRect r = self.bounds;
	r.origin.y = 0;
	r.origin.x = contentInset.left;
    r.size.width -= contentInset.left + contentInset.right;
    
    internalTextView.frame = r;
}

-(void)setContentInset:(UIEdgeInsets)inset
{
    contentInset = inset;
    
    CGRect r = self.frame;
    r.origin.y = inset.top - inset.bottom;
    r.origin.x = inset.left;
    r.size.width -= inset.left + inset.right;
    
    internalTextView.frame = r;
    
    [self setMaxNumberOfLines:maxNumberOfLines];
    [self setMinNumberOfLines:minNumberOfLines];
}

-(UIEdgeInsets)contentInset
{
    return contentInset;
}

-(void)setMaxNumberOfLines:(int)n
{
    if(n == 0 && maxHeight > 0) return; // the user specified a maxHeight themselves.
    
    // Use internalTextView for height calculations, thanks to Gwynne <http://blog.darkrainfall.org/>
    NSString *saveText = internalTextView.text, *newText = @"-";
    
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < n; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    
    maxHeight = [self measureHeight];
    
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    maxNumberOfLines = n;
}

-(int)maxNumberOfLines
{
    return maxNumberOfLines;
}

- (void)setMaxHeight:(int)height
{
    maxHeight = height;
    maxNumberOfLines = 0;
}

-(void)setMinNumberOfLines:(int)m
{
    if(m == 0 && minHeight > 0) return; // the user specified a minHeight themselves.

	// Use internalTextView for height calculations, thanks to Gwynne <http://blog.darkrainfall.org/>
    NSString *saveText = internalTextView.text, *newText = @"-";
    
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < m; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    
    minHeight = [self measureHeight];
    
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    minNumberOfLines = m;
}

-(int)minNumberOfLines
{
    return minNumberOfLines;
}

- (void)setMinHeight:(int)height
{
    minHeight = height;
    minNumberOfLines = 0;
}

- (NSString *)placeholder
{
    return internalTextView.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [internalTextView setPlaceholder:placeholder];
}

- (UIColor *)placeholderColor
{
    return internalTextView.placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor 
{
    [internalTextView setPlaceholderColor:placeholderColor];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshHeight];
}

- (void)refreshHeight
{
	//size of content, so we can set the frame of self
	NSInteger newSizeH = ceilf([self measureHeight]);
	if (newSizeH < minHeight || !internalTextView.hasText) {
        newSizeH = minHeight; //not smalles than minHeight
    }
    else if (maxHeight && internalTextView.frame.size.height > maxHeight) {
        newSizeH = maxHeight; // not taller than maxHeight
    }
    
	if (internalTextView.frame.size.height != newSizeH)
	{
        // [fixed] Pasting too much text into the view failed to fire the height change, 
        // thanks to Gwynne <http://blog.darkrainfall.org/>
        
        if (newSizeH > maxHeight && internalTextView.frame.size.height <= maxHeight)
        {
            newSizeH = maxHeight;
        }
        
		if (newSizeH <= maxHeight)
		{
            if(animateHeightChange) {
                
                if ([UIView resolveClassMethod:@selector(animateWithDuration:animations:)]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
                    [UIView animateWithDuration:animationDuration 
                                          delay:0 
                                        options:(UIViewAnimationOptionAllowUserInteraction|
                                                 UIViewAnimationOptionBeginFromCurrentState)                                 
                                     animations:^(void) {
                                         [self resizeTextView:newSizeH];
                                     } 
                                     completion:^(BOOL finished) {
                                         if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
                                             [delegate growingTextView:self didChangeHeight:newSizeH];
                                         }
                                     }];
#endif
                } else {
                    [UIView beginAnimations:@"" context:nil];
                    [UIView setAnimationDuration:animationDuration];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(growDidStop)];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [self resizeTextView:newSizeH];
                    [UIView commitAnimations];
                }
            } else {
                [self resizeTextView:newSizeH];                
                // [fixed] The growingTextView:didChangeHeight: delegate method was not called at all when not animating height changes.
                // thanks to Gwynne <http://blog.darkrainfall.org/>
                
                if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
                    [delegate growingTextView:self didChangeHeight:newSizeH];
                }	
            }
		}
        
        // if our new height is greater than the maxHeight
        // sets not set the height or move things
        // around and enable scrolling
		if (newSizeH >= maxHeight)
		{
			if(!internalTextView.scrollEnabled){
				internalTextView.scrollEnabled = YES;
				[internalTextView flashScrollIndicators];
			}
			
		} else {
			internalTextView.scrollEnabled = NO;
		}
		
        // scroll to caret (needed on iOS7)
        if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
        {
            CGRect r = [internalTextView caretRectForPosition:internalTextView.selectedTextRange.end];
            CGFloat caretY =  MAX(r.origin.y - internalTextView.frame.size.height + r.size.height + 8, 0);
            if(internalTextView.contentOffset.y < caretY && r.origin.y != INFINITY)
                internalTextView.contentOffset = CGPointMake(0, MIN(caretY, internalTextView.contentSize.height));
        }
	}
    // Display (or not) the placeholder string
    
    BOOL wasDisplayingPlaceholder = internalTextView.displayPlaceHolder;
    internalTextView.displayPlaceHolder = self.internalTextView.text.length == 0;
	
    if (wasDisplayingPlaceholder != internalTextView.displayPlaceHolder) {
        [internalTextView setNeedsDisplay];
    }
    
    // Tell the delegate that the text view changed
	
    if ([delegate respondsToSelector:@selector(growingTextViewDidChange:)]) {
		[delegate growingTextViewDidChange:self];
	}
	
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        CGRect frame = internalTextView.bounds;
        CGSize fudgeFactor;
        // The padding added around the text on iOS6 and iOS7 is different.
        fudgeFactor = CGSizeMake(10.0, 16.0);
        
        frame.size.height -= fudgeFactor.height;
        frame.size.width -= fudgeFactor.width;
        
        NSMutableAttributedString* textToMeasure;
        if(internalTextView.attributedText && internalTextView.attributedText.length > 0){
            textToMeasure = [[NSMutableAttributedString alloc] initWithAttributedString:internalTextView.attributedText];
        }
        else{
            textToMeasure = [[NSMutableAttributedString alloc] initWithString:internalTextView.text];
            [textToMeasure addAttribute:NSFontAttributeName value:internalTextView.font range:NSMakeRange(0, textToMeasure.length)];
        }
        
        if ([textToMeasure.string hasSuffix:@"\n"])
        {
            [textToMeasure appendAttributedString:[[NSAttributedString alloc] initWithString:@"-" attributes:@{NSFontAttributeName: internalTextView.font}]];
        }
        
        // NSAttributedString class method: boundingRectWithSize:options:context is
        // available only on ios7.0 sdk.
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
        
        return CGRectGetHeight(size) + fudgeFactor.height;
    }
    else
    {
        return self.internalTextView.contentSize.height;
    }
#else
    return self.internalTextView.contentSize.height;
#endif
}

-(void)resizeTextView:(NSInteger)newSizeH
{
    if ([delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)]) {
        [delegate growingTextView:self willChangeHeight:newSizeH];
    }
    
    CGRect internalTextViewFrame = self.frame;
    internalTextViewFrame.size.height = newSizeH; // + padding
    self.frame = internalTextViewFrame;
    
    internalTextViewFrame.origin.y = contentInset.top - contentInset.bottom;
    internalTextViewFrame.origin.x = contentInset.left;
    internalTextViewFrame.size.width = internalTextView.contentSize.width;
    
    if(!CGRectEqualToRect(internalTextView.frame, internalTextViewFrame)) internalTextView.frame = internalTextViewFrame;
}

- (void)growDidStop
{
	if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
		[delegate growingTextView:self didChangeHeight:self.frame.size.height];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [internalTextView becomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [self.internalTextView becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
	[super resignFirstResponder];
	return [internalTextView resignFirstResponder];
}

-(BOOL)isFirstResponder
{
  return [self.internalTextView isFirstResponder];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITextView properties
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setText:(NSString *)newText
{
    internalTextView.text = newText;
    
    // include this line to analyze the height of the textview.
    // fix from Ankit Thakur
    [self performSelector:@selector(textViewDidChange:) withObject:internalTextView];
}

-(NSString*) text
{
    return internalTextView.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setFont:(UIFont *)afont
{
	internalTextView.font= afont;
	
	[self setMaxNumberOfLines:maxNumberOfLines];
	[self setMinNumberOfLines:minNumberOfLines];
}

-(UIFont *)font
{
	return internalTextView.font;
}	

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextColor:(UIColor *)color
{
	internalTextView.textColor = color;
}

-(UIColor*)textColor{
	return internalTextView.textColor;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
  [super setBackgroundColor:backgroundColor];
	internalTextView.backgroundColor = backgroundColor;
}

-(UIColor*)backgroundColor
{
  return internalTextView.backgroundColor;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextAlignment:(NSTextAlignment)aligment
{
	internalTextView.textAlignment = aligment;
}

-(NSTextAlignment)textAlignment
{
	return internalTextView.textAlignment;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setSelectedRange:(NSRange)range
{
	internalTextView.selectedRange = range;
}

-(NSRange)selectedRange
{
	return internalTextView.selectedRange;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setIsScrollable:(BOOL)isScrollable
{
    internalTextView.scrollEnabled = isScrollable;
}

- (BOOL)isScrollable
{
    return internalTextView.scrollEnabled;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setEditable:(BOOL)beditable
{
	internalTextView.editable = beditable;
}

-(BOOL)isEditable
{
	return internalTextView.editable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
	internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
	return internalTextView.returnKeyType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setKeyboardType:(UIKeyboardType)keyType
{
	internalTextView.keyboardType = keyType;
}

- (UIKeyboardType)keyboardType
{
	return internalTextView.keyboardType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically
{
  internalTextView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
}

- (BOOL)enablesReturnKeyAutomatically
{
  return internalTextView.enablesReturnKeyAutomatically;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setDataDetectorTypes:(UIDataDetectorTypes)datadetector
{
	internalTextView.dataDetectorTypes = datadetector;
}

-(UIDataDetectorTypes)dataDetectorTypes
{
	return internalTextView.dataDetectorTypes;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)hasText{
	return [internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range
{
	[internalTextView scrollRangeToVisible:range];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
		return [delegate growingTextViewShouldBeginEditing:self];
		
	} else {
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewShouldEndEditing:)]) {
		return [delegate growingTextViewShouldEndEditing:self];
		
	} else {
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewDidBeginEditing:)]) {
		[delegate growingTextViewDidBeginEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView {		
	if ([delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
		[delegate growingTextViewDidEndEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)atext {
	
	//weird 1 pixel bug when clicking backspace when textView is empty
	if(![textView hasText] && [atext isEqualToString:@""]) return NO;
	
	//Added by bretdabaker: sometimes we want to handle this ourselves
    	if ([delegate respondsToSelector:@selector(growingTextView:shouldChangeTextInRange:replacementText:)])
        	return [delegate growingTextView:self shouldChangeTextInRange:range replacementText:atext];
	
	if ([atext isEqualToString:@"\n"]) {
		if ([delegate respondsToSelector:@selector(growingTextViewShouldReturn:)]) {
			if (![delegate performSelector:@selector(growingTextViewShouldReturn:) withObject:self]) {
				return YES;
			} else {
				[textView resignFirstResponder];
				return NO;
			}
		}
	}
	
	return YES;
	
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChangeSelection:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewDidChangeSelection:)]) {
		[delegate growingTextViewDidChangeSelection:self];
	}
}



@end
