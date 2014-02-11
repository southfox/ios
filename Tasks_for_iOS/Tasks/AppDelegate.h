//
//  AppDelegate.h
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TasksTableViewController;
@class LaunchViewController;

/*!
 @class AppDelegate
 This is the singleton UIApplication object. The main app delegate of the application Tasks.
 Inside there are methods implemented  of the singleton UIApplication object.
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) TasksTableViewController *tasksTableViewController;
@property (nonatomic, strong) LaunchViewController *launchViewController;
@property (nonatomic, retain) NSMutableArray *tasks;

@end
