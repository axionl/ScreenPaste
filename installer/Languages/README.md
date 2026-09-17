# Chinese language files for the ScreenPaste installer

`ScreenPaste.iss` uses the copies in this folder **only when the Inno Setup
compiler does not ship its own** — i.e. Inno Setup 6.4.x and older. From 6.5.0 on,
Chinese is an official Inno Setup translation and the bundled
`compiler:Languages\ChineseSimplified.isl` / `ChineseTraditional.isl` are used
instead, so these files are ignored (the CI build installs 6.7.x via Chocolatey
and takes that path).

Both files are the "Inno Setup version 6.4.0+ messages" releases, UTF-8 with BOM
as Inno Setup 6.4 requires for non-ASCII translations.

| File | Upstream | Authors |
| --- | --- | --- |
| `ChineseSimplified.isl` | [kira-96/Inno-Setup-Chinese-Simplified-Translation](https://github.com/kira-96/Inno-Setup-Chinese-Simplified-Translation) (tag `6.4.0+`) | kirakira and contributors — MIT licensed. This is the translation that became the official Simplified Chinese file in Inno Setup 6.5.0 (maintained by Zhenghan Yang). |
| `ChineseTraditional.isl` | [VulpesStella/Inno-Setup-Chinese-Traditional-Translation](https://github.com/VulpesStella/Inno-Setup-Chinese-Traditional-Translation) | Mikhail Tapio, based on work by Enfeng Tsao and Samuel Lee — see the header of the file. Traditional Chinese is maintained for Inno Setup by GoneTone. |

To refresh them, download the current `6.4.0+` versions from those repositories.
If the project ever requires Inno Setup 6.5.0+ to build, this folder can simply be
deleted together with the `ZhCnMessagesFile` / `ZhTwMessagesFile` conditionals in
`ScreenPaste.iss`.
