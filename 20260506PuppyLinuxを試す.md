以下から取得
https://archive.org/details/puppy_slacko_570_IT

qemuで起動し、ISOに問題が無いことを確認する。
```
qemu-system-i386 \
  -cdrom puppy_slacko_570_IT.iso \
  -m 512 \
  -boot d
```

書き込みの確認をする。
```
wodim -dummy dev=/dev/sr0 speed=4 puppy_slacko_570_IT.iso
```

<details>
<summary>結果</summary>

```bash 
 linuxlite  ~  kaihatsu  wodim -dummy dev=/dev/sr0 speed=4 puppy_slacko_570_IT.iso
wodim: No write mode specified.
wodim: Assuming -tao mode.
wodim: Future versions of wodim may have different drive dependent defaults.
wodim: Operation not permitted. Warning: Cannot raise RLIMIT_MEMLOCK limits.
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   : 
Vendor_info    : 'PLDS    '
Identification : 'DVD+-RW DS-8A8SH'
Revision       : 'KD11'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
Driver flags   : MMC-3 SWABAUDIO BURNFREE FORCESPEED 
Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
Speed set to 1765 KB/s
Starting to write CD/DVD at speed  10.0 in dummy TAO mode for single session.
Last chance to quit, starting dummy write in    0 seconds. Operation starts.
Track 01: Total bytes read/written: 180918272/180918272 (88339 sectors).
 linuxlite  ~  kaihatsu  
```

</details>

実際に書き込む
```
sudo wodim dev=/dev/sr0 speed=4 -dao -v -eject puppy_slacko_570_IT.iso
```

<details>
<summary>結果</summary>

```bash 
 linuxlite  ~  kaihatsu  sudo wodim dev=/dev/sr0 speed=4 -dao -v -eject puppy_slacko_570_IT.iso
[sudo] password for linuxlite: 
TOC Type: 1 = CD-ROM
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
Track 01: data   172 MB        
Total size:      198 MB (19:37.85) = 88339 sectors
Lout start:      198 MB (19:39/64) = 88339 sectors
Current Secsize: 2048
ATIP info from disk:
  Indicated writing power: 5
  Is not unrestricted
  Is not erasable
  Disk sub type: Medium Type A, high Beta category (A+) (3)
  ATIP start of lead in:  -11634 (97:26/66)
  ATIP start of lead out: 359846 (79:59/71)
Disk type:    Short strategy type (Phthalocyanine or similar)
Manuf. index: 3
Manufacturer: CMC Magnetics Corporation
Blocks total: 359846 Blocks current: 359846 Blocks remaining: 271507
Forcespeed is OFF.
Speed set to 1765 KB/s
Starting to write CD/DVD at speed  10.0 in real SAO mode for single session.
Last chance to quit, starting real write in    0 seconds. Operation starts.
Waiting for reader process to fill input buffer ... input buffer ready.
Performing OPC...
Sending CUE sheet...
Writing pregap for track 1 at -150
Starting new track at sector: 0
Track 01:  172 of  172 MB written (fifo 100%) [buf 100%]  10.5x.
Track 01: Total bytes read/written: 180918272/180918272 (88339 sectors).
Writing  time:  139.183s
Average write speed   8.9x.
Min drive buffer fill was 99%
Fixating...
Fixating time:    9.576s
BURN-Free was never needed.
wodim: fifo had 2850 puts and 2850 gets.
wodim: fifo was 0 times empty and 2655 times full, min fill was 98%.
 linuxlite  ~  kaihatsu  
```

</details>

CDから起動する
<img width="1576" height="2100" alt="f64a86fe4d59" src="https://github.com/user-attachments/assets/b108ba71-97cb-4f57-914f-806584f656f7" />

# 検証環境
機種 : VOSTRO 1540
CPU : Intel(R) Celeron(R) CPU P4600 @ 2.00GHz
MEM : 1.8Gi
OS : Linux Lite 6.6
NASM : 2.15.05
GDB : GNU gdb (Ubuntu 12.1-0ubuntu1~22.04.2) 12.1
※実家に帰省中。昔のパソコン。
