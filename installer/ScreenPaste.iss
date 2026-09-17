; Inno Setup script for ScreenPaste — per-user install (no admin).
;
; Build (local):
;   dotnet publish src\ScreenPaste\ScreenPaste.csproj -c Release   (output must land in PublishDir below)
;   ISCC installer\ScreenPaste.iss
;
; Version is set by hand below; CI overrides it from the release tag:
;   ISCC /DMyAppVersion=1.2.3 /DPublishDir=..\publish installer\ScreenPaste.iss
;
; Languages: Simplified Chinese (default) + Traditional Chinese + the app's other
; UI languages. Chinese only became an official Inno Setup translation in 6.5.0,
; so with an older compiler the copies in installer\Languages\ are used instead
; (same translations, 6.4.0+ message set). Force one at run time with e.g.
;   ScreenPaste-1.9.0-setup.exe /LANG=zh_CN

#define MyAppName "ScreenPaste"
#define MyAppExeName "ScreenPaste.exe"
#define MyAppPublisher "taida957789"
#define MyAppURL "https://github.com/taida957789/ScreenPaste"

; ---------------------------------------------------------------------------
; Packaged files - where "dotnet publish" put the app. Path is relative to this
; script (installer\), i.e. the default publish folder of the csproj.
; Override for other layouts, e.g. /DPublishDir=..\publish
; ---------------------------------------------------------------------------
#ifndef PublishDir
  #define PublishDir "..\src\ScreenPaste\bin\Release\net10.0-windows10.0.19041.0\publish"
#endif

; ---------------------------------------------------------------------------
; Version - kept in sync with <Version> in ScreenPaste.csproj by hand.
; /DMyAppVersion (CI release tag) wins.
; ---------------------------------------------------------------------------
#ifndef MyAppVersion
  #define MyAppVersion "1.9.0"
#endif

; ---------------------------------------------------------------------------
; Chinese message files. Inno Setup 6.5.0+ bundles them; an older compiler gets
; the 6.4.0+ copies kept in installer\Languages\ (authors are credited in the
; file headers, "Inno Setup version 6.4.0+ ... messages").
; ---------------------------------------------------------------------------
#if FileExists(AddBackslash(CompilerPath) + "Languages\ChineseSimplified.isl")
  #define ZhCnMessagesFile "compiler:Languages\ChineseSimplified.isl"
#else
  #define ZhCnMessagesFile "Languages\ChineseSimplified.isl"
#endif

#if FileExists(AddBackslash(CompilerPath) + "Languages\ChineseTraditional.isl")
  #define ZhTwMessagesFile "compiler:Languages\ChineseTraditional.isl"
#else
  #define ZhTwMessagesFile "Languages\ChineseTraditional.isl"
#endif

[Setup]
AppId={{8F3A6C21-5B7E-4D9A-9C2F-1E4B7A6D3C88}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
VersionInfoVersion={#MyAppVersion}

; Per-user install under %APPDATA%\ScreenPaste — no administrator rights required.
PrivilegesRequired=lowest
DefaultDirName={userappdata}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
DisableDirPage=auto
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}

; Simplified Chinese is the default: "none" makes Setup use the first [Languages]
; entry instead of guessing from the Windows UI language. The Select Language
; dialog (ShowLanguageDialog defaults to yes) still lets the user switch.
LanguageDetectionMethod=none

OutputDir=..\dist
OutputBaseFilename=ScreenPaste-{#MyAppVersion}-setup
SetupIconFile=..\src\ScreenPaste\Assets\app.ico
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; First entry = default language. Names are also the [CustomMessages] prefixes
; and the value accepted by /LANG=.
[Languages]
Name: "zh_CN"; MessagesFile: "{#ZhCnMessagesFile}"
Name: "zh_TW"; MessagesFile: "{#ZhTwMessagesFile}"
Name: "en";    MessagesFile: "compiler:Default.isl"
Name: "ja";    MessagesFile: "compiler:Languages\Japanese.isl"
Name: "ko";    MessagesFile: "compiler:Languages\Korean.isl"
Name: "fr";    MessagesFile: "compiler:Languages\French.isl"
Name: "de";    MessagesFile: "compiler:Languages\German.isl"
Name: "es";    MessagesFile: "compiler:Languages\Spanish.isl"

; Wizard strings the installer adds itself. Only the shortcut group needs one of
; our own - everything else comes from Inno's translated built-ins:
;   {cm:CreateDesktopIcon}, {cm:AutoStartProgram}, {cm:AutoStartProgramGroupDescription},
;   {cm:UninstallProgram}, {cm:LaunchProgram}
; The unprefixed entry is the fallback for any language without its own line.
[CustomMessages]
ShortcutGroup=Shortcuts:

zh_CN.ShortcutGroup=快捷方式：
zh_TW.ShortcutGroup=捷徑：
ja.ShortcutGroup=ショートカット:
ko.ShortcutGroup=바로 가기:
fr.ShortcutGroup=Raccourcis :
de.ShortcutGroup=Verknüpfungen:
es.ShortcutGroup=Accesos directos:

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:ShortcutGroup}"
Name: "startup"; Description: "{cm:AutoStartProgram,{#MyAppName}}"; GroupDescription: "{cm:AutoStartProgramGroupDescription}"; Flags: unchecked

[Files]
; The whole publish output, so both layouts work: a single-file self-contained
; build (ScreenPaste.exe) and a multi-file one (dll/deps.json/runtimeconfig.json
; + runtimes\). ffmpeg lives in publish\ffmpeg and comes along via recursesubdirs.
Source: "{#PublishDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.pdb,*.xml"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
; Optional run-at-startup (per-user Run key). The app's own tray toggle also manages this.
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "ScreenPaste"; ValueData: """{app}\{#MyAppExeName}"""; Tasks: startup; Flags: uninsdeletevalue

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; Best-effort: close a running instance before uninstalling.
Filename: "{cmd}"; Parameters: "/C taskkill /IM {#MyAppExeName} /F"; Flags: runhidden; RunOnceId: "KillApp"
