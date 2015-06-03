unit SetListName;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

	{ TSetListName }

	TSetListName = class(TForm)
		ListName: TEdit;
		Ok: TButton;
		Cancel: TButton;
		procedure CancelClick(Sender: TObject);
		procedure OkClick(Sender: TObject);
	private
		{ private declarations }
	public
		okclicked: boolean;
		NewName: string;{ public declarations }
	end;

var
	SetListName: TSetListName;

implementation

{$R *.lfm}

{ TSetListName }

procedure TSetListName.OkClick(Sender: TObject);
begin
	okclicked := True;
	if ListName.Text <> '' then
		NewName := ListName.Text
	else
		ShowMessage('Введите название.');
end;

procedure TSetListName.CancelClick(Sender: TObject);
begin
	okclicked := False;
	Close;
end;

end.

