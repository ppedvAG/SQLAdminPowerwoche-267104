--HADR

/*
1. Logshipping
Die "Low-Budget" DR-Lösung.
Logshipping basiert auf automatisierten Jobs, die Transaktionsprotokoll-Sicherungen von einer Primärinstanz auf eine oder mehrere Sekundärinstanzen kopieren und dort wiederherstellen.

Setup: Erfordert ein gemeinsames Netzwerk-Share. Ein SQL Agent Job sichert das Log auf dem Primärserver, ein zweiter kopiert es, ein dritter stellt es auf dem Sekundärserver (im Modus NORECOVERY oder STANDBY) wieder her.

Funktionsweise: Zeitversetzte Replikation (z. B. alle 15 Minuten).

Vorteile: Sehr einfach einzurichten; schützt vor logischen Fehlern (man kann das Restore verzögern); geringe Hardware-Anforderungen.

Nachteile: Kein automatischer Failover; Datenverlustrisiko in Höhe des Backup-Intervalls (RPO); Sekundärdatenbank ist während des Restores nicht lesbar.

2. Database Mirroring (Spiegeln)
Die veraltete, aber noch vorhandene Technologie.
Hinweis: Microsoft markiert Mirroring seit Jahren als "deprecated" (veraltet). In SQL Server 2025 ist es für Bestandssysteme noch da, sollte aber durch (Basic) Availability Groups ersetzt werden.

Setup: Punkt-zu-Punkt Verbindung zwischen zwei Instanzen. Optional ein "Witness" für automatischen Failover.

Funktionsweise: Überträgt Log-Records direkt vom Prinzipal zum Spiegel.

Vorteile: Automatischer Failover möglich (mit Witness); synchrone Übertragung (kein Datenverlust).

Nachteile: Nur pro Datenbank (nicht als Gruppe); wird nicht mehr weiterentwickelt; proprietäres Protokoll.

3. SQL Failover Cluster Instance (FCI)
Schutz für die gesamte Instanz.

Setup: Basiert auf einem Windows Server Failover Cluster (WSFC). Alle Knoten greifen auf einen gemeinsamen Speicher (SAN, S2D oder Azure Shared Disks) zu.

Funktionsweise: Die gesamte SQL-Instanz läuft auf einem Knoten. Fällt dieser aus, startet die Instanz auf einem anderen Knoten neu.

Vorteile: Schützt die komplette Instanz (inkl. Logins, Agent Jobs, TempDB); keine doppelte Storage-Kosten für Daten (da Shared Storage).

Nachteile: Shared Storage ist ein "Single Point of Failure"; Neustart der Instanz bei Failover (kurze Downtime); kein Schutz bei Storage-Defekt.

4. Always On Availability Groups (AG)
Der "Goldstandard" für Enterprise-Umgebungen.

Setup: Benötigt ebenfalls einen WSFC, nutzt aber lokalen Speicher auf jedem Server. Datenbanken werden in Gruppen zusammengefasst.

Funktionsweise: Log-Daten werden in Echtzeit an bis zu 8 Sekundärrepliken gesendet. SQL Server 2025 optimiert hier den "Commit-Flow" für noch geringere Latenz.

Vorteile: Automatischer Failover ohne Instanz-Neustart; Sekundärserver können für Read-Only-Abfragen oder Backups genutzt werden; kein Shared Storage nötig.

Nachteile: Erfordert Enterprise Edition; hohe Lizenzkosten; komplexere Konfiguration.

5. Basic Availability Groups (BAG)
Die "AG Light" für die Standard Edition.
Eingeführt als moderner Ersatz für das Mirroring.

Setup: Identisch zu AGs, aber stark eingeschränkt.

Funktionsweise: Unterstützt nur zwei Knoten (Primär und eine Sekundärreplik).

Vorteile: Bietet die Robustheit von AGs für die günstigere Standard Edition; unterstützt TLS 1.3 (wichtig in SQL 2025).

Nachteile: Nur eine Datenbank pro Gruppe; Sekundärseite ist nicht lesbar; keine Enterprise-Features wie "Read-Only Routing".

*/

Vergleichstabelle für SQL Server 2025
Feature					Logshipping			FCI (Cluster)		Always On AG		Basic AG
Schutzebene				Datenbank			Instanz				Datenbank-Gruppe	Einzelne DB
Failover				Manuell				Automatisch			Automatisch			Automatisch
Storage					Lokal (Kopie)		Shared Storage		Lokal (Kopie)		Lokal (Kopie)Lesbare Sekundärseite	
EingeschränktNeinJa (Enterprise)NeinEditionAlleAlleEnterprise

