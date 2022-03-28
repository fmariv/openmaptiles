## Contextmaps & OpenMapTiles [![Build Status](https://github.com/openmaptiles/openmaptiles/workflows/OMT_CI/badge.svg?branch=master)](https://github.com/openmaptiles/openmaptiles/actions)

ContextMaps és el nou referent de cartografia topogràfica transversal de l’Institut Cartogràfic i Geològic de Catalunya

ContextMaps està basat en tecnologia VectorTiles (vector/imatge), desenvolupada originalment per l’empresa Mapbox, d’accés ràpid i àgil, amb nou contingut geogràfic, disposa de serveis i funcionalitats pròpies que permeten generar, personalitzar i publicar cartografia de manera flexible. Alhora, també visualitzar i analitzar de forma contínua la informació i el coneixement geogràfic de Catalunya amb la de la resta del món, amb la informació OpenStreetMap, seguint l’esquema OpenMapTiles.

OpenMapTiles és un esquema de tessel·les extensible i obert basat en OpenStreetMap. Aquest projecte s'utilitza per generar tessel·les vectorials per a mapes en línia. OpenMapTiles permet crear mapes base amb capes generals que contenen informació topogràfica. Més informació [openmaptiles.org](https://openmaptiles.org/) i [maptiler.com/data/](https://www.maptiler.com/data/).

L'esquema OpenMapTiles s'utilitza en molts projectes d'arreu del món i la mida de les fitxes vectorials finals s'ha de tenir en compte en qualsevol actualització.

- :link: Esquema https://openmaptiles.org/schema
- :link: Docs https://openmaptiles.org/docs
- :link: Dades: https://www.maptiler.com/data/
- :link: Crear capa própia https://github.com/openmaptiles/openmaptiles-skiing

## Esquema

OpenMapTiles consisteix en una col·lecció de capes documentades i autònomes que es poden modificar i adaptar.
Les capes juntes formen el conjunt de tessel·les OpenMapTiles.

