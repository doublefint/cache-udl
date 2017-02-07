# cache-udl
Export/Import sources in UDL format for [ISC Caché 2016.2](http://www.intersystems.com/our-products/cache/cache-overview/)

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
