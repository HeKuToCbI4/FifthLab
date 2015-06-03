unit MainMenu;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
	StdCtrls, GetListNameForm, ListEditor;

type

	{ TMain_Menu }

	TMain_Menu = class(TForm)
		CurrLists: TListBox;
		Rename: TButton;
		Open: TButton;
		CreateList: TButton;
		Delete: TButton;
		CloseMenu: TButton;
		Label1: TLabel;

		procedure CloseMenuClick(Sender: TObject);
		procedure CreateListClick(Sender: TObject);
		procedure CurrListsDblClick(Sender: TObject);
		procedure DeleteClick(Sender: TObject);
		procedure FormActivate(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormShow(Sender: TObject);
		procedure OpenClick(Sender: TObject);
		procedure RenameClick(Sender: TObject);
	private
		Files: TStringList;
		PT: TPoint;
		procedure RefreshLists();

		{ private declarations }
	public
		{ public declarations }
	end;

var
	Main_Menu: TMain_Menu;

implementation

{$R *.lfm}

{ TMain_Menu }

procedure TMain_Menu.RefreshLists();
var
	i: integer;
	path: string;
	sr: TSearchRec;
begin
	CurrLists.Items.Clear;
	path := GetCurrentDir + '\';
	Files := TStringList.Create;
	try
		if FindFirst(Path + '*.xml', FaAnyFile, SR) = 0 then
		begin
			repeat
				Files.Add(SysToUTF8(SR.Name)); //Fill the list
			until FindNext(SR) <> 0;
			FindClose(SR);
		end;
		for i := 0 to files.Count - 1 do
			CurrLists.Items.Add(copy(files[i], 0, Length(files[i]) - 4));
	finally
		Files.Free;
	end;
end;

procedure TMain_Menu.OpenClick(Sender: TObject);
var
	i: integer;
begin

	if CurrLists.SelCount = 1 then
	begin
		for i := CurrLists.Items.Count - 1 downto 0 do
			if CurrLists.Selected[i] then
			begin
				if QuestionDlg('Подвердите действие', Format('Вы хотите открыть %s?',
					[CurrLists.Items[i]]), mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
				begin
					hide;
					CurrListEditor.EditShow(Sender, CurrLists.Items[i]);
				end;
			end;

		Show;
		RefreshLists();
	end;
end;

procedure TMain_Menu.RenameClick(Sender: TObject);
var
	i: integer;
begin
	if CurrLists.SelCount = 1 then
	begin
		for i := CurrLists.Items.Count - 1 downto 0 do
			if CurrLists.Selected[i] then
			begin
				begin
					List_Name_Get.NameGetter.Clear;
					List_Name_Get.NewName := CurrLists.Items[i];
					List_Name_Get.ShowModal;
				end;
				if List_Name_Get.okclicked then
				begin
					RenameFile(UTF8ToSys(Format('%s.xml', [CurrLists.Items[i]])),
						UTF8ToSys(Format('%s.xml', [List_Name_Get.NewName])));
				end;
				break;
			end;
	end;

	self.RefreshLists();
end;

procedure TMain_Menu.CreateListClick(Sender: TObject);
begin
	hide;
	CurrListEditor.CreateShow();
	Show;
end;

procedure TMain_Menu.CurrListsDblClick(Sender: TObject);  //TODO FIX DIS.
begin
	if (CurrLists.GetIndexAtXY(pt.x, pt.y) > -1) and
		(CurrLists.GetIndexAtXY(pt.x, pt.y) < CurrLists.Count) then
		OpenClick(Sender);
end;

procedure TMain_Menu.CloseMenuClick(Sender: TObject);
begin
	Application.Terminate;
end;

procedure TMain_Menu.DeleteClick(Sender: TObject);
var
	i: integer;
begin
	if CurrLists.SelCount = 1 then
		for i := CurrLists.Items.Count - 1 downto 0 do
			if CurrLists.Selected[i] then
			begin
				if QuestionDlg('Подвердите действие', Format('Вы хотите удалить %s?',
					[CurrLists.Items[i]]), mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
					DeleteFile(UTF8ToSys(Format('%s.xml', [CurrLists.Items[i]])));
			end;
	Show;
	RefreshLists();
end;

procedure TMain_Menu.FormActivate(Sender: TObject);
begin
	RefreshLists();
end;

procedure TMain_Menu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
	Application.Terminate;
end;


procedure TMain_Menu.FormShow(Sender: TObject);
begin
	RefreshLists();
end;

end.
