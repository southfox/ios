//
//  IntroScene.m
//  Shinpuru
//
//  Created by Javier Fuchs on 2/26/14.
//  Copyright Hungry And Foolish 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "NewtonScene.h"
#import "CCNode+HF.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // image background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"Default.png"];
    CGSize size = [[CCDirector sharedDirector] viewSize];
    background.position = ccp(size.width/2, size.height - background.h / 2);
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Shinpuru | シンプル" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    CCButton *firstButton = [CCButton buttonWithTitle:@"[ 1. Saisho no | 最初の ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    firstButton.color = [CCColor redColor];
    firstButton.positionType = CCPositionTypeNormalized;
    firstButton.position = ccp(0.5f, 0.35f);
    [firstButton setTarget:self selector:@selector(firstSceneClicked:)];
    [self addChild:firstButton];

    // Next scene button
//    CCButton *newtonButton = [CCButton buttonWithTitle:@"[ Newton Physics ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    newtonButton.positionType = CCPositionTypeNormalized;
//    newtonButton.position = ccp(0.5f, 0.20f);
//    [newtonButton setTarget:self selector:@selector(onNewtonClicked:)];
//    [self addChild:newtonButton];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)firstSceneClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    // start newton scene with transition
    // the current scene is pushed, and thus needs popping to be brought back. This is done in the newton scene, when pressing back (upper left corner)
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------


- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    [[OALSimpleAudio sharedInstance] playBg:@"hero_overture.mp3" loop:YES];
    
}

@end
