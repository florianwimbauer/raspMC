# raspMC
Minecraft-Server for RaspberryPI

In diesem Respository befinden sich die gesammte Funktionalität meiens Minecraftserver-Hosting Prozesses.
Ich nutze folgendes Setup:
- Raspberry Pi 4B in einem Remote Netzwerk
- Synology NAS in meinem lokalen Netzwerk als Backup-Initiator

Auf dem Raspberry läuft das aktuelleste PiOS auf basis von Debian
Damit der Server auc nach Stromverlust immer läuft, sorgt mein boot.sh Skript dafür, dass der Server Ordnungsgemäß gestartet wird. Dieses Skript wird als systemd Service automatisch nach einem Neustart des RasPis ausgeführt & läuft mit einer screen Sitzung im Hintergrund, was es mir erlaubt, jederzeit auf die Serverkonsole zuzugreifen.

Des Weiteren gibt es das Skript update.sh und updateJDK.sh das jeweils per cronjob ein mal Täglich prüft, ob es eine neue Javaverison bzw. Minecraft Version gibt und diese dann ggf. installiert. Steht eine Installation an, wird der Server zuvor ordnungsgemäß heruntergefahren und im anschluss wieder gestartet. Dabei wird nie das boot.sh Skript selbst aufgerufen, sondern immer nur der systemd Service gestartet oder gestoppt.

Auf der NAS Seite sorgt das Skript backupNAS.sh (welches ein mal am Tag mit dem Aufgabenmanager des Synology DMS ausgeführt wird) dafür, dass per ssh und rsync ein Backup des minecraft world Ordners gemacht wird. Es werden immer 5 Backups dabehalten, das älteste wird nach jedem neuen Backup gelöscht. 

Obwohl im remote Netzwerk nur eine 16Mbit Downlink und eine 5MBit Uplink Bandbreite erzielt werden kann, läuft der Server & der Backupprozess effizient, schnell und stabil.

