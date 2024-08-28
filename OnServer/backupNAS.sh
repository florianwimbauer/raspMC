# Dieses Skript läuft auf meinem NAS und fährt täglich die Backups meines Minecraft Servers über rsync
# Gedacht als Cronjob (externes Zeitmanagement) zur automatischen Ausführung oder manuell bei Bedarf
# Auf Echos wurde verzichtet, da ich das nie sehen werde
# Es wird davon ausgegangen, dass beriets ein SSH-Key Pair ausgetauscht ist, daher kein Passwort

# SSH Nutzer PP(47Cki

# Spieler benachrichtigen, dass jetzt ein Backup erfolgt
echo Backupskript wird gestartet
echo Spieler benachrichtigen
ssh -p 12345 florianwimbauer@gaming.wimbauer.cloud 'sudo screen -S serverTerminal -p 0 -X stuff "say Neustart wegen Backup. We will be right back\n"'
sleep 5

# Server stoppen via systemd-service beedingung
echo Server wird angehalten
ssh -p 12345 florianwimbauer@gaming.wimbauer.cloud 'sudo systemctl stop mcStart.service'

# Speichern des Pfades zum letzten Backup (da später kopiert wird)
echo Duplikat vorbereiten
TOCOPY=$(ls -td Backups/*/ | head -1)

# Neuen Ordner für das Backup erstellen
echo Neuer Backupordner wird erstellt
BACKUP_DIR="Backups/$(date +%Y-%m-%d_%H-%M-%S)"
mkdir "$BACKUP_DIR"


# Inhalt des vorherigen Ordners in den neusten kopieren
echo Kopie wird erstellt
echo von XX $TOCOPY XX der Inhalt nach XX $BACKUP_DIR XX
cp -ar $TOCOPY* $BACKUP_DIR/

# Backup anstoßen & speichern in den neusten Ordner
echo RSYNC wird angestoßen
rsync -arz -e "ssh -p 12345" florianwimbauer@gaming.wimbauer.cloud:/opt/minecraft-server/world/* $BACKUP_DIR --rsync-path="sudo rsync"
# -a archive
# -z Komprimmiere
# -r Rekursiv alle Unterstrukturen
# -e Def. für SSH Verwendung

# Überprüfen, ob rsync erfolgreich war
if [ $? -eq 0 ]; then
  echo "CHECK Synchronisation erfolgreich!"
else
  echo "ERR Fehler bei der Synchronisation."
fi

# Server wieder starten
echo "Starte Server wieder"
if ssh -p 12345 florianwimbauer@gaming.wimbauer.cloud 'sudo systemctl start mcStart.service'
then
echo "CHECK Neustart erfolgreich. Backup abgeschlossen"
else 
echo "ERR Fehler beim Neustarten!"
fi