//
//  HelpStack.m
//  HelpApp
//
//  Created by Tenmiles on 26/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSHelpStack.h"


@interface HSHelpStack ()

@property (nonatomic, strong, readwrite) HSAppearance* appearance;

@end

@implementation HSHelpStack

/**
 Creates Singleton instance of class.
 **/
+ (id)instance {
    static HSHelpStack *helpStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helpStack = [[self alloc] init];
        helpStack.appearance = [HSAppearance instance];
        helpStack.requiresNetwork = YES;
        helpStack.showCredits = YES;
    });
    return helpStack;
}


- (void)setThemeFrompList:(NSString *)pListPath {
    [self.appearance setCustomThemeProperties:[self readThemePropertiesFrompList:pListPath]];
}

- (NSDictionary *)readThemePropertiesFrompList:(NSString *)pListPath {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pListPath ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        NSDictionary *properties = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        return properties;
    }
    return nil;
}
/**
    start HelpStackController for given gear.
 */

- (void)showHelp:(UIViewController*)parentController {
    [self showHelp:parentController completion:nil];
}

- (void)showHelp:(UIViewController*)parentController completion:(void (^)(void))completion {
    
    UIViewController* mainController;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIStoryboard* helpStoryboard = [UIStoryboard storyboardWithName:@"HelpStackStoryboard-iPad" bundle:[NSBundle mainBundle]];
        mainController = [helpStoryboard instantiateInitialViewController];
        [mainController setModalPresentationStyle:UIModalPresentationFormSheet];
        [parentController presentViewController:mainController animated:YES completion:completion];
        
    }
    else {
        UIStoryboard* helpStoryboard = [UIStoryboard storyboardWithName:@"HelpStackStoryboard" bundle:[NSBundle mainBundle]];
        mainController = [helpStoryboard instantiateInitialViewController];
        [parentController presentViewController:mainController animated:YES completion:completion];
    }
}



@end
