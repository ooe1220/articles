# Plop Boot Managerの取得
以下から取得。USBドライバが含まれていて、BIOS側でUSB起動に対応していない場合でも内部のドライバを使ってUSBからOSを起動することが可能。
[Plop Boot Manager取得](https://www.plop.at/en/bootmanager/download.html?utm_source=chatgpt.com)

# QEMUで検証

百均に行った所、CD-Rしか無く、焼き損じたら無駄になるので試しにQEMUで起動できるか確かめる。
軽めのFreeDOSをUSBとして認識させて、Plop Boot Manager経由で起動する。
[FreeDOS取得](https://www.freedos.org/download/)

```bash
qemu-system-i386 \
  -cdrom plpbt.iso \
  -boot d \
  -usb \
  -device usb-ehci,id=ehci \
  -device usb-storage,drive=usbdrive \
  -drive if=none,id=usbdrive,file=FD14LITE.img,format=raw
```

OS側でエラーは出たが起動には成功した。
<img width="644" height="542" alt="スクリーンショット_2026-05-05_10-09-32" src="https://github.com/user-attachments/assets/0d514672-e952-42e4-acb1-fee825c7ab28" />
<img width="724" height="462" alt="スクリーンショット_2026-05-05_10-10-59" src="https://github.com/user-attachments/assets/0ca1a672-af82-4c63-ae04-ca6da3b68417" />
<img width="724" height="462" alt="スクリーンショット_2026-05-05_10-12-23" src="https://github.com/user-attachments/assets/841309e2-03d6-4508-91c7-979950b3c69e" />

# CDへ焼く

