unit StartForm;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, MainMenu;

type

	{ TLoginForm }

	TLoginForm = class(TForm)
		Type_Name: TLabel;
		NameGetter: TEdit;
		Run: TButton;
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormCreate(Sender: TObject);
		procedure NameGetterKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);

		procedure RunClick(Sender: TObject);
	private
		{ private declarations }
		NameNotEmpty: boolean;
		NameRes: string;
	public
		{ public declarations }
		property GetName: string read NameRes;
	end;

var
	LoginForm: TLoginForm;

implementation

{$R *.lfm}

{ TLoginForm }

procedure TLoginForm.RunClick(Sender: TObject);
var
	s: ansistring;
begin
	s := NameGetter.Text;
	while pos(' ', s) = 1 do
		Delete(s, 1, 1);
	while pos('/', s) <> 0 do
		Delete(s, pos('/', s), 1);
	while pos('\', s) <> 0 do
		Delete(s, pos('\', s), 1);
	while pos('*', s) <> 0 do
		Delete(s, pos('*', s), 1);
	while pos('?', s) <> 0 do
		Delete(s, pos('?', s), 1);
	while pos(':', s) <> 0 do
		Delete(s, pos(':', s), 1);
	while pos('|', s) <> 0 do
		Delete(s, pos('|', s), 1);
	while pos('<', s) <> 0 do
		Delete(s, pos('<', s), 1);
	while pos('>', s) <> 0 do
		Delete(s, pos('>', s), 1);
	while pos('"', s) <> 0 do
		Delete(s, pos('"', s), 1);
	NameGetter.Text := s;
	if NameGetter.Text <> '' then
	begin
		NameNotEmpty := True;
		NameRes := NameGetter.Text;
	end
	else
		ShowMessage('Введите имя.');
	if NameNotEmpty then
	begin
		if not (DirectoryExists(UTF8ToSys(NameRes))) then
		begin
			if not CreateDir(UTF8ToSys(NameRes)) then
				raise Exception.Create('Не удалось создать директорию.');
		end;
		//ShowMessage(GetCurrentDir);
		if not (SetCurrentDir((Format('%s\%s', [GetCurrentDir, UTF8ToSys(NameRes)])))) then
		begin
			ShowMessage('Something wrong');
			RunClick(Sender);
		end;
		hide;
		Main_Menu.Show;
	end;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
	NameNotEmpty := False;
	NameRes := '';
end;

procedure TLoginForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
	if not NameNotEmpty then
		Application.Terminate;
end;

procedure TLoginForm.NameGetterKeyDown(Sender: TObject; var Key: word;
	Shift: TShiftState);
begin
	if Key = 13 then
		RunClick(Sender);
end;

end.
