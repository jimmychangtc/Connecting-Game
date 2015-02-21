//
//  EndScene.h
//  ConnectGame
//
//  Created by Tzu-Chieh Chang on 2/14/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EndScene : CCNode {
    CGSize mobileDisplaySize;
}

+ (CCScene*) sceneWithResult:(int)result;
- (void)moveToMain:(id)sender;
@end
