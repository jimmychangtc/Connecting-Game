//
//  MinMaxPlayer.h
//  ConnectGame
//
//  Created by Tzu-Chieh Chang on 2/15/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayScene.h"
#import "limits.h"

@interface MinMaxPlayer : CCNode {
    
}

+ (id)newPlayer:(int)difficulty;

- (CGPoint)nextMove;

@end
