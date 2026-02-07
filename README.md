## Z80 Youtube clip
- based on [YouTube video](https://www.youtube.com/watch?v=v3-a-zqKfgA)


- using custom `.devcontainer` that includes:
    - [hexdump](from `bsdmainutils` package)
    - [vasm](http://sun.hasenbraten.de/vasm/index.php?view=main)
      - includes `vasm6502_oldstyle` if CPU_TYPE=6502
      - includes `vobjdump`
- run on `emulator`:
    - [ZEsarUX](https://github.com/chernandezba/zesarux/releases/tag/ZEsarUX-12.1)

### Usage:
```bash
make build

# show output as hex dump
hexdump -C ./build/main.out
```
