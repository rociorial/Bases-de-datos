-- BDCreateDB2

IF DB_ID ('BDCreateDB2') IS NOT NULL
    DROP DATABASE BDCreateDB2;
GO

CREATE DATABASE BDCreateDB2
ON PRIMARY
    (NAME = 'DBCreateDB2_Data', 
     FILENAME = 'C:\basedatos\BDCreateDB2\DBCreateDB2_Data.mdf', 
     SIZE = 3MB, 
     FILEGROWTH = 15%)
LOG ON
    (NAME = 'DBCreateDB2_Log', 
     FILENAME = 'C:\basedatos\BDCreateDB2\DBCreateDB2_Log.ldf', 
     SIZE = 2MB, 
     MAXSIZE = 5MB, 
     FILEGROWTH = 15%)

EXEC sp_helpdb 'BDCreateDB2';


-- BDCreateDB3

IF DB_ID ('BDCreateDB3') IS NOT NULL
    DROP DATABASE BDCreateDB3;
GO

CREATE DATABASE BDCreateDB3
ON PRIMARY
    (NAME = 'BDCreateDB3_root', 
     FILENAME = 'C:\basedatos\BDCreateDB3\BDCreateDB3s_root.mdf', 
     SIZE = 8MB, 
     MAXSIZE = 9MB, 
     FILEGROWTH = 100KB),
    (NAME = 'BDCreateDB3_data1', 
     FILENAME = 'C:\basedatos\BDCreateDB3\BDCreateDB3_data1.ndf', 
     SIZE = 10MB, 
     MAXSIZE = 15MB,
     FILEGROWTH = 1MB)
LOG ON
    (NAME = 'BDCreateDB3_Log', 
     FILENAME = 'C:\basedatos\BDCreateDB3\BDCreateDB3_Log.ldf', 
     SIZE = 10MB, 
     MAXSIZE = 15MB, 
     FILEGROWTH = 1MB)
     
EXEC sp_helpdb 'BDCreateDB2';

-- Products2

CREATE DATABASE Products2;

EXEC sp_helpdb 'Products2';