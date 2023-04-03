#!/usr/bin/env zsh

PLATFORM="misskey";
ORG="Pamir-Academy"; CC="np";
INIT_CMD="pnpm run init";
BACKEND_CMD="cd /home/$PLATFORM/$PLATFORM/packages/backend/ && pnpm run build";
FRONTEND_CMD="cd /home/$PLATFORM/$PLATFORM/packages/frontend/ && pnpm run build";
SERVICE_PATH="/etc/systemd/system/$PLATFORM.service";
sudo corepack enable
echo "[+] Creating user: $PLATFORM"
sudo mkdir "/home/$PLATFORM"
sudo chown -R "$PLATFORM:$PLATFORM" "/home/$PLATFORM"
echo -n "[~] Enter PostgresQl_db passwd: "
read PASSWD
PASSWD=$(echo -n "xprvnS3C:$USER@$PLATFORM:$PASSWD" | base64 | sha512sum | cut -d ' ' -f 1)
echo -n "[!] MAKE SURE YOU DO NOT 'FORGET' ur PASSWD since-if-u-losse-it-I simply cannot help u. (its hashed properly!)"
echo -e "\n\n<[Press] 'ENTER'/**⏎** KEY to \`continue\` />"
read

function pex() {
  echo "[+] Executing $@ as $PLATFORM"
  sudo -u "$PLATFORM" "$@"
}

echo "[+] Installing/Updating $PLATFORM !"
INSTALL_CMD="git clone --recursive https://github.com/$ORG/$PLATFORM.$CC.git && cd $PLATFORM && git checkout master && git submodule update --init && pnpm install --frozen-lockfile"
UPDATE_CMD="cd /home/$PLATFORM/$PLATFORM && git checkout master && git pull && git submodule update --init && NODE_ENV=production pnpm install --frozen-lockfile && NODE_ENV=production pnpm run build && pnpm run migrate"
ONERR_CMD="cd /home/$PLATFORM/$PLATFORM && pnpm run clean-all && pnpm install"
echo -e "\n\nIf you encounter 'any' catch { error: ' echo $ONERR_CMD ' }\n\n"
sleep 2;
if [ -d "/home/$PLATFORM/$PLATFORM" ]; then
  pex "$UPDATE_CMD"
  echo "[+] Building backend !"
  pex "$BACKEND_CMD"
  echo "[+] Building frontend !!"
  pex "$FRONTEND_CMD"
  exit 0
else
  pex "$INSTALL_CMD"
fi

echo "[+] Please edit config ~[YAML]-file ."
pex cp "/home/$PLATFORM/$PLATFORM/.config/example.yml" "/home/$PLATFORM/$PLATFORM/.config/default.yml"
sleep 2;
pex vim "/home/$PLATFORM/$PLATFORM/.config/default.yml"

echo "[+] Init ~ psql [DB] !"
DB_CMD="create database $PLATFORM with encoding = 'UTF8'; create user $PLATFORM with encrypted password '{$PASSWD}';grant all privileges on database $PLATFORM to $PLATFORM;\q"
echo "$DB_CMD" | sudo -u postgres psql

echo "[+] Init ~ [_DB] migration(s) !"
pex "cd /home/$PLATFORM/$PLATFORM/ && $INIT_CMD"

echo "[+] Building backend !"
pex "$BACKEND_CMD"

echo "[+] Building frontend !!"
pex "$FRONTEND_CMD"

echo "[+] Installing sysmted service of $PLATFORM !"
echo -e "\n\n\n\n\n\n"
# cat > /etc/systemd/system/misskey.service
echo "[Unit]"
echo "Description=Misskey daemon"
echo ""
echo "[Service]"
echo "Type=simple"
echo "User=$PLATFORM"
echo "ExecStart=/usr/bin/npm start"
echo "WorkingDirectory=/home/$PLATFORM/$PLATFORM"
echo 'Environment="NODE_ENV=production"'
echo "TimeoutSec=60"
echo "StandardOutput=journal"
echo "StandardError=journal"
echo "SyslogIdentifier=$PLATFORM"
echo "Restart=always"
echo ""
echo "[Install]"
echo "WantedBy=multi-user.target"
# << EOF
echo -e "\n\n\n\n\n\n"
echo "[~] Aagh-oh! I made in a way that you're supposed to paste it on $SERVICE_PATH ! and ykr.."

echo -e "\n\n[!] DO NOT FORGET TO \n> \`sudo systemctl daemon-reload; sudo systemctl enable $PLATFORM\ && sudo systemctl start $PLATFORM` "
