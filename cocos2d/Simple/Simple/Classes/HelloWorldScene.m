//
//  HelloWorldScene.m
//  Simple
//
//  Created by Javier Fuchs on 2/26/14.
//  Copyright Hungry And Foolish 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "NewtonScene.h"
#import "CCNode+HF.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_player;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Add a sprite
    _player = [CCSprite spriteWithImageNamed:@"player.png"];
    _player.o  = ccp(_player.w/2,self.h/2);
    [self addChild:_player];
    
    // Animate sprite with action
//    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
//    [_player runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.o = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    // done
	return self;
}


// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
    [self schedule:@selector(addMonster:) interval:1.5];
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // translarte screen touch into scene coordinate
    CGPoint touchLocation = [touch locationInNode:self];
    
    // small triangle created by x and y offset from the origin point to the touch point
    // creating a new big triangle with the same ratio (one of the endpoints to be off the screen).
    CGPoint offset = ccpSub(touchLocation, _player.position);
    float ratio = offset.y/offset.x;
    int targetX = _player.w/2 + self.w;
    int targetY = (targetX*ratio) + _player.y;
    CGPoint targetPosition = ccp(targetX, targetY);
    
    // projectile sprite start at the same position as the player
    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"projectile.png"];
    projectile.o = _player.o;
    [self addChild:projectile];
    
    // target point for the projectile
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [projectile runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove]]];

    // move the player
    CCActionMoveTo *actionMovePlayer = [CCActionMoveTo actionWithDuration:1.0f position:ccp(_player.x, _player.y + offset.y / 2)];
    [_player runAction:actionMovePlayer];
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------


- (void)addMonster:(CCTime)dt;
{
    CCSprite *monster = [CCSprite spriteWithImageNamed:@"monster.png"];
    
    // vertical range for the monster to spawn.
    int minY = monster.h / 2;
    int maxY = self.h - monster.h / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // monster slightly off the screen of the right
    monster.o = ccp(self.w + monster.w/2, randomY);
    
    [self addChild:monster];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // animate moving the monster from right to left
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:ccp(-monster.w/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    
    [monster runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove]]];
    
}

@end
