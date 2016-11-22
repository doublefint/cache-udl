/// Export different types of modules in different subfolders
Class sc.all.sub Extends sc.all
{

/// Translate ( codename ) into ( filename )
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

}

