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

焼き損じる可能性を減らす為、一度ドライブで擬似的に焼いてみて確かめる。

```bash
wodim dev=/dev/sr0 speed=4 -v -dummy plpbt.iso
```
書き込みには成功した。
<details>
<summary>結果</summary>

```bash 
 linuxlite  ~  kaihatsu  wodim dev=/dev/sr0 speed=4 -v -dummy plpbt.iso
wodim: No write mode specified.
wodim: Assuming -tao mode.
wodim: Future versions of wodim may have different drive dependent defaults.
TOC Type: 1 = CD-ROM
wodim: Operation not permitted. Warning: Cannot raise RLIMIT_MEMLOCK limits.
scsidev: '/dev/sr0'
devname: '/dev/sr0'
scsibus: -2 target: -2 lun: -2
Linux sg driver version: 3.5.27
Wodim version: 1.1.11
SCSI buffer size: 64512
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   : 
Vendor_info    : 'PLDS    '
Identification : 'DVD+-RW DS-8A8SH'
Revision       : 'KD11'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
Current: 0x0009 (CD-R)
Profile: 0x002B (DVD+R/DL) 
Profile: 0x001B (DVD+R) 
Profile: 0x001A (DVD+RW) 
Profile: 0x0016 (DVD-R/DL layer jump recording) 
Profile: 0x0015 (DVD-R/DL sequential recording) 
Profile: 0x0014 (DVD-RW sequential recording) 
Profile: 0x0013 (DVD-RW restricted overwrite) 
Profile: 0x0012 (DVD-RAM) 
Profile: 0x0011 (DVD-R sequential recording) 
Profile: 0x0010 (DVD-ROM) 
Profile: 0x000A (CD-RW) 
Profile: 0x0009 (CD-R) (current)
Profile: 0x0008 (CD-ROM) 
Profile: 0x0002 (Removable disk) 
Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
Driver flags   : MMC-3 SWABAUDIO BURNFREE FORCESPEED 
Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
Drive buf size : 732160 = 715 KB
Beginning DMA speed test. Set CDR_NODMATEST environment variable if device
communication breaks or freezes immediately after that.
FIFO size      : 12582912 = 12288 KB
Track 01: data     0 MB         padsize:   56 KB
Total size:        0 MB (00:04.02) = 302 sectors
Lout start:        1 MB (00:06/02) = 302 sectors
Current Secsize: 2048
ATIP info from disk:
  Indicated writing power: 4
  Is unrestricted
  Is not erasable
  Disk sub type: Medium Type A, low Beta category (A-) (2)
  ATIP start of lead in:  -11634 (97:26/66)
  ATIP start of lead out: 359849 (79:59/74)
Disk type:    Short strategy type (Phthalocyanine or similar)
Manuf. index: 3
Manufacturer: CMC Magnetics Corporation
Blocks total: 359849 Blocks current: 359849 Blocks remaining: 359547
Forcespeed is OFF.
Speed set to 1765 KB/s
Starting to write CD/DVD at speed  10.0 in dummy TAO mode for single session.
Last chance to quit, starting dummy write in    0 seconds. Operation starts.
Waiting for reader process to fill input buffer ... input buffer ready.
Starting new track at sector: 0
Track 01:    0 of    0 MB written.
Track 01: writing  56 KB of pad data.
Track 01: Total bytes read/written: 557056/614400 (300 sectors).
Writing  time:   10.536s
Average write speed   0.4x.
Fixating...
WARNING: Some drives don't like fixation in dummy mode.
Fixating time:    0.008s
BURN-Free was never needed.
wodim: fifo had 9 puts and 9 gets.
wodim: fifo was 0 times empty and 0 times full, min fill was 100%.
```

</details>

次は実際に書き込む

```bash
wodim dev=/dev/sr0 speed=4 -v -eject plpbt.iso
```

<details>
<summary>結果</summary>

```bash 
 linuxlite  ~  kaihatsu  wodim dev=/dev/sr0 speed=4 -v -eject plpbt.iso
wodim: No write mode specified.
wodim: Assuming -tao mode.
wodim: Future versions of wodim may have different drive dependent defaults.
TOC Type: 1 = CD-ROM
wodim: Operation not permitted. Warning: Cannot raise RLIMIT_MEMLOCK limits.
scsidev: '/dev/sr0'
devname: '/dev/sr0'
scsibus: -2 target: -2 lun: -2
Linux sg driver version: 3.5.27
Wodim version: 1.1.11
SCSI buffer size: 64512
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   : 
Vendor_info    : 'PLDS    '
Identification : 'DVD+-RW DS-8A8SH'
Revision       : 'KD11'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
Current: 0x0009 (CD-R)
Profile: 0x002B (DVD+R/DL) 
Profile: 0x001B (DVD+R) 
Profile: 0x001A (DVD+RW) 
Profile: 0x0016 (DVD-R/DL layer jump recording) 
Profile: 0x0015 (DVD-R/DL sequential recording) 
Profile: 0x0014 (DVD-RW sequential recording) 
Profile: 0x0013 (DVD-RW restricted overwrite) 
Profile: 0x0012 (DVD-RAM) 
Profile: 0x0011 (DVD-R sequential recording) 
Profile: 0x0010 (DVD-ROM) 
Profile: 0x000A (CD-RW) 
Profile: 0x0009 (CD-R) (current)
Profile: 0x0008 (CD-ROM) 
Profile: 0x0002 (Removable disk) 
Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
Driver flags   : MMC-3 SWABAUDIO BURNFREE FORCESPEED 
Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
Drive buf size : 732160 = 715 KB
Beginning DMA speed test. Set CDR_NODMATEST environment variable if device
communication breaks or freezes immediately after that.
FIFO size      : 12582912 = 12288 KB
Track 01: data     0 MB         padsize:   56 KB
Total size:        0 MB (00:04.02) = 302 sectors
Lout start:        1 MB (00:06/02) = 302 sectors
Current Secsize: 2048
ATIP info from disk:
  Indicated writing power: 4
  Is unrestricted
  Is not erasable
  Disk sub type: Medium Type A, low Beta category (A-) (2)
  ATIP start of lead in:  -11634 (97:26/66)
  ATIP start of lead out: 359849 (79:59/74)
Disk type:    Short strategy type (Phthalocyanine or similar)
Manuf. index: 3
Manufacturer: CMC Magnetics Corporation
Blocks total: 359849 Blocks current: 359849 Blocks remaining: 359547
Forcespeed is OFF.
Speed set to 1765 KB/s
Starting to write CD/DVD at speed  10.0 in real TAO mode for single session.
Last chance to quit, starting real write in    0 seconds. Operation starts.
Waiting for reader process to fill input buffer ... input buffer ready.
Performing OPC...
Starting new track at sector: 0
Track 01:    0 of    0 MB written.
Track 01: writing  56 KB of pad data.
Track 01: Total bytes read/written: 557056/614400 (300 sectors).
Writing  time:    9.178s
Average write speed   1.6x.
Fixating...
Fixating time:   25.107s
BURN-Free was never needed.
wodim: fifo had 9 puts and 9 gets.
wodim: fifo was 0 times empty and 0 times full, min fill was 100%.
```

</details>


