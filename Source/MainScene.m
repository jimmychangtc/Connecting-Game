#import "MainScene.h"

@implementation MainScene

- (void)selectLevel:(id)sender{
    int level=4;
    CCButton* btn = (CCButton*)sender;
    if ([btn isEqual:btn4]) {
        level = 4;
    }
    else if([btn isEqual:btn5]){
        level = 5;
    }
    else if ([btn isEqual:btn6]){
        level = 6;
    }
        
    
    CCScene  * gameplayScene  =  [PlayScene sceneWithLevel:level];
    
    [[ CCDirector  sharedDirector ]  replaceScene: gameplayScene ];
    
    
}
@end
