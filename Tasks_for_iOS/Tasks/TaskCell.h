//
//  TaskCell.h
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"

/*!
 @class TaskCell
 This is a cell that represents one task in a table view.
 */

@interface TaskCell : UITableViewCell

@property (nonatomic, retain) Task *task;

- (void)configureStyle;

- (void)setInactive;
- (void)setActive;
- (void)setInProgress;
- (void)setNew;

@end
