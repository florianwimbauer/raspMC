# Dieses Skript kümmert sich darum, dass die Minecraft Server Version immer aktuell ist
# Gedacht als Cronjob bei externem Timing.

# Verzeichnis, in dem der Minecraft-Server gespeichert wird

# URL, um die neueste Minecraft-Server-Version zu erhalten
LATEST_VERSION_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"

# Funktion zum Herunterladen der neuesten Server-JAR
download_latest() {
    echo "Lade die neueste Minecraft-Version herunter..."

    echo "Server stoppen"
    # Anhaltebenachrichtigung
    screen -S serverTerminal -p 0 -X stuff "say Neustart wegen Minecraft-Update. We will be right back!\n"
    sleep 5
    # Stop des Servers
    screen -S serverTerminal -p 0 -X stuff "stop\n"

    # Hole die neueste Version-Informationen
    VERSION_DATA=$(curl -s $LATEST_VERSION_URL)

    # Extrahiere die neueste Version und die Download-URL
    LATEST_VERSION=$(echo $VERSION_DATA | jq -r '.latest.release')
    DOWNLOAD_URL=$(echo $VERSION_DATA | jq -r --arg version "$LATEST_VERSION" '.versions[] | select(.id == $version) | .url')

    # Hole den Download-Link für die server.jar der neuesten Version
    SERVER_JAR_URL=$(curl -s $DOWNLOAD_URL | jq -r '.downloads.server.url')

    # Lade die neueste JAR herunter
    curl -o "/opt/minecraft-server/server.jar" "$SERVER_JAR_URL"

    echo "Aktualisierung abgeschlossen. Die neueste Version ($LATEST_VERSION) wurde heruntergeladen."
    echo Server wird wieder gestartet... Übergabe an Start-Skript
    boot.sh
}

# Funktion zum Überprüfen der aktuellen Version
check_for_update() {
    echo "Überprüfe auf neue Minecraft-Version..."

    # Hole die aktuell installierte Version (falls vorhanden)
    if [ -f "/opt/minecraft-server/server.jar" ]; then
        INSTALLED_VERSION=$(java -jar "/opt/minecraft-server/server.jar" --version 2>&1 | grep 'version' | awk '{print $NF}')
        echo "Aktuell installierte Version: $INSTALLED_VERSION"
    else
        echo "Kein Minecraft-Server installiert. Starte den Download der neuesten Version."
        INSTALLED_VERSION=""
    fi

    # Hole die neueste Version von Mojang
    LATEST_VERSION=$(curl -s $LATEST_VERSION_URL | jq -r '.latest.release')

    echo "Neueste verfügbare Version: $LATEST_VERSION"

    # Wenn die installierte Version veraltet ist oder nicht existiert, aktualisiere
    if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
        echo "Eine neue Version ist verfügbar. Starte die Aktualisierung..."
        download_latest
    else
        echo "Neuste Version bereits installiert"
    fi
}

# Hauptskript
check_for_update
