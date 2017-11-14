//
//  ViewController.m
//  testEmitterLayer
//
//  Created by Virendra Shakya on 11/13/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "ViewController.h"
#import "BOEmitterView.h"


@interface ViewController ()
@property (nonatomic) BOEmitterView *emitterView;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self testEmitter];
}

- (void)testEmitter
{
    if (self.emitterView) {
        return;
    }
    BOEmitterView *emitterView = [[BOEmitterView alloc] initWithEmitterType:BOEmitterType_Confetti];
    [emitterView decayOverTime:2.f];
    self.emitterView = emitterView;
    [self.view addSubview:emitterView];

    [self applyConstraints];
}

- (void)applyConstraints
{
    UIView *parent = self.view;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.emitterView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.f constant:20.f];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.emitterView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1.f constant:-20.f];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.emitterView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeading multiplier:1.f constant:20.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.emitterView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-20.f];
    [parent addConstraints:@[ top, bottom, left, right ]];
}
@end
