unit Get_2_Indexes;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
	ExtCtrls;

type

	{ T_2IndForm }

	T_2IndForm = class(TForm)
		Accept: TButton;
		Cancel: TButton;
		FInd: TLabeledEdit;
		SInd: TLabeledEdit;
		procedure AcceptClick(Sender: TObject);
		procedure CancelClick(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormShow(Sender: TObject);
	private
		{ private declarations }
	public
		okclicked: boolean;
		ind1, ind2: longint;
		procedure ExcIndexes;
        procedure MoveIndexes;{ public declarations }
	end;

var
	_2IndForm: T_2IndForm;

implementation

{$R *.lfm}

{ T_2IndForm }

procedure T_2IndForm.ExcIndexes;
begin
	self.Caption := 'Обмен';
	FInd.EditLabel.Caption := 'Первый индекс';
	SInd.EditLabel.Caption := 'Второй индекс';
    FInd.Clear;
    SInd.Clear;
	ShowModal;
end;
procedure T_2IndForm.MoveIndexes;
begin
	self.Caption := 'Перемещение';
	FInd.EditLabel.Caption := 'Индекс объекта';
	SInd.EditLabel.Caption := 'Целевой индекс';
    FInd.Clear;
    SInd.Clear;
	ShowModal;
end;

procedure T_2IndForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
	self.Caption := '_cap_';
	ind1 := StrToIntDef(FInd.Text, -1);
	Ind2 := StrToIntDef(SInd.Text, -1);
end;

procedure T_2IndForm.FormShow(Sender: TObject);
begin
	OkClicked := False;
end;

procedure T_2IndForm.AcceptClick(Sender: TObject);
begin
	okclicked := True;
	Close;
end;

procedure T_2IndForm.CancelClick(Sender: TObject);
begin
	okclicked := False;
	Close;
end;

end.

