//  HATypeKB.h
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


#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, HSKBItemType) {
    HSKBItemTypeArticle = 0,
    HSKBItemTypeSection = 1
};

/*
 ### Subclassing notes:
 Make sure you implement initWithCoder and encodeWithCoder which saves custom object created by you.
 */

@interface HSKBItem : NSObject

// Required
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* htmlContent;
@property (nonatomic, strong) NSString* textContent;
@property (nonatomic, strong) NSString* baseUrl;

@property (nonatomic, assign) HSKBItemType itemType;

// Optional
@property (nonatomic, strong) NSString *kb_id;

/**
    Kb will be prepared with given title, content and id, its type will be set as Article.
 
    title and content cannot be nil.
 
    You can assign nil KBid.
 */
- (id)initAsArticle:(NSString*)title textContent:(NSString*)content kbID:(NSString*)kbID;
- (id)initAsArticle:(NSString*)title htmlContent:(NSString*)content baseUrl:(NSString*)baseUrl kbID:(NSString*)kbID;

/**
 Kb will be prepared with given title, content and id,  its type will be set as Section.
 
 title and content cannot be nil.
 
 You can assign nil KBid.
 */
- (id)initAsSection:(NSString*)title kbID:(NSString*)kbID;

@end
