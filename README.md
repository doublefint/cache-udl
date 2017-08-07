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

# Usage

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

## Compile and Release:

Introduce cos.json file in the source root directory with settings for the code mask and for the name of the project. e.g.
```
cos.json
 "compileList": "Classes*.INC,classes*.CLS,*.DFI",
 "projectName": "myproject"
```
Run init method to initialize project settings:
```
NS> d ##class(sc.code).init()
```
Then run release to export all the classes in comileList into one "myproject.xml" release file. It will export it into the default for current Namespace directory.
```
NS> d ##class(sc.code).release()
```
Or compile it whenever you want to compile all the proejct related resources.
```
NS> d ##class(sc.code).compile()
```





