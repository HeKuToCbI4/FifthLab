unit GetListNameForm;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

	{ TList_Name_Get }

	TList_Name_Get = class(TForm)
		NameGetter: TEdit;
		Ok: TButton;
		Cancel: TButton;
		procedure CancelClick(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure NameGetterKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
		procedure OkClick(Sender: TObject);
	private
	public
		NewName: string;
		okclicked: boolean;
	end;

var
	List_Name_Get: TList_Name_Get;

implementation

{$R *.lfm}




procedure TList_Name_Get.OkClick(Sender: TObject);
var s:Ansistring;
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
		if FileExists(Format('%s.xml', [NameGetter.Text])) and not
			(NameGetter.Text = NewName) then
		begin
			if QuestionDlg('Ахтунг!', 'Файл с таким именем уже существует' +
				#13#10 + 'Заменить?', mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
			begin
				DeleteFile(Format('%s.xml', [NameGetter.Text]));
				NewName := NameGetter.Text;
				okclicked := True;
				Close;
			end;
		end
		else
		begin
			NewName := NameGetter.Text;
			okclicked := True;
			Close;
		end;
	end;
end;

procedure TList_Name_Get.CancelClick(Sender: TObject);
begin
	okclicked := False;
	Close;
end;



procedure TList_Name_Get.FormShow(Sender: TObject);
begin
	OkClicked := False;
end;

procedure TList_Name_Get.NameGetterKeyDown(Sender: TObject; var Key: word;
	Shift: TShiftState);
begin
	//showmessage('Key '+inttostr(key)+' was pressed');
	if Key = 13 then
	begin
		OkClick(Sender);
	end;
end;

end.
