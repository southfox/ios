//
//  Task.h
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kTitle;
extern const NSString *kCompleted;
extern const NSString *kChildren;

/*!
 @class Task
 Task class is the model class used by cell.
 */

@interface Task : NSObject

@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain) NSMutableArray *childrenTasks;
@property (nonatomic, assign, readonly, getter = completed) BOOL done;
@property (nonatomic, retain, readonly) NSDate *modifiedDate;


// Init methods
- (Task *)initWithTitle:(NSString *)title;
- (Task *)init;

- (NSString *)modifiedString;

// Completed methods
- (void)complete;
- (void)uncomplete;

// Children methods
- (void)addChild:(Task *)child;
- (void)removeChild:(Task *)child;

// Group methods
- (void)makeChildrensComplete;
- (void)deleteChildrens;

- (NSDictionary *)serialize;

+ (NSArray *)generateTasks;

- (BOOL)inProgress;

@end




