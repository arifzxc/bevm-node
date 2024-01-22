#!/bin/bash

echo "Download Bahan"
sudo apt install --assume-yes git ufw clang curl libssl-dev llvm libudev-dev make protobuf-compiler
sudo ufw allow ssh; sudo ufw allow 30333; sudo ufw allow 20222; sudo ufw allow 30334
sleep 60
mkdir -p $HOME/.bevm
wget -O bevm https://github.com/btclayer2/BEVM/releases/download/testnet-v0.1.1/bevm-v0.1.1-ubuntu20.04 && chmod 770 bevm
sudo cp bevm /usr/bin/

echo "Add Service"
sudo tee /etc/systemd/system/bevm.service > /dev/null << EOF
[Unit]
Description=BEVM Node Service
After=network.target

[Service]
Type=simple
User=root
Restart=always
RestartSec=0
ExecStart=/usr/bin/bevm --chain=testnet --name="address" --pruning=archive --telemetry-url "wss://telemetry.bevm.io/submit 0"

[Install]
WantedBy=multi-user.target
EOF

echo "Berhasil dimasukan, cek:"
cat /etc/systemd/system/bevm.service
sleep 2
echo "Silahkan masukan address, open! saya beri waktu 30 detik"
vi /etc/systemd/system/bevm.service
sleep 30

sudo systemctl daemon-reload
sleep 3
sudo systemctl enable bevm
sleep 3
sudo systemctl start bevm.service

echo "Success Install And RUN Node!"
sudo journalctl -u bevm -f --no-hostname -o cat
