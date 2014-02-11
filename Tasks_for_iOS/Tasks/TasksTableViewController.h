//
//  TasksTableViewController.h
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Task;

/*!
 @class TasksTableViewController
 This is the main view controller that shows all the tasks in a table view.
 */

@interface TasksTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithTasks:(NSMutableArray*)tasks parentTask:(Task*)parentTask;

@end
