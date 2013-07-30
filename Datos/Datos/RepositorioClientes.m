//
//  RepositorioClientes.m
//  Datos
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "RepositorioClientes.h"
#import "Cliente.h"

@implementation RepositorioClientes

@synthesize clientes;

static RepositorioClientes * instancia;

-(id)init{
    if(self=[super init]){
        [self leer];
        if(self.clientes ==nil){
            self.clientes = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

-(void)guardar{
    NSMutableArray * clientesAGuardar = [[NSMutableArray alloc] init];
    
    for (Cliente * cliente in self.clientes) {
        NSDictionary * diccionario = [[NSDictionary alloc] initWithObjectsAndKeys:cliente.nombre, @"nombre", [NSNumber numberWithBool:cliente.debeDinero], @"debe",nil];
        [clientesAGuardar addObject:diccionario];
    }
    [clientesAGuardar writeToFile:[self ruta] atomically:YES];
}

-(NSString *)ruta{
    NSString * pathFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [pathFolder stringByAppendingPathComponent:@"clientes.plist"];
}

-(void)leer{
    NSArray * clientesLeidos = [[NSArray alloc] initWithContentsOfFile:[self ruta]];
    
    if (clientesLeidos!= nil) {
        self.clientes = [[NSMutableArray alloc] init];
        
        for (NSDictionary * diccionario in clientesLeidos) {
            Cliente * cliente = [[Cliente alloc] init];
            cliente.nombre = [diccionario objectForKey:@"nombre"];
            cliente.debeDinero = [[diccionario objectForKey:@"debe"] boolValue];
            
            [self.clientes  addObject:cliente];
        }
    }
}
+(RepositorioClientes *) sharedInstance{
    if(instancia == nil){
        instancia = [[RepositorioClientes alloc] init];
    }
    return instancia;
}

@end
