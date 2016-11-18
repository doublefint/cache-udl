/// UDL export/import all for ISC Caché 2016.2
/// Usage:
/// w ##class(sc.all).workdir( "c:\your\work\dir\")
/// d ##class(sc.all).export()
/// d ##class(sc.all).import()
Class sc.all [ Abstract ]
{

/// export all available code
ClassMethod export(generated = 0, system = 0, percent = 0)
{
		
	#define export(%code, %file) $system.OBJ.ExportUDL(%code, %file,"/diffexport")
	#define isGenerated(%code) ##class(%RoutineMgr).IsGenerated( %code )	
	#define isPercented(%code) ("%" = $e(%code))
	#define log w !, code, " -> ", filename
		
	#; classes 
	s rs = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:Summary")
	if rs.Execute() {
		
		while rs.%Next(){
			
			s code = rs.Name _ ".cls", isSystem = rs.System
			if ( 'system && isSystem ) continue
			if ( 'generated && $$$isGenerated( code ) ) continue
			if ( 'percent && $$$isPercented( code ) ) continue
			s filename = ..filename( code )
			$$$log
			d $$$export( code, filename )
			
		} s rs=""
	} 
	
	#; routines
	s rs = ##class(%ResultSet).%New("%Routine:RoutineList")
	if rs.Execute() {
		
    	while rs.%Next() {
	    	
	 		s code = rs.Name
	 		if ( 'generated && $$$isGenerated( code ) ) continue
			s filename = ..filename( code )
			$$$log
			d $$$export( code, filename )
			
	    } s rs=""
	}
	
	
	#; dfi
	#define export(%code, %file)  ##class(%DeepSee.UserLibrary.Utils).%Export( %code, %file, 0 )
	s sql = "Select fullName as Name From %DeepSee_UserLibrary.FolderItem"
    s rs = ##class(%SQL.Statement).%ExecDirect( .stm, sql )
    while rs.%Next() {
		s code = rs.Name, filename = ..filename( code )_".dfi"
		$$$log
		d $$$export( code, filename )
		
	} s rs=""
	
    Q
}

/// import all from workdir
ClassMethod import(qspec = "-d", ByRef err = "", recurse = 1, ByRef loaded = "", verbose = 1) As %Status
{
	#define push(%dir) s dirs( $i( dirs ) ) = %dir
	#define next(%i,%dir) s %i=$o( dirs( "" ), 1, %dir )  k:%i'="" dirs(%i)
	#define isDirectory(%type) ( %type = "D" )
	#define log w !, filename, " ", +sc
	
	s sc = 1, dirs = "", dir = ..workdir() $$$push(dir)
		
	s rs = ##class(%ResultSet).%New( "%Library.File:FileSet" )
	for { $$$next(i,dir) Q:i=""  Q:dir=""
		
		s sc = rs.Execute( dir, "*.*" ) Q:'sc
		
		while rs.Next() {
			
		   s filename = rs.Name
		   
		   if $$$isDirectory(rs.Type) {
			 
			 if recurse $$$push(filename) 
			 continue  
			 
		   }
		  
		   s ext = $p(filename, ".", *)
		   if $zcvt(ext,"l") = "dfi" {
			   
			   s sc = ##class(%DeepSee.UserLibrary.Utils).%Import( filename, 1, 0, 0, "", .loaded )
		   
		   } else {
			   
			   s sc = $system.OBJ.Load( filename, qspec, .err, .loaded)
			   
		   }
		   
		   if verbose $$$log
		   
	    }
	}
	Q sc
}

/// Translate ( codename ) into ( filename )
ClassMethod filename(code)
{
	s path = ##class(%File).NormalizeFilename(code, ..workdir())
	s dir = ##class(%File).GetDirectory( path )
	d:'##class(%File).DirectoryExists( dir ) ##class(%File).CreateDirectoryChain( dir )
	Q path
}

/// get or set working directory for export/import source
ClassMethod workdir(workdir)
{
	s gln = ..gln() s:$d(workdir) @gln = workdir
	///zu(12) namespace directory by default
	#define nsdir $zu(12,"") 
	Q $g(@gln, $$$nsdir)
}

/// gl[obal] n[ame] - storage for settings
ClassMethod gln() [ CodeMode = expression, Private ]
{
"^"_$classname()
}

}

