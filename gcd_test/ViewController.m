//
//  ViewController.m
//  gcd_test
//
//  Created by KJ Tsanaktsidis on 2/01/2015.
//  Copyright (c) 2015 Stile Education. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //make a request to our local webserver
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://localhost:10001/something.txt"]];
        NSHTTPURLResponse* res;
        NSData* resdata = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
        
        NSString* resstr = [[NSString alloc] initWithData:resdata encoding:NSUTF8StringEncoding];
        NSLog(@"Got alphabet: %@", resstr);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
