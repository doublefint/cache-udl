# cache-udl
Export/Import sources in UDL format for [ISC Caché 2016.2](http://www.intersystems.com/our-products/cache/cache-overview/)

# Installation
Download code and run
```
do $System.OBJ.ImportDir("/dir/cache-udl","*.xml;*.cls;*.mac;*.int;*.inc;*.dfi","ck",,1)
```
or
import the [release](https://github.com/intersystems-ru/cache-udl/releases) to the namespace.

Map sc package to %All namespace to make it visible in any namespace.

## Setup working directory ( optional )
```
NS> w ##class(sc.code).workdir("/path/to/your/working/directory/")
```
## Export to working directory:
```
NS> d ##class(sc.code).export()
```
## Import:
```
NS> d ##class(sc.code).import()
```
