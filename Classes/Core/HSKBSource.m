//  HAKBGearImpl.m
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


#import "HSKBSource.h"
#import "HSHelpStack.h"

@interface HSKBSource ()

@property (nonatomic, strong, readwrite) NSMutableArray* kbArray; // Stores Kb articles
@property (nonatomic, strong, readwrite) NSMutableArray* filterArray; // Stores search result
@property (nonatomic, strong) HSGear* gear;

@end

@implementation HSKBSource

+ (instancetype)createInstance {
    HSGear* gear = [[HSHelpStack instance] gear];
    NSAssert (gear != nil, @"No gear was set to HSHelpStack");
    HSKBSource* source = [[HSKBSource alloc] initWithGear:gear];
    return source;
}


/**
    Set HAGear, so its method can be called.
 */
-(id)initWithGear:(HSGear*)gear {
    if(self = [super init]) {
        self.gear = gear;
    }
    
    return self;
    
}


- (void)prepareKB:(void (^)(void))success failure:(void (^)(NSError *))failure {
    if (self.gear.localArticlePath == nil) {
        [self readKBArticleFromGear:success failure:failure];
    }
    else {
        [self readKBArticleFromLocalPList:success failure:failure];
    }
}

- (void)readKBArticleFromGear:(void (^)(void))success failure:(void (^)(NSError *))failure {
    // Checking if gear implements fetchKBForSection:success:failure:
    if ([self.gear respondsToSelector:@selector(fetchKBForSection:success:failure:)]) {
        [self.gear fetchKBForSection:self.section success:^(NSMutableArray *kbarray) {
            // KB fetch was sucess
            self.kbArray = kbarray;
            success();
        } failure:^(NSError *e) {
            HALog("Prepare KB failed: %@",e);
            failure(e);
        }];
    }
    else {
        // Calling success in order not to break code
        success();
    }
}

- (void)readKBArticleFromLocalPList:(void (^)(void))success failure:(void (^)(NSError *))failure {
    
    NSString* articlesPath = [[NSBundle mainBundle] pathForResource:self.gear.localArticlePath ofType:@"plist"];
    NSArray* articleDict = [NSArray arrayWithContentsOfFile:articlesPath];
    NSMutableArray* articles = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *object in articleDict) {
        HSKBItem* kb = [[HSKBItem alloc] initAsArticle:[object objectForKey:@"title"] textContent:[object objectForKey:@"content"] kbID:nil];
        [articles addObject:kb];
    }
    
    self.kbArray = articles;
    success();
}


- (HSKBItem *)table:(HAGearTableType)type kbAtPosition:(NSInteger)position {
    if (type == HAGearTableTypeDefault) {
        return [self.kbArray objectAtIndex:position];
    }
    else {
        return [self.filterArray objectAtIndex:position];
    }
}

- (NSInteger)kbCount:(HAGearTableType)type {
    if (type == HAGearTableTypeDefault) {
        return [self.kbArray count];
    }
    else {
        return [self.filterArray count];
    }
}

-(void)filterKBforSearchString:(NSString *)string success:(void (^)(void))success failure:(void (^)(NSError*))failure {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",string];
    self.filterArray = [NSMutableArray arrayWithArray:[self.kbArray filteredArrayUsingPredicate:predicate]];
    success();
}

/**
    Creates new HAKBSource for selected section at position.
 */
- (HSKBSource *)sourceForSection:(HSKBItem *)section {
    // preparing new HAKBSource, for given section
    HSKBSource* gear = [[HSKBSource alloc] initWithGear:self.gear];
    gear.section = section;
    
    return gear;
    
}

@end
