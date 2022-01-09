//
//  IntentHandler.m
//  Shortcuts
//
//  Created by han on 2022/1/8.
//  Copyright © 2022 唐天成. All rights reserved.
//

#import "IntentHandler.h"
#import "ChargingAudioIntent.h"

@interface IntentHandler ()<ChargingAudioIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {

    return self;
}


- (void)handleChargingAudio:(ChargingAudioIntent *)intent completion:(void (^)(ChargingAudioIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:))
{

    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"231401593.mp3" ofType:nil];

    if([[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        NSData *data = [NSData dataWithContentsOfFile:audioPath];
        INFile *infile = [INFile fileWithData:data filename:@"chargingAudio.mp3" typeIdentifier:nil];
        completion([ChargingAudioIntentResponse successIntentResponseWithAudioFile:infile]);
    } else {

        completion([[ChargingAudioIntentResponse alloc] initWithCode:(ChargingAudioIntentResponseCodeFailure) userActivity:nil]);

    }

}


@end









