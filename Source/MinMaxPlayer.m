//
//  MinMaxPlayer.m
//  ConnectGame
//
//  Created by Tzu-Chieh Chang on 2/15/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "MinMaxPlayer.h"


@implementation MinMaxPlayer{
    int maxdepth;
    
}
int const winReward=1000; //if computer win, -100 if player win

+(id)newPlayer:(int)difficulty{
    return [[MinMaxPlayer alloc] init:difficulty];
}

- (id)init:(int)difficulty{
    self = [super init];
    if (!self) return(nil);
    maxdepth = difficulty;
    
    return self;
}

- (CGPoint)nextMove{
    int nextSteps[Grid];
    int reward = INT32_MIN;
    int maxIndex=-1;
    [self nextAvailableSteps:nextSteps];
    
    for(int i=0; i<Grid; i++){
        if(nextSteps[i]!=-1){
            int tmp = [self evalStep:ccp(i,nextSteps[i]) PLAYER:2 DEPTH:maxdepth];
            if(tmp>reward){
                reward = tmp;
                maxIndex = i;
            }
        }
    }
    if(maxIndex>-1)
        return ccp(maxIndex,nextSteps[maxIndex]);
    else
        return ccp(-1,-1);//some error happen
}

- (int)evalStep:(CGPoint)next PLAYER:(int)player DEPTH:(int)depth{
    //player human:1 player computer: 2
    //undo the move before each return if not keep recursion
    plate[(int)next.y][(int)next.x] = player;
    int result = [PlayScene checkWin];
    if(result==3){
        plate[(int)next.y][(int)next.x] = 0;
        return 0;
    }
    else if(player==1 && result==1){
        plate[(int)next.y][(int)next.x] = 0;
        return -winReward*depth;
    }
    else if(player==2 && result==2){
        plate[(int)next.y][(int)next.x] = 0;
        return winReward*depth;
    }

    if(depth == 1){//stop recursion and game is not end
        plate[(int)next.y][(int)next.x] = 0;
        return 0;
    }
    else{//keep recursion
        int reward = (player==1)? INT32_MIN:INT32_MAX;
        int nextSteps[Grid];
        [self nextAvailableSteps:nextSteps];
        for (int i=0; i<Grid; i++) {
            if(nextSteps[i]!=-1)
                reward = (player==1)? MAX(reward,[self evalStep:ccp(i,nextSteps[i]) PLAYER:2 DEPTH:depth-1]):MIN(reward,[self evalStep:ccp(i,nextSteps[i]) PLAYER:1 DEPTH:depth-1]);
        }
        reward = reward/(10^(maxdepth - depth+1));
        plate[(int)next.y][(int)next.x] = 0;
        return reward;//temp
    }
}

- (int *)nextAvailableSteps:(int [Grid])nextSteps{
    
    for(int i=0; i<Grid; i++){
        nextSteps[i]=-1;//if no step available for the column
        for(int j=Grid-1; j>=0; j--){
            if(plate[j][i]==0){
                nextSteps[i] = j;
                break;
            }
                
        }
    }
    
    return nextSteps;
}

@end
