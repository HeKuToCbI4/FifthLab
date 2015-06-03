unit ListNameGet;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

	{ TListNameGetter }

	TListNameGetter = class(TForm)
		NameGetter: TEdit;
		Ok: TButton;
		Cancel: TButton;
		procedure CancelClick(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormShow(Sender: TObject);
		procedure ListNameEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
		procedure NameGetterKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
		procedure OkClick(Sender: TObject);
	private
		Files: TStringList;
		procedure RefreshLists;{ private declarations }
	public
		NewName: string;
		okclicked: boolean;{ public declarations }
	end;

var
	ListNameGetter: TListNameGetter;

implementation

{$R *.lfm}

{ TListNameGetter }
procedure TListNameGetter.RefreshLists();
var
	i: integer;
	path: string;
	sr: TSearchRec;
begin
	path := GetCurrentDir + '\';
	ShowMessage(path);
	if FindFirst(Path + '*.xml', FaAnyFile, SR) = 0 then
	begin
		repeat
			Files.Add(SR.Name);
			ShowMessage(Sr.Name);//Fill the list
		until FindNext(SR) <> 0;
		FindClose(SR);
	end;
end;



procedure TListNameGetter.OkClick(Sender: TObject);
var
	i: longint;
	exists: boolean;
begin
	RefreshLists;
	if ListNameEdit.Text <> '' then
	begin
		exists := False;
		for i := 0 to Files.Count - 1 do
			if (Format('%s.xml', [NameGetter.Text]) = Files[i]) and not
				(NameGetter.Text = NewName) then
				exists := True;
		if exists then
		begin
			if QuestionDlg('Ахтунг!', 'Файл с таким именем уже существует' +
				#13#10 + 'Заменить?', mtConfirmation, [mbYes, 'Да', mbNo, 'Нет'], '') = mrYes then
			begin
				DeleteFile(Format('%s.xml', [NameGetter.Text]));
				NewName := NameGetter.Text;
				okclicked := True;
				Close;
			end;
		end;
	end;
end;

procedure TListNameGetter.CancelClick(Sender: TObject);
begin
	okclicked := False;
	Close;
end;


procedure TListNameGetter.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
	Files.Free;
end;

procedure TListNameGetter.FormShow(Sender: TObject);
begin
	Files := TStringList.Create;

end;

procedure TListNameGetter.ListNameEditKeyDown(Sender: TObject;
	var Key: word; Shift: TShiftState);
begin
	ShowMessage('Key ' + IntToStr(key) + ' was pressed');
	if Key = 13 then
	begin
		OkClick(Sender);
	end;
end;

procedure TListNameGetter.NameGetterKeyDown(Sender: TObject; var Key: word;
	Shift: TShiftState);
begin
	if Key = 13 then
	begin
		OkClick(Sender);
	end;
end;


end.



