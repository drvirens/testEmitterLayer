//
//  BOEmitterView.m
//  testEmitterLayer
//
//  Created by Virendra Shakya on 11/13/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOEmitterView.h"

static void *gBoundsContext = &gBoundsContext;


@interface BOEmitterView ()
@property (nonatomic) BOOL hasAppliedConstraints;
@property (nonatomic) BOEmitterType emitterType;
@property (nonatomic) CGFloat decayAmount;
@end


@implementation BOEmitterView

- (instancetype)initWithEmitterType:(BOEmitterType)emitterType
{
    if (self = [super initWithFrame:CGRectZero]) {
        _emitterType = emitterType;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //self.backgroundColor = [UIColor magentaColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (BOEmitterType_Snow == _emitterType) {
        [self setupSnow];
    } else if (BOEmitterType_Confetti == _emitterType) {
        [self setupConfetti];
    } else if (BOEmitterType_Fireworks == _emitterType) {
        [self setupFireworks];
    } else {
    }
    _decayAmount = 5.f;

    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) options:NSKeyValueObservingOptionNew context:gBoundsContext];
}

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) context:gBoundsContext];
    } @catch (NSException *ex) {
    }
}

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}
- (CAEmitterLayer *)emitterLayer
{
    return (CAEmitterLayer *)self.layer;
}

#pragma mark - setupSnow
- (void)setupSnow
{
}

#pragma mark - setupConfetti
- (void)setupConfetti
{
    //configure emittery layer
    CAEmitterLayer *e = [self emitterLayer];
    ({
        e.emitterPosition = CGPointMake(self.bounds.size.width / 2.f, 0.f);
        e.emitterSize = self.bounds.size;
        e.emitterShape = kCAEmitterLayerLine;
    });

    //configure cell
    CAEmitterCell *c = [CAEmitterCell emitterCell];
    ({
        c.contents = (__bridge id)[UIImage imageNamed:@"confetti.png"].CGImage;
        c.name = @"confetti";
        c.birthRate = 120.f;
        c.lifetime = 5.0f;
        //c.color = [UIColor blueColor].CGColor;
        c.redRange = 0.8f;
        c.blueRange = 0.8f;
        c.greenRange = 0.8f;
        //      c.alphaRange = 0.8f;

        c.velocity = 250.f;
        c.velocityRange = 50.f;
        c.emissionRange = (CGFloat)M_PI_2;
        c.emissionLongitude = (CGFloat)M_PI;
        c.yAcceleration = 150.f;
        c.scale = 1.f;
        c.scaleRange = 0.2f;
        c.spinRange = 10.f;
    });

    e.emitterCells = @[ c ];
}

#pragma mark - setupFireworks
- (void)setupFireworks
{
}

#pragma mark - decay over time

static NSTimeInterval const kDecayStepInterval = 0.1;
- (void)decayStep
{
    CAEmitterLayer *e = [self emitterLayer];
    e.birthRate -= _decayAmount;
    if (e.birthRate < 0) {
        e.birthRate = 0;
    } else {
        [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval];
    }
}

- (void)decayOverTime:(NSTimeInterval)interval
{
    CAEmitterLayer *e = [self emitterLayer];
    _decayAmount = (CGFloat)(e.birthRate / (interval / kDecayStepInterval));
    [self decayStep];
}

- (void)stopEmitting
{
    CAEmitterLayer *e = [self emitterLayer];
    e.birthRate = 0.0;
}

- (void)onBoundsAvailable
{
    self.layer.frame = self.bounds;
}
#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(bounds))] &&
        object == self &&
        context == gBoundsContext) {
        [self onBoundsAvailable];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - constraints
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}
- (void)applyConstraints
{
}
- (void)updateConstraints
{
    if (!self.hasAppliedConstraints) {
        [self applyConstraints];
        self.hasAppliedConstraints = YES;
    }
    [super updateConstraints];
}

@end
