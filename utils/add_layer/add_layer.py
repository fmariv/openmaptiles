# -*- coding: utf-8 -*-
"""
/***************************************************************************
 Add layer

Script that adds a new layer to the OpenMapTiles schema.
***************************************************************************/
"""

import argparse
import os
import shutil


parser = argparse.ArgumentParser(description="Script que afegeix una nova capa a l'esquema OpenMapTiles.")
# Add layer name argument
parser.add_argument("layer_name", help="Nom de la capa que es vol afegir a l'esquema.", type=str)
# Get the argument
layer_name = parser.parse_args().layer_name

# Create a new folder for the layer in the layers directory
dir_path = os.path.dirname(__file__)
dir_layer = os.path.join(dir_path, '../../layers', layer_name)
os.mkdir(dir_layer)

# Copy template SQL and YAML files to the new directory
template_dir = os.path.join(dir_path, '')
sql_template = os.path.join(template_dir, 'template.sql')
yaml_template = os.path.join(template_dir, 'template.yaml')
sql_layer = os.path.join(dir_layer, '%s.sql' % layer_name)
yaml_layer = os.path.join(dir_layer, '%s.yaml' % layer_name)
shutil.copyfile(sql_template, sql_layer)
shutil.copyfile(yaml_template, yaml_layer)

# Edit the layer files to give the new layer's name
for file in sql_layer, yaml_layer:
    with open(file, 'r') as f:
        data = f.read().replace('template', layer_name)

    with open(file, 'w') as f:
        f.write(data)

# TODO add the new layer to the openmaptiles.yaml file
