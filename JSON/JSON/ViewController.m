//
//  ViewController.m
//  JSON
//
//  Created by Equipo Desarrollo 2 on 5/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

    IBOutlet UILabel * label;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData * kivaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cymetria.com/json/json.php"]];
        NSDictionary * json = nil;
        
        if(kivaData){
            json   = [NSJSONSerialization JSONObjectWithData:kivaData
                                                     options:kNilOptions
                                                       error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUIWithDictionary: json];
            });
        }
    });
}

-(void)updateUIWithDictionary: (NSDictionary *)json{
    @try {
        NSString * cadena = @"";
        NSString * valorJSON;
        for (int  i = 0; i<=1; i++) {
            valorJSON = [NSString stringWithFormat:@"El Producto %@ de nombre %@ tiene un precio de %@ y pertenece a %@",
                         json[@"articulos"][i][@"id"],
                         json[@"articulos"][i][@"nombre"],
                         json[@"articulos"][i][@"precio"],
                         json[@"articulos"][i][@"categoria"],
                         nil];
            cadena = [cadena stringByAppendingString:valorJSON];
        }
        
        label.text = [NSString stringWithFormat:@"Productos : %@", cadena, nil];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                   message:[NSString stringWithFormat:@"Error : %@", exception]
                                  delegate:nil
                         cancelButtonTitle:@"Cerrar"
                         otherButtonTitles:nil] show];
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