:link: [Estudiar l'esquema vectorial](http://openmaptiles.org/schema)

- [aeroway](https://openmaptiles.org/schema/#aeroway)
- [boundary](https://openmaptiles.org/schema/#boundary)
- [building](https://openmaptiles.org/schema/#building)
- [housenumber](https://openmaptiles.org/schema/#housenumber)
- [landcover](https://openmaptiles.org/schema/#landcover)
- [landuse](https://openmaptiles.org/schema/#landuse)
- [mountain_peak](https://openmaptiles.org/schema/#mountain_peak)
- [park](https://openmaptiles.org/schema/#park)
- [place](https://openmaptiles.org/schema/#place)
- [poi](https://openmaptiles.org/schema/#poi)
- [transportation](https://openmaptiles.org/schema/#transportation)
- [transportation_name](https://openmaptiles.org/schema/#transportation_name)
- [water](https://openmaptiles.org/schema/#water)
- [water_name](https://openmaptiles.org/schema/#water_name)
- [waterway](https://openmaptiles.org/schema/#waterway)

### Configuració 

OpenMapTiles ha fet una gran feina a l'hora de dockeritzar cada pas del procés, de manera que sempre que es tingui una versió de docker i `make` instal·lada localment, es pot reproduir aquest procés.

El primer pas és clonar el repositori i construir el tileset.

```bash
git clone git@autogitlab.icgc.local:f.martin/openmaptiles.git
cd openmaptiles
# Construeix el mapeig imposm, el projecte tm2source i recull tot l'SQL
sudo make
```

Això generarà els fitxers de configuració utilitzats per importar dades d'OSM a la base de dades PostGIS. S'hauria de veure una carpeta de `build/` al repositori, que conté uns quants fitxers de mapeig i processos SQL. 

Es poden executar els passos manuals següents (per a una millor comprensió) o utilitzar l'script `quickstart.sh` proporcionat per descarregar i importar automàticament l'àrea determinada. Si no es dóna l'àrea, s'importarà Albània.

```
./quickstart.sh <area>
```

### Preparar la base de dades

La base de dades es construeix a un contenidor de Docker amb la imatge de [PostGIS](https://hub.docker.com/r/openmaptiles/postgis) d'Openmaptiles. 

Abans de res, hem d'aixecar la base de dades.

```bash
sudo make start-db
```

Aquest comandament descarregarà les imatges de docker necessàries i aixecarà una versió local de PostGIS. El port al qual ens podem conectar a la base de dades pot canviar cada cop que s'aixequi la base, per la qual cosa es recomana fixar-lo mitjançant, per exemple, [Portainer](https://www.portainer.io/).

Un cop aixecada la base de dades, s'han d'importar dades externes des d'[OpenStreetMapData](http://osmdata.openstreetmap.de/), [Natural Earth](http://www.naturalearthdata.com/) i [Etiquetes OpenStreetMap Lake](https://github.com/lukasmartinelli/osm-lakelines). Els límits naturals dels països de la Terra s'utilitzen en els nivells de zoom més baixos.

```bash
make import-data
```

Ara, s'han de descarregar les dades d'OSM que siguin necessàries. Es poden baixar extractes de dades d'OpenStreetMap de qualsevol font com [Geofabrik](http://download.geofabrik.de/) i emmagatzemar el fitxer PBF al directori `./data`. Per utilitzar una font de descàrrega específica, utilitzeu `download-geofabrik`, `download-bbbike` o `download-osmfr`, o utilitzeu `download` per fer que escolleixi automàticament l'àrea. Podeu utilitzar `area=planet` per a tot el conjunt de dades OSM (molt gran). Tingueu en compte que si teniu més d'un fitxer `data/*.osm.pbf`, cada comanda `make` sempre requerirà el paràmetre `area=...` (o podeu simplement `export area=...` primer) .

```bash
sudo make download area=spain
```

Ara s'han d'importar les [dades d'OpenStreetMap](https://github.com/openmaptiles/openmaptiles-tools/tree/master/docker/import-osm) amb les regles de mapeig de
`build/mapping.yaml` (que ha estat creat per `make`). Executar després de qualsevol canvi en la definició de capes.

```bash
sudo make import-osm
```

Un cop importades les dades d'OSM, s'han d'importar les etiquetes de Wikidata. Si una característica OSM té [Key:wikidata](https://wiki.openstreetmap.org/wiki/Key:wikidata), es comprovarà l'element corresponent a Wikidata i s'utilitzaran les seves [etiquetes](https://www.wikidata.org/wiki/Help:Label) pels idiomes que figuren a [openmaptiles.yaml](openmaptiles.yaml). Així, les tessel·les vectorials generades inclouran diversos idiomes al camp de nom.

Aquest pas utilitza [Wikidata Query Service](https://query.wikidata.org) per descarregar només els ID de Wikidata que ja existeixen a la base de dades.

```bash
sudo make import-wikidata
```

### Treballar les capes

Per cada capa de l'esquema OpenMaptiles hi ha una carpeta al directori `layers` amb tota la informació necessària, disposada en diferents arxius. Els més importants per nosaltres i que s'hauran de modificar a conveniència són els següents:

```
<nom_capa>.SQL    # és on es defineixen les comandes SQL a executar, per exemple per generar vistes o per definir la funció que generarà les tessel·les
<nom_capa>.yaml   # és on es defineixen els atributs de la capa, els arxius SQL necessaris per generar la capa i la query SQL que es cridarà en el moment de generar les tessel·les
```

També és important, per les capes definides a l'esquema OpenMaptiles, l'arxiu `mapping.yaml`. Aquest és el fitxer de mapeig Imposm, una biblioteca dissenyada específicament per importar dades OSM a una base de dades PostGIS. El fitxer de mapeig defineix com Imposm crearà l'esquema de la base de dades per importar els registres des d'un fitxer OSM.

Cada vegada que es modifiqui el fitxer `mapping.yaml` d'una capa o s'afegeixin noves etiquetes OSM, s'ha de'executar `make` i `make import-osm` per recrear taules (potencialment amb dades addicionals) a PostgreSQL. Amb les noves dades, també hi pot haver nous registres de Wikidata.

```bash
sudo make clean
sudo make
sudo make import-osm
sudo make import-wikidata
```

Cada vegada que es modifiqui el codi SQL de la capa, s'ha d'executar `sudo  make` i `sudo make import-sql`.

```bash
sudo make clean
sudo make
sudo make import-sql
```

Ara ja està tot preparat per **generar les tessel·les vectorials**. Per defecte, `./.env` especifica tot el planeta BBOX per als zooms 0-7, però executar `generate-bbox-file` analitzarà el fitxer de dades i establirà el paràmetre `BBOX` per limitar la generació de tessel·les. Així mateix, es poden editar els zooms a `./.env`. No obstant, Cada nivell de zoom addicional augmentarà exponencialment el temps que triga a generar les tessel·les.

```bash
sudo make generate-bbox-file  # generar bbox - no és necessari per tot el planeta
sudo make generate-tiles-pg   # generar tessel·les
```

### Afegir noves capes
S'ha creat un petit script de Python que permet afegir noves capes a l'esquema OpenMapTiles de manera molt fàcil. Simplement s'haurà d'executar `add_layer.py "nom_capa"` i automàticament es crearà una nova carpeta al directori `layers` amb el nom de la nova capa i l'arxiu SQL i YAML definits a l'apartat anterior. Aquest arxius, però, s'han d'editar manualment a conveniència.

### Workflow per generar les tessel·les
Si es reprodueix de principi a final aquest codi es generarà un fitxer .mbtiles a partir d'un fitxer .osm.pbf
```bash
sudo make clean                  # clean / remove existing build files
sudo make                        # generate build files
sudo make start-db               # start up the database container.
sudo make import-data            # Import external data from OpenStreetMapData, Natural Earth and OpenStreetMap Lake Labels.
sudo make download area=spain    # download spain .osm.pbf file -- can be skipped if a .osm.pbf file already existing
sudo make import-osm             # import data into postgres
sudo make import-wikidata        # import Wikidata
sudo make import-sql             # create / import sql funtions 
sudo make generate-bbox-file     # compute data bbox -- not needed for the whole planet
sudo make generate-tiles-pg      # generate tiles
```
En lloc de cridar `make download area=spain`, es pot afegir un fitxer .osm.pbf a la carpeta `data` `openmaptiles/data/la_teva_area.osm.pbf`


## Llicènsia

Tot el codi d'aquest repositori es troba sota la llicència de Reconeixement 4.0 Internacional de Creative Commons [ICGC/OSM](./LICENSE.md). Per aquest motiu, quan es reutilitza, només cal citar-ne l’autoria; no és necessari fer cap altre tràmit ni signar cap document.