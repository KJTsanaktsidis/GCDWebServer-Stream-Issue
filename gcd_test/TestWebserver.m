#import <Foundation/Foundation.h>
#import "TestWebserver.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataRequest.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerStreamedResponse.h"

@implementation TestWebserver
{
    GCDWebServer* _server;
}

-(TestWebserver*) init;
{
    self->_server = [[GCDWebServer alloc] init];
    dispatch_time_t half_second = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    [self->_server
        addDefaultHandlerForMethod:@"GET"
        requestClass:[GCDWebServerDataRequest class]
        asyncProcessBlock:^(GCDWebServerRequest *request, GCDWebServerCompletionBlock completionBlock) {
            
            //Wait half a second before sending headers
            dispatch_after(half_second, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                GCDWebServerStreamedResponse* res =
                    [[GCDWebServerStreamedResponse alloc]
                        initWithContentType:@"text/plain"
                        asyncStreamBlock:^(GCDWebServerBodyReaderCompletionBlock dataCompletionBlock) {
                            
                            NSLog(@"Sending abcdefg");
                            dataCompletionBlock([@"abcdefg" dataUsingEncoding:NSUTF8StringEncoding], nil);
                            
                            dispatch_after(half_second, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                
                                NSLog(@"Sending hijklmnop");
                                dataCompletionBlock([@"hijklmnop" dataUsingEncoding:NSUTF8StringEncoding], nil);
                                dataCompletionBlock([[NSData alloc] init], nil);
                                NSLog(@"ended");
                            });
                    }];
                    completionBlock(res);
            });
    }];
    
    return self;
}

-(void) start
{
    [self->_server startWithPort:10001 bonjourName:nil];
}

-(void) stop
{
    [self->_server stop];
}

@end