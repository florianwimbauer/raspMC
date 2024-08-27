# Dieses Skript sorgt dafür, dass die Java Runtime immer aktuell ist.
echo "Überprüfe auf verfügbare Updates für JDK..."
sudo apt update

if sudo apt list --upgradable 2>/dev/null | grep -q "openjdk"
then
    echo "Java-Update verfügbar. Aktualisierung wird durchgeführt..."

    sudo apt upgrade -y default-jre

    sleep 2
    echo "Java wurde aktualisiert."
else
    echo "Java ist bereits auf dem neuesten Stand."
fi