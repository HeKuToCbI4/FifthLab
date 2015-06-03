unit ListNameGet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TListNameGetter }

  TListNameGetter = class(TForm)
    Ok: TButton;
    Cancel: TButton;
    ListNameEdit: TEdit;
    procedure CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OkClick(Sender: TObject);
  private
    { private declarations }
  public
    NewName: String;
    okclicked: boolean;{ public declarations }
  end;

var
  ListNameGetter: TListNameGetter;

implementation

{$R *.lfm}

{ TListNameGetter }

procedure TListNameGetter.OkClick(Sender: TObject);
begin
   if ListNameEdit.Text<>'' then
   begin
      NewName:=ListNameEdit.Text;
      okclicked:=true;
      close;
   end;
end;

procedure TListNameGetter.CancelClick(Sender: TObject);
begin
   okclicked:=false;
   close;
end;

procedure TListNameGetter.FormActivate(Sender: TObject);
begin
  okclicked:=false;
end;

end.

