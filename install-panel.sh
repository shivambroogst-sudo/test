#!/usr/bin/env bash
# ================================================
# OGhost Panel - VPS setup script
# ================================================
# Installs everything the PANEL needs to run, plus every Java version
# (8 through 25) so servers created on the "Local" node work for any
# Minecraft version from 1.8.8 up to the latest - same idea as
# Pterodactyl's multi-Java Docker images, but installed natively.
#
# Usage:  sudo bash install-panel.sh

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (sudo bash install-panel.sh)"
  exit 1
fi

JAVA_VERSIONS=(8 11 16 17 21 25)
JAVA_DIR=/opt/java

echo "=================================================="
echo " 1/4 - Updating package lists"
echo "=================================================="
apt update -y

echo "=================================================="
echo " 2/4 - Installing base packages (git, wget, curl, unzip, build tools)"
echo "=================================================="
apt install -y curl wget git unzip build-essential ca-certificates gnupg software-properties-common sqlite3

echo "=================================================="
echo " 3/4 - Installing Node.js 20.x + npm + pm2"
echo "=================================================="
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs
else
  echo "Node.js already installed: $(node -v)"
fi
npm install -g pm2

echo "=================================================="
echo " 4/4 - Java runtimes (optional)"
echo "=================================================="
echo "Java is only needed on the PANEL if you plan to run a Minecraft server"
echo "directly on this machine (the 'Local' node). If ALL your servers will"
echo "run on separate node VPS (via the daemon), you can skip this."
echo ""
read -p "Install Java 8-25 on this panel too? (y/N): " install_java

if [[ "$install_java" =~ ^[Yy]$ ]]; then
    mkdir -p "$JAVA_DIR"
    for ver in "${JAVA_VERSIONS[@]}"; do
      if [ -x "$JAVA_DIR/$ver/bin/java" ]; then
        echo "-> Java $ver already installed, skipping"
        continue
      fi
      echo "-> Downloading Eclipse Temurin JDK $ver ..."
      url="https://api.adoptium.net/v3/binary/latest/${ver}/ga/linux/x64/jdk/hotspot/normal/eclipse"
      tmpfile="/tmp/jdk-${ver}.tar.gz"
      if curl -fsSL -o "$tmpfile" "$url"; then
        mkdir -p "$JAVA_DIR/$ver"
        tar -xzf "$tmpfile" -C "$JAVA_DIR/$ver" --strip-components=1
        rm -f "$tmpfile"
        echo "-> Java $ver installed at $JAVA_DIR/$ver"
      else
        echo "-> WARNING: could not download Java $ver from Adoptium (may not be released yet). Skipping."
      fi
    done
else
    echo "Skipping Java install - this panel VPS will only manage remote nodes."
fi

echo ""
echo "=================================================="
echo " Done! Installed Java versions:"
echo "=================================================="
for ver in "${JAVA_VERSIONS[@]}"; do
  if [ -x "$JAVA_DIR/$ver/bin/java" ]; then
    echo "  Java $ver -> $JAVA_DIR/$ver/bin/java"
  fi
done

echo ""
echo "Node:  $(node -v 2>/dev/null || echo 'not found')"
echo "npm:   $(npm -v 2>/dev/null || echo 'not found')"
echo "pm2:   $(pm2 -v 2>/dev/null || echo 'not found')"
echo ""
echo "Next steps:"
echo "  cd oghost-panel"
echo "  npm install"
echo "  pm2 start app.js --name oghost-panel"
echo "  pm2 save && pm2 startup"
