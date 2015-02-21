//
//  EndScene.m
//  ConnectGame
//
//  Created by Tzu-Chieh Chang on 2/14/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "EndScene.h"


@implementation EndScene

+ (CCScene*) sceneWithResult:(int)result{
    
    CCScene* endScene  =  [ CCBReader  loadAsScene: @"EndScene" ];
    EndScene* myScene = (EndScene*)[endScene.children objectAtIndex:0];
    myScene->mobileDisplaySize = [[CCDirector sharedDirector] viewSize];
    CCLabelTTF* gameResult;
    
    if (result == 1) {
        gameResult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You Win!"] fontName:@"Arial Rounded MT Bold" fontSize:40 ];
        gameResult.color = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
    }
    else if(result == 2){
        gameResult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You Lose"] fontName:@"Arial Rounded MT Bold" fontSize:40];
        gameResult.color = [CCColor colorWithRed:0.0 green:1.0 blue:0.0];
    }
    else{
        gameResult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Tie!"] fontName:@"Arial Rounded MT Bold" fontSize:40];
        gameResult.color = [CCColor colorWithRed:0.0 green:0.5 blue:1.0];
    }
    
        gameResult.position = ccp(myScene->mobileDisplaySize.width/2, myScene->mobileDisplaySize.height*8/10);
    [myScene addChild:gameResult];

    
    return endScene;
}

- (void)moveToMain:(id)sender{
    CCScene  * MainScene  =  [ CCBReader  loadAsScene: @"MainScene" ];
    [[ CCDirector  sharedDirector ]  replaceScene: MainScene ];
}

@end
