# 導入

```bash
sudo apt install -y git gnome-tweaks gnome-shell-extension-manager \
  gnome-shell-extensions
```
  
一旦再ログイン

```bash
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
```

```bash
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme
./install.sh -c dark 
```

```bash
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git --depth=1
cd WhiteSur-icon-theme
./install.sh
```

```bash
git clone https://github.com/vinceliuice/WhiteSur-cursors.git --depth=1
cd WhiteSur-cursors
./install.sh
```

# 切り替え
```
gnome-tweaks
```
<img width="1070" height="772" alt="截图 2026-09-02 22-50-50" src="https://github.com/user-attachments/assets/dfde7ba0-368d-4f0e-91bf-1c80c778c191" />

ちょっとだけMACのようになりました。
<img width="1920" height="1080" alt="截图 2026-09-02 22-51-27" src="https://github.com/user-attachments/assets/2ffc10fc-4cf6-4e85-82b2-3cfac7b2be78" />

# 20260903追記

<img width="1920" height="1080" alt="截图 2026-09-03 20-32-47" src="https://github.com/user-attachments/assets/871c30ba-2bff-4cf5-a7c3-b6c1f8d9d5f8" />

```
git clone https://github.com/micheleg/dash-to-dock.git ~/dash-to-dock
cd ~/dash-to-dock
make
make install
```
再ログイン

```
gnome-extensions enable dash-to-dock@micxgx.gmail.com
```

再ログイン

設定を変える
```
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.75
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
```

```
git clone https://github.com/aunetx/blur-my-shell.git ~/blur-my-shell
cd ~/blur-my-shell
git fetch --tags
git checkout v29
make install
```

再ログイン
```
gnome-extensions enable blur-my-shell@aunetx
```

下を入れたら上のバーが半透明になった
```
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark'
```

