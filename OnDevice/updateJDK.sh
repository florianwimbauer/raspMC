# Dieses Skript sorgt dafür, dass die Java Runtime immer aktuell ist.
echo "Überprüfe auf verfügbare Updates für JDK..."
sudo apt update

if sudo apt list --upgradable 2>/dev/null | grep -q "openjdk"
then
    echo "Java-Update verfügbar. Aktualisierung wird durchgeführt..."
    echo "Server stoppen"
    # Anhaltebenachrichtigung
    sudo screen -S serverTerminal -p 0 -X stuff "say Neustart wegen Java-Update. We will be right back!\n"
    sleep 5
    # Stop des Servers
    sudo systemctl stop mcStart.service

    # Update durchführen
    sudo apt upgrade -y default-jre

    sleep 2
    echo "Java wurde aktualisiert."

    #Neustart des Servers
    echo "Server wird wieder gestartet. Systemd service wird gestartet"
    sudo systemctl start mcStart.service

else
    echo "Java ist bereits auf dem neuesten Stand."
fi