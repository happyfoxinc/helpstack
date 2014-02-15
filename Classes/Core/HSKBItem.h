//
//  HATypeKB.h
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

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
