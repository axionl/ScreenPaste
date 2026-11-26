# Chinese language files for the ScreenPaste installer

`ScreenPaste.iss` uses the copies in this folder **unless the Inno Setup
compiler ships its own** Chinese files in `compiler:Languages\`. In practice it
does not: the 6.7.4 compiler (installed by CI via Chocolatey) has no
`ChineseSimplified.isl` / `ChineseTraditional.isl`, so these copies are what a
release build actually compiles with. Keep them current.

Both files are the "Inno Setup version 6.4.0+ messages" releases, UTF-8 with BOM
as Inno Setup requires for non-ASCII translations, with the messages added in
6.5.0–6.7.x (download/extract progress, archive, source verification) appended at
the end so the compiler does not fall back to English for them.

| File | Upstream | Authors |
| --- | --- | --- |
| `ChineseSimplified.isl` | [kira-96/Inno-Setup-Chinese-Simplified-Translation](https://github.com/kira-96/Inno-Setup-Chinese-Simplified-Translation) (tag `6.4.0+`) | kirakira and contributors — MIT licensed. This is the translation that became the official Simplified Chinese file in Inno Setup 6.5.0 (maintained by Zhenghan Yang). |
| `ChineseTraditional.isl` | [VulpesStella/Inno-Setup-Chinese-Traditional-Translation](https://github.com/VulpesStella/Inno-Setup-Chinese-Traditional-Translation) | Mikhail Tapio, based on work by Enfeng Tsao and Samuel Lee — see the header of the file. Traditional Chinese is maintained for Inno Setup by GoneTone. |

To refresh them, download the current `6.4.0+` versions from those repositories
and re-append the newer messages listed above. If a future compiler release does
bundle Chinese files, this folder is ignored automatically by the
`ZhCnMessagesFile` / `ZhTwMessagesFile` conditionals in `ScreenPaste.iss`.
