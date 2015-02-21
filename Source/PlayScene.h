//
//  PlayScene.h
//  ConnectGame
//
//  Created by Tzu-Chieh Chang on 2/13/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EndScene.h"
#import "MinMaxPlayer.h"

extern int const Grid;
extern int Level;
extern int steps;
extern int plate[8][8];

@interface PlayScene : CCNode {
    int newSize;
    int currentPlayer;
    bool isRemove;
    NSMutableArray* chips;
    CGSize mobileDisplaySize;
    CCButton* removebtn;
}

+ (CCScene*) sceneWithLevel:(int)level;

+ (int)checkWin;


@end
