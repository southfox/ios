//
//  Task.m
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "Task.h"

#define NOW [NSDate date]

const NSString *kTitle = @"title";
const NSString *kCompleted = @"done";
const NSString *kChildren = @"childrenTasks";


@interface Task()
@property (nonatomic, assign) BOOL done;
@property (nonatomic, retain, readonly) id parentTask;
@end

@implementation Task

#pragma mark -
#pragma mark free the memory

/*!
 Deallocates the memory occupied by AppDelegate.
 */

- (void)dealloc
{
    [_title release];
    _title = nil;
    
    [_modifiedDate release];
    _modifiedDate = nil;
    
    [_title release];
    _title = nil;
    
    [_parentTask release];
    _parentTask = nil;
    
    [_childrenTasks release];
    _childrenTasks = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark init

/*!
 Main initializer of the class Task. Initialize a new object of Task immediately after memory for it has been allocated.
 @param title
 Title of the class
 @result
 Returns the initialized object of Task.
 */
- (id)initWithTitle:(NSString *)title;
{
    self = [super init];
    if (self)
    {
        _title = [title retain];
        _modifiedDate = nil;
        _childrenTasks = [[NSMutableArray array] retain];
    }
    return self;
}


/*!
 Initializer without parameters. Creates a new task with the title <no title>.
 @result
 Returns the initialized object of Task.
 */

- (id)init
{
    self = [self initWithTitle:@"<no title>"];
    if (self)
    {
    }
    return self;
}



/*!
 Set the title of the Task, updating the modified date.
 @param
 Title of the task.
 */
- (void)setTitle:(NSString *)title
{
    [self updateModifiedDate];
    [_title release];
    _title = [title retain];
}


/*!
 Update the modified date with Now
 */

- (void)updateModifiedDate
{
    [_modifiedDate release];
    _modifiedDate = [NOW retain];
}


/*!
 Builds the modified date string using a default date formater
 @result
 Returns a date as string. If not modified date returns "not yet modified".
 */

- (NSString *)modifiedString
{
    if (self.modifiedDate)
    {
        NSCalendar* calendar = [[NSCalendar alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:calendar];
        [calendar release];
        
        NSString *formatedString = [formatter stringFromDate:self.modifiedDate];
        [formatter release];
        
        return formatedString;
    }
    else
    {
        return @"not yet modified";
    }
}


/*!
 Add a child Taks to the current Task.
 @param
 An instance of the child Task.
 */

- (void)addChild:(Task *)child
{
    
    [child setParentTask:self];

    [self.childrenTasks addObject:child];

    [self updateModifiedDate];
}


/*!
 Remove a child Taks to the current Task.
 @param
 An instance of the child Task.
 */

- (void)removeChild:(Task *)child
{
    [self.childrenTasks removeObject:child];
    
    [self updateModifiedDate];
}

/*!
 Set the parent Task of the current Task.
 @param
 An instance of the Task.
 */

- (void)setParentTask:(id)parentTask
{
    [_parentTask release];
    _parentTask = [parentTask retain];
    
    [self updateModifiedDate];
}

/*!
 Switch done into NO/YES when is called.
 */
- (void)complete
{
    self.done = YES;
    
    [self updateModifiedDate];
    
    [self makeChildrensComplete];
    
    if (self.parentTask)
    {
        [self.parentTask checkChildrens];
    }

}

- (void)uncomplete
{
    self.done = NO;
    
    [self updateModifiedDate];
    
    [self makeChildrensIncomplete];
    
    if (self.parentTask)
    {
        [self.parentTask checkChildrens];
    }

}



/*!
 if all the childrens are completed, complete the parent... or not.
 */

- (void)checkChildrens
{
    BOOL completed = YES;
    for (Task* task in self.childrenTasks)
    {
        assert([task isKindOfClass:[Task class]]);
        
        if (![task completed])
        {
            completed = NO;
            break;
        }
    }
    if (completed)
    {
        self.done = YES;
    }
    else
    {
        self.done = NO;
    }
}


/*!
 Set the all the childrens of the task as complete
 */

- (void)makeChildrensComplete
{
    for (Task* task in self.childrenTasks)
    {
        assert([task isKindOfClass:[Task class]]);
        
        if (![task completed])
        {
            [task complete];
        }
    }
}

- (void)makeChildrensIncomplete
{
    for (Task* task in self.childrenTasks)
    {
        assert([task isKindOfClass:[Task class]]);
        
        if ([task completed])
        {
            [task uncomplete];
        }
    }
}


- (BOOL)inProgress
{
    BOOL someCompleted = NO;
    for (Task* task in self.childrenTasks)
    {
        assert([task isKindOfClass:[Task class]]);
        
        if ([task completed])
        {
            someCompleted = YES;
            break;
        }
    }
    return someCompleted;
}

/*!
 Delete all the childrens of the task as complete
 */

- (void)deleteChildrens
{
    [self.childrenTasks removeAllObjects];
    
    [self updateModifiedDate];
}


/*!
 Creates a dictionary with the information of the task
 */
- (NSDictionary *)serialize
{

    NSDictionary * dictionary = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:kTitle, kCompleted, nil]];
    assert(dictionary);
    
    NSMutableDictionary* serialized = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    assert(serialized);
    
    if ([self.childrenTasks count])
    {
        NSMutableArray *childrens = [NSMutableArray array];
        for (Task* child in self.childrenTasks)
        {
            [childrens addObject:[child serialize]];
        }
        [serialized setObject:childrens forKey:kChildren];
    }
    
    return serialized;
}


/*!
 Generates hardcoded information (using dictionaries and arrays) of the tasks using by the application. Deprecated: will be replaced by a proper model and data persistence layer.
 @result
 Returns an array of generated tasks.
 */

+ (NSArray *)generateTasks
{
    NSArray *taskDescriptions =
    @[
      @{ kTitle     : @"Buy milk",
         kCompleted : @NO },
      
      @{ kTitle     : @"Pay rent",
         kCompleted : @NO },
      
      @{ kTitle     : @"Change tires",
         kCompleted : @NO },
      
      @{ kTitle     : @"Sleep",
         kCompleted : @NO,
         kChildren  :
             @[
                 @{ kTitle     : @"Find a bed",
                    kCompleted : @NO
                    },
                 
                 @{ kTitle     : @"Lie down",
                    kCompleted : @NO
                    },
                 
                 @{ kTitle     : @"Close eyes",
                    kCompleted : @NO
                    },
                 
                 @{ kTitle     : @"Wait",
                    kCompleted : @NO
                    }
                 ] },
      
      @{ kTitle     : @"Dance",
         kCompleted : @NO },
      
      ];
    return taskDescriptions;
}


@end







