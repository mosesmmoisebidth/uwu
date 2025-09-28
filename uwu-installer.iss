; -------------------------------
; uwu-cli Windows Installer Script
; -------------------------------

[Setup]
AppName=uwu CLI (by Mucyo Moses - https://moses.it.com)
AppVersion=1.0
DefaultDirName={pf}\uwu-cli
DefaultGroupName=uwu CLI
OutputBaseFilename=uwu-cli-setup
SetupIconFile=logo.ico
Compression=lzma
SolidCompression=yes

[Files]
Source: "dist\uwu-cli.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\uwu CLI"; Filename: "{app}\uwu-cli.exe"; WorkingDir: "{app}"
Name: "{commondesktop}\uwu CLI"; Filename: "{app}\uwu-cli.exe"; WorkingDir: "{app}"

[Tasks]
Name: "addtopath"; Description: "Add uwu CLI to system PATH"; GroupDescription: "Additional tasks:"; Flags: unchecked

[Code]
// Show messages in progress
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
    WizardForm.StatusLabel.Caption := 'Installing uwu CLI, please wait...';
end;

procedure CurStepChanged_PostInstall(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    WizardForm.StatusLabel.Caption := 'Finalizing installation and adding to PATH...';
end;

// Add the installed folder to system PATH if the task is checked
procedure CurStepChanged_PostInstallWithTasks(CurStep: TSetupStep);
var
  OldPath, NewPath: string;
begin
  if CurStep = ssPostInstall then
  begin
    if IsTaskSelected('addtopath') then
    begin
      OldPath := GetEnv('PATH');
      NewPath := OldPath + ';' + ExpandConstant('{app}');
      RegWriteStringValue(HKLM, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', NewPath);
      MsgBox('uwu CLI has been added to your system PATH.'#13#10 +
             'You may need to restart your terminal or computer for changes to take effect.', mbInformation, MB_OK);
    end;
  end;
end;

[Run]
Filename: "{app}\uwu-cli.exe"; Description: "Run uwu CLI"; Flags: nowait postinstall skipifsilent
