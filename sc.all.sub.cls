/// Export different types of modules in different subfolders
Class sc.all.sub Extends sc.all
{

/// test.dfi -> /dfi/test.dfi
/// test.cls -> /cls/test.cls
/// etc
ClassMethod filename(code)
{
	s ext = $p( code, ".", * ), ext = $zcvt( ext, "l" )
	#; for each type - different directory
	s wd = ..workdir() s:ext'="" wd = ##class(%File).NormalizeDirectory( ext, wd ) 
	d:'##class(%File).DirectoryExists( wd ) ##class(%File).CreateDirectoryChain( wd )
	
	s filename = ##class(%File).NormalizeFilename( code, wd )
	#; for *.dfi filename can contain folders
	if ext = "dfi" {
		s path = ##class(%File).GetDirectory( filename ) 
		d:'##class(%File).DirectoryExists( path ) ##class(%File).CreateDirectoryChain( path )
	}
	Q filename
}

/// import from workdir all files with ts newer than code ts in db
ClassMethod importUpdated(qspec = "cku-d", ByRef err = "", recurse = 1, ByRef loaded = "", verbose = 1) As %Status
{
	#define push(%dir) s dirs( $i( dirs ) ) = %dir
	#define next(%i,%dir) s %i=$o( dirs( "" ), 1, %dir )  k:%i'="" dirs(%i)
	#define isDirectory(%type) ( %type = "D" )
	#define log w !, filename, " -> ", codename, " ", +sc
	
	s sc = 1, dirs = "", dir = ..workdir() $$$push(dir)
		
	s rs = ##class(%ResultSet).%New( "%Library.File:FileSet" )
	for { $$$next(i,dir) Q:i=""  Q:dir=""
		
		s sc = rs.Execute( dir, "*.*" ) Q:'sc
		
		while rs.Next() {
		   
		   s filename = rs.Name 		   
		   
		   if $$$isDirectory( rs.Type ) {
			 if ( recurse ) $$$push(filename) ;push directory 
			 continue  
		   }
		   
		   s filets = rs.DateModified
		   s codename = ..codename( filename, .ext )      
		   s codets = ..codets( codename, ext )
		   
		   if ( filets '] codets ) continue
		   
		   /*
		   w !, " ************* import ************** "
		   w !, "file: ", filets
		   w !, "code: ", codets
		   */
		   
		   if ext = "dfi" {
			   
			   s sc = ##class(%DeepSee.UserLibrary.Utils).%Import( filename, 1, 0, 0, "", .loaded )
		   
		   } else {
			   
			   s sc = $system.OBJ.Load( filename, qspec, .err, .loaded)
			   
		   }
		   
		   if verbose $$$log
	    }
	}
	Q sc
}

/// presumable codename 
ClassMethod codename(filename, ByRef ext = "")
{
	s ext = $p( filename, ".", * ), ext = $zcvt( ext, "l" )
	s path = ##class(%File).NormalizeDirectory( ext, ..workdir() )
	s codename = $p( filename, path, 2 )
	if ext = "dfi" {
		s fullname  = $tr( codename, "\", "/" ) ; return fullname for dfi in $$$IsWINDOWS
		Q $p( fullname, ".", 1, *-1 ) ;remove extension 
	}
	Q codename
}

ClassMethod codets(codename, ext)
{
	s ts = ""
	if ext'="dfi" {
		s ts = ##class(%RoutineMgr).TS( codename )
	} else {
		s sql="Select timeModified From %DeepSee_UserLibrary.FolderItem Where fullname = ?"	
		s rs = ##class(%SQL.Statement).%ExecDirect( , sql, codename )
		if rs.%Next() { 
			s utcts = rs.timeModified
			s utch = $zdth( utcts, 3, , 3 ) ;utc internal format
			s loch = $zdth( utch, -3 ) ; utc to local timezone
			s ts = $zdt( loch, 3, ,0 ) ; local timestamp*/
		}
	}
	Q $p( ts, "." ) ;remove ms
}

}

