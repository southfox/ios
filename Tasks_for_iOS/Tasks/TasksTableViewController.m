//
//  TasksTableViewController.m
//  Tasks
//
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "TasksTableViewController.h"
#import "Task.h"
#import "TaskCell.h"
#import "CALayer+Category.h"
#import "AlertView.h"


@interface TasksTableViewController ()
@property (nonatomic, retain) Task *parentTask;
@property (nonatomic, retain) NSMutableArray *tasks;
@property (nonatomic, retain) NSArray* myToolbarItems;
@end

@implementation TasksTableViewController

/*!
 Deallocates the memory occupied by AppDelegate.
 */

- (void)dealloc
{
    [_parentTask release];
    _parentTask = nil;
    
    [_myToolbarItems release];
    _myToolbarItems = nil;
    
    [_tasks release];
    _tasks = nil;
    
    [super dealloc];
}


/*!
 Initialize the view controller with an array of tasks.
 @param tasks
 @result
 An initialized object view controller of the class TasksTableViewController
 */


- (id)initWithTasks:(NSMutableArray*)tasks parentTask:(Task *)parentTask
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self != nil)
    {
        _myToolbarItems = [@[
                           self.editButtonItem,
                           [[[UIBarButtonItem alloc] initWithTitle:@"Complete all"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(completeAll)] autorelease],
                           
                           [[[UIBarButtonItem alloc] initWithTitle:@"Uncomplete all"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(uncompleteAll)] autorelease],
                           
                           [[[UIBarButtonItem alloc] initWithTitle:@"Sort by name"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(sortByName)] autorelease],
                           
                           [[[UIBarButtonItem alloc] initWithTitle:@"Sort by completion"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(sortByCompletion)] autorelease]
                              ] retain];
        
        _tasks = [tasks retain];
        _parentTask = [parentTask retain];

        [self.tableView registerClass:[TaskCell class]
               forCellReuseIdentifier:@"TaskCell"];
    }
    return self;
}



/*!
 Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.parentTask)
    {
        self.title = self.parentTask.title;
    }
    else
    {
        self.title = @"Tasks";
    }
    self.toolbarItems = self.myToolbarItems;
    self.tableView.backgroundColor = [UIColor clearColor];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self reloadData];
}

#pragma mark - Table view data source

/*!
 Asks the data source to return the number of sections in the table view.
 @param tableView
 An object representing the table view requesting this information.
 @result
 The number of sections in tableView. The default value is 1.
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/*!
 Tells the data source to return the number of rows in a given section of a table view. 
 @param tableView
 An object representing the table view requesting this information.
 @param section
 An index number identifying a section in tableView.
 @result
 The number of rows in section.
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.tasks.count;
    if ([tableView isEditing]) {
        count += 1;
    }
    return count;
}


/*!
 Asks the data source for a cell to insert in a particular location of the table view. 
 @param tableView
 A table-view object requesting the cell.
 @param indexPath
 An index path locating a row in tableView.
 @result
 An object inheriting from UITableViewCell that the table view can use for the specified row.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];

    int row = [indexPath row];
    
    if (row < self.tasks.count)
    {
        
        Task* task = [self.tasks objectAtIndex:row];
    
        [cell setTask:task];

        [cell configureStyle];
    }
    else
    {
        // new cell
        [cell setNew];
    }

    return cell;
}


#pragma mark - Table view delegate

/*!
 Tells the delegate that the specified row is now selected.
 @param tableView
 A table-view object informing the delegate about the new row selection.
 @param indexPath
 An index path locating the new selected row in tableView.
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
   
    int row = [indexPath row];
    
    if (row < self.tasks.count)
    {
        Task *task = [self.tasks objectAtIndex:[indexPath row]];
        
        if ([task completed])
        {
            [task uncomplete];
            [cell setActive];
        }
        else
        {
            [task complete];
            [cell setInactive];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


/*!
 Tells the delegate that the user tapped the accessory (disclosure) view associated with a given row.
 @param tableView
 The table-view object informing the delegate of this event.
 @param indexPath
 An index path locating the row in tableView.
 */

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.tasks objectAtIndex:[indexPath row]];
    
    TasksTableViewController *tvc = [[TasksTableViewController alloc] initWithTasks:[task childrenTasks] parentTask:self.parentTask];

    [self.navigationController pushViewController:tvc animated:YES];

    [tvc release];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if (row < self.tasks.count)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleInsert;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Task* task = [self.tasks objectAtIndex:row];
        [self.tasks removeObject:task];
        [self reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self enterTaskName:indexPath];
    }
}



