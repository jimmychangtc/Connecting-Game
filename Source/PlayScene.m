//
//  PlayScene.m
//  ConnectGame
//
//  Created by Tzu-Chieh Chang on 2/13/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "PlayScene.h"


@implementation PlayScene{
    MinMaxPlayer* AIplayer;
}




int const Grid = 8;
int const AILevel = 5;
int Level;
int plate[8][8];
int steps;

+ (CCScene*) sceneWithLevel:(int)level{

    CCScene* gameplayScene  =  [ CCBReader  loadAsScene: @"PlayScene" ];
    PlayScene* myScene = (PlayScene*)[gameplayScene.children objectAtIndex:0];
    
    Level = level;
    myScene.userInteractionEnabled = TRUE;
    myScene->AIplayer = [MinMaxPlayer newPlayer:AILevel];
    myScene->removebtn.enabled = false;
    myScene->isRemove = false;
    myScene->chips = [NSMutableArray array];
    myScene->mobileDisplaySize = [[CCDirector sharedDirector] viewSize];
    myScene->newSize = myScene->mobileDisplaySize.width/Grid;
    myScene->currentPlayer = 1;
    steps = 0;
    CCLabelTTF* gameName;
    
    gameName = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Connect %d", level] fontName:@"Arial" fontSize:25];
    gameName.position = ccp(myScene->mobileDisplaySize.width/2, myScene->mobileDisplaySize.height*9/10);
    [myScene addChild:gameName];
    
    for(int j=0 ; j<Grid ; j++){
        for(int i=0 ; i<Grid ; i++){
            plate[i][j]=0;
            CCSprite* slot = [CCSprite spriteWithImageNamed:@"slot_edited.png"];
            slot.scale = myScene->newSize / slot.contentSize.width;
            //anchor point is left-bottom corner
            slot.position = ccp(myScene->newSize/2+i*myScene->newSize,myScene->mobileDisplaySize.height*0.6-j*myScene->newSize);
            [myScene addChild:slot z:2];
        }
    }
    return gameplayScene;
}

- (void)moveToMain:(id)sender{
    
    
    CCScene  * MainScene  =  [ CCBReader  loadAsScene: @"MainScene" ];
    [[ CCDirector  sharedDirector ]  replaceScene: MainScene ];
    
}

- (void)moveToEnd:(int)winner{
    CCScene  * endScene  =  [EndScene sceneWithResult:winner];
    [[ CCDirector  sharedDirector ]  replaceScene: endScene ];
}

-(void)removeChip:(id)sender{
    isRemove = !isRemove;
    NSLog(@"remove chips!!!!");
}

-(CGPoint)pix2plate:(CGPoint)pixposition{
    //pixel anchor point is left-top corner
    CGPoint new = ccp((int)(pixposition.x/newSize), (int)((pixposition.y-mobileDisplaySize.height*0.4+newSize/2)/newSize));
    
    return new;
}

-(CGPoint)plate2pix:(CGPoint)plateposition{
    //to the grid center
    CGPoint new = ccp((plateposition.x+0.5)*newSize, mobileDisplaySize.height*0.4+plateposition.y*newSize);
    
    return new;
}

+ (int)checkWin{
    //no result: 0, player1 win: 1, player2 win: 2, tie: 3
    
    bool same = false;
    
    for(int i=0; i<Grid-Level+1; i++){//check rows
        for(int j=0; j<Grid; j++){
            if (plate[j][i]!=0){
                same = true;
                for(int k=1; k<Level; k++){
                    if(plate[j][i]!=plate[j][i+k])
                        same = false;
                }
                if (same)
                    return plate[j][i];
            }
        }
    }
    
    for(int j=0; j<Grid-Level+1; j++){//check columns
        for(int i=0; i<Grid; i++){
            if (plate[j][i]!=0){
                same = true;
                for(int k=1; k<Level; k++){
                    if(plate[j][i]!=plate[j+k][i])
                        same = false;
                }
                if (same)
                    return plate[j][i];
            }
        }
    }
    
    for(int j=0; j<Grid-Level+1; j++){//check diagonal
        for(int i=0; i<Grid-Level+1; i++){
            
            if (plate[j][i]!=0){ //check left-top to right-bottom
                same = true;
                for(int k=1; k<Level; k++){
                    if(plate[j][i]!=plate[j+k][i+k])
                        same = false;
                }
                if (same)
                    return plate[j][i];
            }
            
            if (plate[j][i+Level-1]!=0){ //check right-top to left-bottom
                same = true;
                for(int k=1; k<Level; k++){
                    
                    if(plate[j][i+Level-1]!=plate[j+k][i+Level-1-k])
                        same = false;
                }
                if (same){
                    return plate[j][i+Level-1];
                }
            }
            
        }
    }
    
    if(steps == (Grid*Grid))
        return 3;
    else
        return 0;
}

-(void)rotateChip:(int)x Y:(int)y{
    
    NSLog(@"remove (%d,%d)",x,y);
    //rotate array
    int indexX;
    int indexY;
    int winner;
    
    for(int j=y; j>=0; j--){
        if(j == 0)
            plate[j][x] = 0;
        else
            plate[j][x] = plate[j-1][x];
    }
    
    
    for (CCSprite* chip in chips) {
        indexX = (int)[self pix2plate:ccp(chip.position.x, mobileDisplaySize.height-chip.position.y)].x;
        indexY = (int)[self pix2plate:ccp(chip.position.x, mobileDisplaySize.height-chip.position.y)].y;

        
        if(indexX == x && indexY < y){
            id move = [CCActionMoveTo actionWithDuration:0.3 position:ccp(chip.position.x,chip.position.y-newSize)];
            [chip runAction:move];
        }
        
    }
    /*
     id action = [CCScaleTo actionWithDuration:0.5 scaleX:self.Xposition scaleY:1];
     id ease   = [CCEaseInOut actionWithAction:action rate:4];
     id call = [CCCallBlockN actionWithBlock:^(CCNode* node) {
     // node is the sprite, you may have to cast it:
     CCSprite* someSprite = (CCSprite*)node;
     
     // do whatever you need to do with sprite here…
     someSprite.opacity = CCRANDOM_0_1() * 255;
     }];
     id sequence = [CCSequence actions:action, ease, call, nil];
     
     [someObject[i] runAction:sequence];
    */
    winner = [PlayScene checkWin];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if(winner != 0)
            [self moveToEnd:winner];
    });
    
    
}

