
# `MOZC`取得

```
sudo apt install ibus-mozc
ibus restart
```

# 日本語追加


```
ibus-setup
```
<img width="750" height="518" alt="スクリーンショット_2026-05-07_09-20-03" src="https://github.com/user-attachments/assets/06e59262-77b4-4fb3-80a0-5ed0e5faaaa7" />

# 配列をJPへ変更

```
 linuxlite  ~  setxkbmap -query
rules:      evdev
model:      pc105
layout:     us
 linuxlite  ~  setxkbmap jp
 linuxlite  ~  setxkbmap -query
rules:      evdev
model:      pc105
layout:     jp
 linuxlite  ~  
```

ibusを再起動
```
ibus restart
```

# 対象
機種 : PC-VK20HHZNX
CPU : Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz
MEM : 7.6Gi
OS : Linux Lite 6.6
