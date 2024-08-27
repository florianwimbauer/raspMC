#!/bin/bash

# Diees Skript startet den Minecraft Server nach einem Stromausfall / Neustart des Raspberrys
# Gedacht als systemd-Service zum einmaligen Ausführen bei Stromausfall oder zum manuellen Ausführen bei Bedarf.
# VORSICHT: Skript prüft NICHT, ob der Server bereits läuft!

echo Skript zum Starten des Minecraft-Servers...

# Nach neustart starten wir im Root-Verzeichnis -> cd in Server-Directory mit Fehlerbehandlung
echo Wechsle in Server Directory...

if  cd /opt/minecraft-server

then
    echo CHECK Directory Exisitert 
else 
    echo ERR Server Directory existiert nicht
    kill $$
fi

# Testen, ob JDK da ist
if type -p java
then
    echo CHECK Java Runtime ist installiert
else
    echo ERR Fehler mit Java Installation
fi

sleep 2

# Testen, ob ium Server-Verzeichnis alle notwendigen Daten da sin
if test -f server.jar && test -d world 
then
    echo CHECK Server Dateien existieren
else
    echo ERR Server Daten sind nicht vollständig
fi

sleep 2

# Server Starten
echo Server wird gestartet

screen -d -m -S serverTerminal java -Xmx2G -Xms2G -jar server.jar nogui
# -d für detached, screen startet im Hintergrund
# -m screen wird geforced
# -S Prozess bekommt einen namen
# Flags in Startup für Ramzuweisung von 2GB max & initial

echo Warte auf Lebenszeichen...
sleep 15

#Testen ob der Serverstart erfolgreich war, in dem man schaut ob auf Port 25565 gelauscht wird
if nc -z localhost 25565
then
    echo "CHECK Minecraftserver erfolgreich gestartet"
else
    echo "ERR Server konnte nicht gestartet werden"
fi

# Ausgabe im Minecraftserer, dass Startup erfolgreich war
screen -S serverTerminal -p 0 -X stuff 'say Server per Skript automatisch neugestartet\nsay Viel Spaß beim Spielen wünscht Flo\n'

echo Serverstart erfolgreich durchgeführt\n

screen -r serverTerminal