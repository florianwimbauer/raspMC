# Dieses Skript läuft auf meinem NAS und fährt täglich die Backups meines Minecraft Servers über rsync
# Gedacht als Cronjob (externes Zeitmanagement) zur automatischen Ausführung oder manuell bei Bedarf
# Auf Echos wurde verzichtet, da ich das nie sehen werde
# Es wird davon ausgegangen, dass beriets ein SSH-Key Pair ausgetauscht ist, daher kein Passwort

# SSH Nutzer PP(47Cki

# Verbinden mit SSH
ssh -p 12345 gaming.wimbauer.cloud

# Server benachrichtigen, dass jetzt ein Backup erfolgt
ssh -p 12345 gaming.wimbauer.cloud 'screen -S serverTerminal -p 0 -X stuff "say Neustart wegen Backup. We will be right back\n"'
sleep 5
# Server stoppen
ssh -p 12345 gaming.wimbauer.cloud 'screen -S serverTerminal -p 0 -X stuff "stop\n"'

# Backup anstoßen
rsync -arz -e "ssh -p 12345" gaming.wimbauer.cloud/opt/minecraft-server/world backups
# -a archive
# -z Komprimmiere
# -r Rekursiv alle Unterstrukturen
# -e Def. für SSH Verwendung

# Überprüfen, ob rsync erfolgreich war
if [ $? -eq 0 ]; then
  echo "Synchronisation erfolgreich!"
else
  echo "Fehler bei der Synchronisation."
fi

exit 0