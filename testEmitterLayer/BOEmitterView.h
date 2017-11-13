//
//  BOEmitterView.h
//  testEmitterLayer
//
//  Created by Virendra Shakya on 11/13/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
  BOEmitterType_Snow,
  BOEmitterType_Confetti,
  BOEmitterType_Fireworks
} BOEmitterType;

@interface BOEmitterView : UIView
- (instancetype)initWithEmitterType:(BOEmitterType)emitterType;
- (void)decayOverTime:(NSTimeInterval)interval;
@end