-(void)addChip:(int)x Y:(int)y PLAYER:(int)player{
    CCSprite* chip;
    chip = (currentPlayer==1)?(CCSprite*)[CCBReader load:@"redChip"]:(CCSprite*)[CCBReader load:@"greenChip"];
    chip.scale = newSize / chip.contentSize.width;
    chip.position = ccp([self plate2pix:ccp(x,0)].x, mobileDisplaySize.height*0.68);
    [chips addObject:chip];
    
    if(player==1){
        steps++;
        if(steps!=0 && steps%5 == 0)
            removebtn.enabled = true;
        
    }

    plate[y][x] = player;
    currentPlayer = (currentPlayer==1)? 2:1;
    [self addChild:chip z:1];
    id move = [CCActionMoveTo actionWithDuration:0.3 position:ccp([self plate2pix:ccp(x,0)].x, mobileDisplaySize.height*0.6-y*newSize)];
    [chip runAction:move];
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
   
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    int selected = (int)[self pix2plate:ccp(touchLocation.x,touchLocation.y)].x;
    
    if(currentPlayer==1){
    if(isRemove){//remove chips
        CGPoint selectedChip = [self pix2plate:touchLocation];
        int selectX = (int)selectedChip.x;
        int selectY = (int)selectedChip.y;
        NSLog(@"(%d,%d) = %d",(int)selectedChip.x,(int)selectedChip.y,plate[(int)selectedChip.y][(int)selectedChip.x]);
        NSLog(@"chips: %lu",(unsigned long)[chips count]);
        
        if(selectX >= 0 && selectX < Grid && selectY >=0 && selectY < Grid && plate[selectY][selectX] == 1){
            unsigned long index;
            for (CCSprite* chip in chips) {

                if(touchLocation.x > chip.position.x-newSize/2
                   && touchLocation.x < chip.position.x+newSize/2
                   && mobileDisplaySize.height - touchLocation.y > chip.position.y-newSize/2
                   && mobileDisplaySize.height - touchLocation.y < chip.position.y+newSize/2){
                    
                    index = [chips indexOfObject:chip];
                    [self removeChild:chip];
                }
                
               
                
                /*
                if (CGRectContainsPoint(chip.boundingBox, touchLocation)){
                    NSLog(@"got you!!!");
                    [self removeChild:chip];
                }*/
                
            }
            removebtn.enabled = false;
            [chips removeObjectAtIndex:index];
            [self rotateChip:selectX Y:selectY];
            isRemove = false;
        }
    }
    
    else{//add chips
        double delayInSeconds = 0.4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    /*
    int top=Grid-1;
    CCSprite* chip;
    if (currentPlayer==1) {
        chip = (CCSprite*)[CCBReader load:@"redChip"];
    }
    else{
        chip = (CCSprite*)[CCBReader load:@"greenChip"];
    }
    
    chip.scale = newSize / chip.contentSize.width;
    chip.position = ccp([self plate2pix:ccp(selected,0)].x, mobileDisplaySize.height*0.68);
    */
     /*
    chip.physicsBody.affectedByGravity = YES;
    chip.physicsBody.mass = 1.;
      [chip.physicsBody applyForce:ccp(chip.position.x*1000,0)];
    */

    int winner;
    for (int i=Grid-1; i>=0; i--) {
        if(plate[i][selected]==0){
            /*
            NSLog(@"add!!!!!");
            [chips addObject:chip];
            steps++;
            if(steps!=0 && steps%5 == 0)
                removebtn.enabled = true;
            plate[i][selected] = currentPlayer;
            top = i;
            currentPlayer = (currentPlayer==1)? 2:1;
            [self addChild:chip z:1];
            id move = [CCActionMoveTo actionWithDuration:0.3 position:ccp([self plate2pix:ccp(selected,0)].x, mobileDisplaySize.height*0.6-top*newSize)];
            [chip runAction:move];
             */
            [self addChip:selected Y:i PLAYER:currentPlayer];
            winner = [PlayScene checkWin];
            if(winner != 0){
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self moveToEnd:winner];
                });
            }
            
            break;
        }
        
        
    }
    
    if(currentPlayer==2){//computer term
            NSLog(@"yoooooooooo");
                CGPoint nextStep = [AIplayer nextMove];
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //code to be executed on the main queue after delay
                    
                    [self addChip:(int)nextStep.x Y:(int)nextStep.y PLAYER:2];
                    int winner = [PlayScene checkWin];

                    if(winner != 0){
                        double delayInSeconds = 1;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self moveToEnd:winner];
                        });
                    }

                });
                
    }

/*
    for (int i=0; i<8; i++) {
        
        NSLog(@"%d %d %d %d %d %d %d %d"
              ,plate[i][0]
              ,plate[i][1]
              ,plate[i][2]
              ,plate[i][3]
              ,plate[i][4]
              ,plate[i][5]
              ,plate[i][6]
              ,plate[i][7]
              );
    }*/
    }//end of add chip
}//end of if(currentplayer==1)
    
}


@end
