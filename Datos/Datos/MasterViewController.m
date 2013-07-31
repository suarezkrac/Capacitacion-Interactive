//
//  MasterViewController.m
//  Datos
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//
#import "MasterViewController.h"
#import "RepositorioClientes.h"
#import "Cliente.h"
#import "DetailViewController.h"

@implementation MasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray * clientes = [RepositorioClientes sharedInstance].clientes;
    return [clientes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray * clientes = [RepositorioClientes sharedInstance].clientes;
    Cliente * cliente = [clientes objectAtIndex: indexPath.row];
    
    static NSString * nombreCeldas = @"celdasCliente";
    
    UITableViewCell * celda = [tableView dequeueReusableCellWithIdentifier:nombreCeldas];
 
    
    celda.textLabel.text = cliente.nombre;
    celda.detailTextLabel.text = (cliente.debeDinero) ? @"Es deudor" : @"Es amigo";
    celda.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return celda;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editar"]) {
        DetailViewController * detalle = [segue destinationViewController];
        
        NSMutableArray * clientes = [RepositorioClientes sharedInstance].clientes;
        Cliente * cliente = [clientes objectAtIndex: [self.tableView indexPathForSelectedRow].row];
        
        detalle.cliente = cliente;
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray * clientes = [RepositorioClientes sharedInstance].clientes;
        [clientes removeObjectAtIndex: indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

 
@end
