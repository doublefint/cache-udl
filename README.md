# all.udl
Export/Import all sources in UDL format for ISC Caché 2016.2

## Setup working directory ( optional )
```
NS> w ##class(sc.all).workdir("/path/to/your/working/directory/")
```
## Export to working directory:
```
NS> d ##class(sc.all).export()
```
## Import:
```
NS> d ##class(sc.all).import()
```
