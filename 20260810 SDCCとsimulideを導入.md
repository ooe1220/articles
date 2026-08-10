
```
sudo apt install sdcc
sdcc --version
```

`sudo apt install`でインストールすると8051が無かったので以下の手順で導入。
```
wget https://launchpad.net/simulide/1.1.0/1.1.0-sr0/+download/SimulIDE_1.1.0-SR0_Lin64.tar.gz
tar -xf SimulIDE_1.1.0-SR0_Lin64.tar.gz
sudo mv SimulIDE_1.1.0-SR0_Lin64 /opt/simulide-110sr0
sudo apt install -y libqt5svg5 libqt5script5 libqt5serialport5 libelf1
sudo chmod +x /opt/simulide-110sr0/simulide
cd /opt/simulide-110sr0
./simulide
```
LEDを光らせたかったが何をやっても失敗するので後日試す
<img width="1377" height="950" alt="截图 2026-08-10 21-55-55" src="https://github.com/user-attachments/assets/4b3b5620-25f7-410f-bd2d-762234e3cac3" />
