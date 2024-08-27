# Dieses Skript sorgt dafür, dass die Java Runtime immer aktuell ist.
echo "Überprüfe auf verfügbare Updates für JDK..."
sudo apt update

if sudo apt list --upgradable 2>/dev/null | grep -q "openjdk"
then
    echo "Java-Update verfügbar. Aktualisierung wird durchgeführt..."
    echo "Server stoppen"
    # Anhaltebenachrichtigung
    screen -S serverTerminal -p 0 -X stuff "say Neustart wegen Java-Update. We will be right back!\n"
    sleep 5
    # Stop des Servers
    screen -S serverTerminal -p 0 -X stuff "stop\n"

    # Update durchführen
    sudo apt upgrade -y default-jre

    sleep 2
    echo "Java wurde aktualisiert."

    #Neustart des Servers
    echo "Server wird wieder gestartet. Übergebe an boot.sh"
    boot.sh
    
else
    echo "Java ist bereits auf dem neuesten Stand."
fi