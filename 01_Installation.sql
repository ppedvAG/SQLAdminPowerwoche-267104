--VM

/*
Vorteil: 
		Backup der VMs und Restore auf anderen Server
		Hardware per KOnfi editierbar

SQL Server hat Settings zur Hardware, die solange bestehen bleiben , bis du sie änderst

NUMA Sockel und Kernen

Inventar: 1 Sockel
		  4 Kerne 
		  24 GB
		  1 HDD

		  4GB für OS

HV-DC:  RAM 2048 bis 4096
	    2 Kerne
		NUMA--> Hardwaretopology anwenden


HV-SQL1:  4 Kerne
          1 Sockel
		  kein dynmischer RAM sondern fix: 6144 MB


HV-SQL2:  4 Kerne
		  1 Sockel
		  kein dynamischer RAM sondern fix: 6144 MB

HV-SQL2:
Zugangsdaten
SQL\Administrator
ppedv2026!


SETUP

Best Practice:

-- Trenne DAten von Logs!
-- TempDb auf andere Platte
-- TempDB mehr Datendateien soviel wie Kerne, aber max 8 
-- Volumewartungstask (Windows Einstellung)
-- den MAXDOP definieren (MAXDOP sollte = Anzahl der Kerne sein , aber nicht mehr als 8
				--> wieviele Kerne darf eine Abfrage maximal bekommen)
-- Arbeitsspeicher: dem SQL Server einen maximalen Wert vorgeben (= Gesamt RAM - OS)
-- SA langes Kennwort
--

--Instanz
Standardinstanz: Port 1433
jede weitere Instanz: Random Port  (6342 oder 42384) und einen Namen
PC\Instanzname



--Setup

-------------------------------------------------------------
 Volumewartungstask = reine Windows Sicherheitseinstellung
-------------------------------------------------------------

jede Vergrößerung verbraucht eigtl die doppelte Schreibarbeit
da Windows zuerst die Dateien vergrößert und mit 0 beschreibt
eigtl ein Sicherheitsfeature: Lokaler Sicherheitsrichtlinien.. Zuweisen von Benutzerrechten
----------------------
0101010110101111111111
----------------------

aktiviert man den Volumewartungstask dann kann SQL Server eigenständig vergrößeren
ohne vorher ausnullen-- schneller,

-->IO reduzieren! Aber einem guten Admin ist das wurst! ;-) Siehe DB Settings


-------------------------------------------------------------
Dienstkonten
-------------------------------------------------------------
SQL Server (DB)
SQL Agent (jobs)
SQL Volltextsuche 
SQL Browser = Rezeption (Port 1434 UDP)
Im Falle von mehereren INstanzen

Konten brauchen vorab keine Rechte, aber nur lokal
svcSQL
svcAgent

-------------------------------------------------------------
Security
-------------------------------------------------------------
2 Auth-Verfahren:
Windows / gemischte Auth (Windows+SQL Logins)
--> Gemischte Auth:  sa (alle Rechte)
                     komplexes Kennwort(mind 14 bis 17 Zeichen) deaktivieren
					 dafür ein Ersatzkonto anlegen  saadmin   saMaria
-- Windows Admins sind kein SQL Admin

-------------------------------------------------------------
Datenbankpfaden
-------------------------------------------------------------
Trenne Daten von Logfile physikalisch (2 HDDs oder mehr)
BackupPfad

-------------------------------------------------------------
TempDB
-------------------------------------------------------------
Mülleimer für vieles und viele
#t
RAM AUslagerungen beim Verschätzen von RAM Verbrauch der Abfragen
--Gib der Tempdb eig HDDs und denk dra: Trenne Daten von Log
Soviele Dateien wie Kerne, aber max 8
Mehrere Tabellen könne im gleiche Block liegen, aber nur ein Thread darf zugreifen

-T1117 Uniform Extents... kein gleichzeitiger Zugriff mehr auf denselben Block, da jede Tabelle einen eig block belegt
-T1118 immer gleich große Dateien.. greife nie in den Mechanismus ein, der wird sonst ausser Kraft gesetzt



-------------------------------------------------------------
MAXDOP
-------------------------------------------------------------
MAXDOP = Anzahl der log Prozessoren (max 8)
-->eigenes Kapitel


-------------------------------------------------------------
--Arbeitspeicher. 
-------------------------------------------------------------
Setup schlägt für SQL einen max Speicher vor, um im worst Case nicht den gesamten RAM zu belegen
--DAS OS braucht auch Luft zum atmen... das Setup berücksichtigt die Umgebung (OS)
--Sharepoint: Wenn auf dem Server 95% Speicherauslastung, dann stellt SP Dienste
--Begrenze den SQL Server immer im Bereich MAX RAM... (OS)

-- MAX Speicher 
-- immer einstellen 
-- wird sofort umgesetzt

-- MIN Speicher 
-- nur bei Konkurrrenz (weiterer Instanz) sinnvoll
-- der mind RAM Wert wird erst belegt, wenn SQL Daten entsprechend abgelegt hat.
*/