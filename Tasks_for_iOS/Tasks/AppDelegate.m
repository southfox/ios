//
//  AppDelegate.m
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "AppDelegate.h"
#import "Task.h"
#import "TasksTableViewController.h"
#import "LaunchViewController.h"

NSString* const jsonFileName = @"Tasks.json";

@interface AppDelegate()

@property (nonatomic, assign) BOOL launchStoped;

@end


@implementation AppDelegate

/*!
 Deallocates the memory occupied by AppDelegate.
 */

- (void)dealloc
{
    [_window release];
    _window = nil;
    
    [_navigationController release];
    _navigationController = nil;
    
    [_tasksTableViewController release];
    _tasksTableViewController = nil;

    [_launchViewController release];
    _launchViewController = nil;
    
    [_tasks release];
    _tasks = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

/*!
 Tells the delegate that the launch process is almost done and the app is almost ready to run.
 @param application
 The delegating application object.
 @param launchOptions
 A dictionary indicating the reason the application was launched (if any). .
 @result
 Returns NO if the application cannot handle the URL resource, otherwise return YES. The return value is ignored if the application is launched as a result of a remote notification.
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    [self addBackground];
    [self showLaunch];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


/*!
 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 @param application
 The delegating application object.
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self cancelLaunchObservers];

    [self saveTasksIntoDevice];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self showLaunch];
    [_tasksTableViewController.view removeFromSuperview];
}


/*!
 Parses the array & internal dictionaries and creates the objects of class Task.
 @param taskDescriptions
 Array that contains the information of the task.
 @result
 Returns arrays of objects of class Task.
 */
- (NSMutableArray *)tasksFromDescriptions:(NSArray *)taskDescriptions
{
    NSMutableArray *tasks = [NSMutableArray array];

    for (NSDictionary *taskDescription in taskDescriptions) {

        NSString *title = [taskDescription objectForKey:kTitle];
        BOOL completed = [[taskDescription objectForKey:kCompleted] boolValue];
        NSArray *childrenDescriptions = [taskDescription objectForKey:kChildren];

        Task *task = [[[Task alloc] initWithTitle:title] autorelease];

        if (childrenDescriptions != nil && childrenDescriptions.count > 0) {
            NSArray *children = [self tasksFromDescriptions:childrenDescriptions];
            for (Task *child in children) {
                [task addChild:child];
                NSLog(@"adding");
            }
        }
        if (completed)
        {
            [task complete];
        }

        [tasks addObject:task];
    }
    
    return tasks;
}

/*!
 */
- (void)addBackground {
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    background.frame = self.window.frame;
    background.contentMode = UIViewContentModeScaleToFill;
    [self.window addSubview:background];
    [background release];
}

/*!
 */

- (void)showLaunchViewController {
    
    self.launchStoped = NO;
    
	_launchViewController = [[[LaunchViewController alloc] init] autorelease];
    [self.window setRootViewController:_launchViewController];
    
	[self.window makeKeyAndVisible];
	
}



- (void)hideLaunchViewController  {
    
    if (self.launchStoped)
    {
        return;
    }
    
    self.launchStoped = YES;
    [self.launchViewController.view removeFromSuperview];
    
    [self loadTasks];
}



- (void)loadTasks
{

    NSArray *taskDescriptions = [self loadTasksFromDevice];
    if (taskDescriptions.count == 0)
    {
        taskDescriptions = [Task generateTasks];
    }
    
    assert(taskDescriptions.count);
    
    _tasks = [[self tasksFromDescriptions:taskDescriptions] retain];
    
    _tasksTableViewController = [[TasksTableViewController alloc] initWithTasks:_tasks parentTask:nil];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_tasksTableViewController];
    self.navigationController.toolbarHidden = NO;
    
    [self.window setRootViewController:_navigationController];
    
    
    [self.window makeKeyAndVisible];
}






- (NSArray *)loadTasksFromDevice
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* jsonDocument = [documentPath stringByAppendingPathComponent:jsonFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:jsonDocument]) {
        
        // it's not accessible
        return nil;
    }
    
    NSArray* taskDescriptions = [self loadDocument:jsonDocument];
    
    return taskDescriptions;
}


- (BOOL)saveTasksIntoDevice
{

    NSError* error = nil;

    NSMutableArray* array2Serialize = [NSMutableArray array];
    for (Task* task in self.tasks)
    {
        NSDictionary* taskDictionary = [task serialize];
        assert(taskDictionary && [taskDictionary isKindOfClass:[NSDictionary class]]);
        
        [array2Serialize addObject:taskDictionary];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array2Serialize options:0 error:&error];

    assert(error == nil);
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* jsonDocument = [documentPath stringByAppendingPathComponent:jsonFileName];

    BOOL saved = [jsonData writeToFile:jsonDocument options:NSDataWritingAtomic error:&error];
    
    assert(error == nil);
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }

    return saved;
}


- (NSArray*)loadDocument:(NSString*)path
{
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:&error];
    
    assert(data && [data isKindOfClass:[NSData class]]);
    if (!data) {
        return nil;
    }
    
    assert(error == nil);
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    assert(error == nil);
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    assert(array && [array isKindOfClass:[NSArray class]]);
    
    return array;
}

- (void)showLaunch
{
    [self showLaunchViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLaunchViewController) name:kLaunchSkipNotification object:nil];
    
    [self performSelector:@selector(hideLaunchViewController) withObject:nil afterDelay:60.0f];
    
}

- (void)cancelLaunchObservers
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLaunchViewController) object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLaunchSkipNotification object:nil];
}

@end
