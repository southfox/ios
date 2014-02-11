//
//  LaunchViewController.m
//  Tasks
//
//  Created by Javier Fuchs on 5/13/13.
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "LaunchViewController.h"
#import "CALayer+Category.h"

NSString* kLaunchSkipNotification = @"LaunchSkipNotification";


static CGPoint diplomaCenter;
static CGPoint familyCenter;
static CGPoint foodCenter;
static CGPoint guyCenter;
static CGPoint holidayCenter;
static CGPoint moneyCenter;
static CGPoint processCenter;
static CGPoint workCenter;

@interface LaunchViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *diploma;
@property (nonatomic, retain) IBOutlet UIImageView *family;
@property (nonatomic, retain) IBOutlet UIImageView *food;
@property (nonatomic, retain) IBOutlet UIImageView *guy;
@property (nonatomic, retain) IBOutlet UIImageView *holiday;
@property (nonatomic, retain) IBOutlet UIImageView *money;
@property (nonatomic, retain) IBOutlet UIImageView *process;
@property (nonatomic, retain) IBOutlet UIImageView *work;

@end

@implementation LaunchViewController



- (void)dealloc
{
    [_diploma release]; _diploma = nil;
    [_family release]; _family = nil;
    [_food release]; _food = nil;
    [_guy release]; _guy = nil;
    [_holiday release]; _holiday = nil;
    [_money release]; _money = nil;
    [_process release]; _process = nil;
    [_work release]; _work = nil;
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    diplomaCenter = self.diploma.center;
    familyCenter = self.family.center;
    foodCenter = self.food.center;
    guyCenter = self.guy.center;
    holidayCenter = self.holiday.center;
    moneyCenter = self.money.center;
    processCenter = self.process.center;
    workCenter = self.work.center;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self runAnimations];
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)animateWork
{
    [self.work.layer rotateAroundPoint:self.guy.center duration:2];    
}


- (void)animateFamily
{
    
    CGPoint point = self.family.layer.position;

    CGFloat zero = 0.0f;
    CGFloat x1 = -20.0f;
    CGFloat x2 = x1 * 2;
    CGFloat x3 = x2 * 1.5;
    CGFloat y1 = +20.0f;
    CGFloat y2 = y1 * 2;
    CGPoint p[7] = {
        {point.x, point.y},
        {point.x + x1,  point.y + y2},
        {point.x + x2,  point.y + y1},
        {point.x + x1,  point.y + zero},
        {point.x + x3,  point.y + y1},
        {point.x + x3,  point.y + zero},
        {point.x + zero, point.y + y1}
    };
    
    [self.family.layer moveUsingPath:p steps:7 duration:0.5f];

}

- (void)animateFood
{
    [self.food.layer rotate:0.1];
}

- (void)animateGuy
{
    CGSize size = self.guy.frame.size;
    size.width *= 2.5f;
    size.height *= 2.5f;
    self.guy.contentMode = UIViewContentModeScaleToFill;
    [self.guy.layer resize:size duration:10.0f];
}

- (void)animateHoliday
{
    CGSize size = self.holiday.frame.size;
    size.width *= 0.1f;
    size.height *= 0.1f;
    self.holiday.contentMode = UIViewContentModeScaleToFill;
    [self.holiday.layer resize:size duration:1.0f];
}

- (void)animateDiploma
{
    CGPoint point = _diploma.layer.position;

    CGFloat zero = 0.0f;
    CGFloat x1 = 200.0f;
    CGFloat x2 = x1 * 2;
    CGFloat y1 = -200.0f;
    CGFloat y2 = y1 * 2;
    CGPoint p[5] = {
        {point.x, point.y},
        {point.x + x1,  point.y + y2},
        {point.x + x2,  point.y + y1},
        {point.x + x1,  point.y + zero},
        {point.x + zero, point.y + y1}
    };
    
    [self.diploma.layer moveUsingPath:p steps:5 duration:10.0f];
}


- (void)animateMoney
{
    CGPoint point = _money.layer.position;
    
    CGFloat x1 = -50.0f;
    CGFloat y1 = -50.0f;
    CGFloat y2 = y1 * 2;
    CGPoint p[2] = {
        {point.x, point.y},
        {point.x + x1,  point.y + y2}
    };
    
    [self.money.layer moveUsingPath:p steps:2 duration:0.5f];
}


- (void)animateProcess
{
    [self.process.layer rotate:1.3f];
}

- (void)runAwayDiploma
{
    CGPoint point0 = _diploma.layer.position;
    
    CGPoint point1 = CGPointMake(point0.x - self.view.frame.size.width, point0.y);
    
    _diploma.layer.position = point1;
}

- (void)runAwayProcess
{
    CGPoint point0 = _process.layer.position;
    
    CGPoint point1 = CGPointMake(-point0.x*2, -point0.y*2);
    
    _process.layer.position = point1;
}


- (void)runAwayHoliday
{
    CGPoint point0 = _holiday.layer.position;
    
    CGPoint point1 = CGPointMake(point0.x, -point0.y*2);
    
    _holiday.layer.position = point1;
}



- (void)runAwayFamily
{
    CGPoint point0 = _family.layer.position;
    
    CGPoint point1 = CGPointMake(point0.x + self.view.frame.size.width, -point0.y*2);
    
    _family.layer.position = point1;
}



- (void)runAwayMoney
{
    CGPoint point0 = _money.layer.position;
    
    CGPoint point1 = CGPointMake(point0.x + self.view.frame.size.width, point0.y + self.view.frame.size.height);
    
    _money.layer.position = point1;
}


- (void)runAwayWork
{
    CGPoint point0 = _work.layer.position;
    
    CGPoint point1 = CGPointMake(point0.x, point0.y + self.view.frame.size.height);
    
    _work.layer.position = point1;
}

- (void)runAwayFood
{
    CGPoint point0 = _food.layer.position;
    
    CGPoint point1 = CGPointMake(-point0.x*2, point0.y + self.view.frame.size.height);
    
    _food.layer.position = point1;
}



- (void)runAwayAnimations
{
    [self runAwayDiploma];
    [self runAwayProcess];
    [self runAwayHoliday];
    [self runAwayFamily];
    [self runAwayMoney];
    [self runAwayWork];
    [self runAwayFood];
}

- (void)runAnimations
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self runAwayAnimations];
    } completion:^(BOOL finished) {
        [self runLastAnimations];
    }];
}

- (void)runLastAnimations
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self resetCenter];
    } completion:^(BOOL finished) {
        [self animateAll];
    }];
}

- (void)resetCenter
{
    self.diploma.center = diplomaCenter;
    self.family.center = familyCenter;
    self.food.center = foodCenter;
    self.guy.center = guyCenter;
    self.holiday.center = holidayCenter;
    self.money.center = moneyCenter;
    self.process.center = processCenter;
    self.work.center = workCenter;
}

- (void)animateAll
{
    [self.diploma.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
    [self.family.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
    [self.food.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
    [self.holiday.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
    [self.money.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
    [self.process.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
    [self.work.layer rotateAroundPoint:self.guy.center duration:(arc4random()%2+1)/(arc4random()%10+1)];
//    [self animateDiploma];
//    [self animateFamily];
//    [self animateFood];
//    [self animateGuy];
//    [self animateHoliday];
//    [self animateMoney];
//    [self animateProcess];
//    [self animateWork];
}

- (void)notifySkip
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLaunchSkipNotification object:nil];
}

- (IBAction)skipIntro
{
    [self performSelector:@selector(notifySkip)];
}

@end
