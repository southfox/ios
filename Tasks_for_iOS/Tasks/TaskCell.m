//
//  TaskCell.m
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "TaskCell.h"


@implementation TaskCell
{
    UIImageView *_checkMarkView;
}
/*!
 Deallocates the memory occupied by AppDelegate.
 */

- (void)dealloc
{
    [_task release];
    _task = nil;
    
    [_checkMarkView release];
    _checkMarkView = nil;
    
    [super dealloc];
}

/*!
 Initializes a Task table cell with a style and a reuse identifier and returns it to the caller.
 @param style
 A constant indicating a cell style
 @param reuseIdentifier
 A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view.
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _checkMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkbox-Empty.png"]];
        _checkMarkView.bounds = CGRectMake(0, 0, 40, self.bounds.size.height);
        [self addSubview:_checkMarkView];
    }

    return self;
}

/*!
 Configures the textlabel font and color of the class.
 */

- (void)configureStyle
{
    [self setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    self.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:16];
    
}


/*!
 Associates the Task object to this TaskCell.
 @param task
 Instance of a Task
 */

- (void)setTask:(Task *)task
{
    [_task release];
    _task = [task retain];

    if (self.task.childrenTasks.count)
    {
        self.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", self.task.title, self.task.childrenTasks.count];
    }
    else
    {
        self.textLabel.text = self.task.title;
    }

    if (self.task.completed)
    {
        [self setInactive];
    }
    else
    {
        [self setActive];
    }

}

/*!
 Changes the visual indication of the task when is inactive: using a text color light gray.
 */

- (void)setInactive
{
    self.textLabel.textColor = [UIColor lightGrayColor];
}

- (void)setInProgress
{
    self.textLabel.textColor = [UIColor blackColor];
}


/*!
 Changes the visual indication of the task when is active: using a text color black.
 */

- (void)setActive
{
    self.textLabel.textColor = [UIColor blackColor];
}

/*!
 Changes the visual indication of the task when is new.
 */

- (void)setNew
{
    [self.textLabel setText:@"<new task>"];
    self.textLabel.textColor = [UIColor greenColor];
}



/*!
 Lays out subviews.
 */

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Configure Title
    CGRect r = self.textLabel.bounds;
    r.origin.x = 40;
    self.textLabel.frame = r;

    if (_task)
    {
        // Switch Image
        if (_task.completed)
        {
            _checkMarkView.image = [UIImage imageNamed:@"Checkbox-Checked.png"];
        }
        else if ([_task inProgress])
        {
            _checkMarkView.image = [UIImage imageNamed:@"Checkbox-WIP.png"];
        }
        else
        {
            _checkMarkView.image = [UIImage imageNamed:@"Checkbox-Empty.png"];
        }
    }
    else
    {
        _checkMarkView.image = nil;
    }
}


@end