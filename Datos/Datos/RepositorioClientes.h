//
//  RepositorioClientes.h
//  Datos
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepositorioClientes : NSObject


@property (nonatomic, strong) NSMutableArray * clientes;

+(RepositorioClientes *) sharedInstance;
-(void) leer;
-(void) guardar;
-(NSString *) ruta;


@end
