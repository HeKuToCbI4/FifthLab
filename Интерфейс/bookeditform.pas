unit BookEditForm;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
	StdCtrls, Book;

type
	PointB = ^TBook;

type

	{ TBook_Editor }

	TBook_Editor = class(TForm)
		Authors: TLabel;
		Authors_Memo: TMemo;
		Accept: TButton;
		Cancel: TButton;
		Book_Name: TEdit;
		Year: TEdit;
		Publisher: TEdit;
		Nm: TLabel;
		Yr: TLabel;
		Publ: TLabel;
		procedure AcceptClick(Sender: TObject);
		procedure CancelClick(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormShow(Sender: TObject);
		procedure EditItem(Item: PointB);
		procedure CreateItem();

	private
		{ private declarations }
	public
		PB: PointB;
		OkClicked: boolean;
		{ public declarations }
	end;

var
	Book_Editor: TBook_Editor;

implementation

{$R *.lfm}

{ TBook_Editor }
procedure TBook_Editor.CreateItem();
begin
	new(PB);
	PB^ := TBook.Create;
	Book_Name.Clear;
	Year.Clear;
	Publisher.Clear;
	Authors_Memo.Lines.Clear;
	ShowModal();
end;

procedure TBook_Editor.EditItem(Item: PointB);
var
	i: longint;
begin
	new(PB);
	PB^ := TBook.Create;
	Authors_Memo.Lines.Clear;
	Book_Name.Text := Item^.Name;
	Publisher.Text := Item^.Publisher;
	Year.Text := IntToStr(Item^.Year);
	for i := 0 to Item^.AuthorsCount - 1 do
		Authors_Memo.Lines.Add(Item^.Author[i]);
	ShowModal();
end;

procedure TBook_Editor.AcceptClick(Sender: TObject);
begin
	okclicked := True;
	Close;
end;

procedure TBook_Editor.CancelClick(Sender: TObject);
begin
	OkClicked := False;
	Close;
end;

procedure TBook_Editor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
	i: longint;
begin
	if not OkClicked then
	begin
		PB^.Free;
		Dispose(PB);
	end
	else
	begin
		if Book_Name.Text <> '' then
			PB^.Name := Book_Name.Text
		else
			case QuestionDlg('Наименование', 'Наименование не установленно' +
					#13#10 + 'Установить по умолчанию?', mtConfirmation,
					[mrYes, 'Да', mrNo, 'Нет'], '') of
				mrYes:
				begin
					PB^.Name := 'Не указано';
				end;
				mrNo:
				begin
					CloseAction := CaNone;
				end;
			end;
		if (Year.Text <> '') and (StrToIntDef(Year.Text, -1) > 0) then
			PB^.Year := StrToInt(Year.Text)
		else
			case QuestionDlg('Год издания', 'Год издания введён неверно' +
					#13#10 + 'Установить по умолчанию?', mtConfirmation,
					[mrYes, 'Да', mrNo, 'Нет'], '') of
				mrYes:
				begin
					PB^.Year := 127001;
				end;
				mrNo:
				begin
					CloseAction := CaNone;
				end;
			end;
		if Publisher.Text <> '' then
			PB^.Publisher := Publisher.Text
		else
			case QuestionDlg('Издательство', 'Издательство не указано' +
					#13#10 + 'Установить по умолчанию?', mtConfirmation,
					[mrYes, 'Да', mrNo, 'Нет'], '') of
				mrYes:
				begin
					PB^.Publisher := 'Не указано';
				end;
				mrNo:
				begin
					CloseAction := CaNone;
				end;
			end;
		for i := 0 to Authors_Memo.Lines.Count - 1 do
			if Authors_Memo.Lines[i] <> '' then
				PB^.AuthorAdd(Authors_Memo.Lines[i]);
	end;
end;

procedure TBook_Editor.FormShow(Sender: TObject);
begin

end;


end.