/*!
 Change completion (complete/uncomplete) all the tasks in the current table view.
 */

- (void)complete:(BOOL)done
{
    for (TaskCell *cell in self.tableView.visibleCells) {

        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
        Task *task = [self.tasks objectAtIndex:[indexPath row]];

        if (done)
        {
            if (![task completed]) {
                [cell setInactive];
                [task complete];
            }
        }
        else
        {
            [cell setActive];
            [task uncomplete];

        }
    }
}


/*!
 Uncomplete all cells
 */

- (void)completeAll
{
    [self complete:YES];
    [self reloadData];
}

/*!
 Uncomplete all cells
 */

- (void)uncompleteAll
{
    [self complete:NO];
    [self reloadData];
}


/*!
 Sort the array using the title.
 */

- (void)sortByName
{
    if (self.tasks.count < 2)
    {
        return;
    }

    Task* task1 = self.tasks[0];
    Task* task2 = self.tasks[1];
    
    BOOL sorted = !([task1.title compare:task2.title] == NSOrderedAscending);
    [self.tasks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Task* task1 = sorted ? obj1 : obj2;
        Task* task2 = sorted ? obj2 : obj1;
        
        return [task1.title compare:task2.title];
    }];
    
    [self reloadData];

}


/*!
 Sort the array using the completion.
 */

- (NSComparisonResult)compare:(Task*)task1 task2:(Task*)task2
{
    if (task1.completed && !task2.completed)
    {
        return NSOrderedAscending;
    }
    if ([task1 inProgress] && !task2.completed)
    {
        return NSOrderedAscending;
    }
    if ([task1 completed] && [task2 inProgress])
    {
        return NSOrderedAscending;
    }
    if (![task1 completed] && [task2 completed])
    {
        return NSOrderedDescending;
    }
    if (![task1 completed] && [task2 inProgress])
    {
        return NSOrderedDescending;
    }
    if ([task1 inProgress] && [task2 completed])
    {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}


- (void)sortByCompletion
{
    if (self.tasks.count < 2)
    {
        return;
    }
    
    Task* task1 = self.tasks[0];
    Task* task2 = self.tasks[1];
    
    BOOL sorted = ![self compare:task1 task2:task2];
    [self.tasks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Task* task1 = sorted ? obj1 : obj2;
        Task* task2 = sorted ? obj2 : obj1;
        
        return [self compare:task1 task2:task2];
    }];
    
    [self reloadData];
    
}


- (void)reloadData
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}




- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self reloadData];
}


- (void)enterTaskName:(NSIndexPath *)indexPath
{
    
    [AlertView alertWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0) prompt:@"Task name:" placeholder:@"Enter name of the task" textBlock:^(NSString *text) {
        
        Task* task = [[Task alloc] initWithTitle:[NSString stringWithFormat:text, [NSDate date]]];
        if (self.parentTask)
        {
            [self.parentTask addChild:task];
        }
        [self.tasks addObject:task];
        [task release];

        id cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setTask:task];
        
        [self reloadData];


    } leftTitle:@"Cancel" leftBlock:^{
        
        [self reloadData];

    } rightTitle:@"Ok" rightBlock:^{

        [self reloadData];

    }];
    
}

@end
