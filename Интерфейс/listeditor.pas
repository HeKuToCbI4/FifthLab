unit ListEditor;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
	StdCtrls, ListOfBooks, BookEditForm, GetListNameForm, Get_2_Indexes, LCLType;
//, Zoidsberg;

type

	{ TListEditor }

	TListEditor = class(TForm)
		Search: TButton;
		Save_As: TButton;
		Edit: TButton;
		BookInfo: TMemo;
		Save: TButton;
		Insert: TButton;
		Append: TButton;
		CurrBooks: TListBox;
		Remove: TButton;
		DeleteBook: TButton;
		Clear: TButton;
		Move: TButton;
		Sort: TButton;
		Exchange: TButton;
		Cancel: TButton;
		Rename: TButton;
		procedure AppendClick(Sender: TObject);
		procedure CancelClick(Sender: TObject);
		procedure CurrBooksSelectionChange(Sender: TObject; User: boolean);
		procedure EditClick(Sender: TObject);
		procedure FormActivate(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormShow(Sender: TObject);
		procedure EditShow(Sender: TObject; listname: string);
		procedure CreateShow();
		procedure MoveClick(Sender: TObject);
		procedure ExchangeClick(Sender: TObject);
		procedure ClearClick(Sender: TObject);
		procedure DeleteBookClick(Sender: TObject);
		procedure InsertClick(Sender: TObject);
		procedure RemoveClick(Sender: TObject);
		procedure RenameClick(Sender: TObject);
		procedure SaveClick(Sender: TObject);
		procedure Save_AsClick(Sender: TObject);
		procedure SearchClick(Sender: TObject);
		procedure SortClick(Sender: TObject);
	private
		BookList: TBookList;
		BookNamesList: TStringList;
		startname: string;
		procedure Refresh();

		{ private declarations }
	public
		{ public declarations }
	end;

var
	CurrListEditor: TListEditor;

implementation

{$R *.lfm}

const
	mrName = 16;
	mrYear = 17;
	mrPub = 18;

{ TListEditor }
procedure TListEditor.CreateShow();
var
	i: longint;
	str: string;
begin
	BookList := TBookList.Create;
	BookNamesList := TStringList.Create;
	str := 'Default';
	i := 0;
	while fileexists(UTF8ToSys(str + '.xml')) do
	begin
		Inc(i);
		str := Format('Default%d', [i]);
	end;
	startname := str;
	BookList.NameList := str;
	BookInfo.Lines.Clear;
	ShowModal;
end;

procedure TListEditor.Refresh();
var
	i: integer;
begin
	CurrBooks.Clear;
	for i := 0 to BookList.Count - 1 do
	begin
		CurrBooks.Items.Add(Format('%d. %s', [i, BookList[i]^.Name]));
	end;
	BookInfo.Clear;
end;

procedure TListEditor.DeleteBookClick(Sender: TObject);
var
	i: longint;
	input: string;
begin
	if BookList.Count = 0 then
		Application.MessageBox('Нечего удалять.', 'Ошибка', MB_ICONINFORMATION)
	else
	begin
		i := -2;
		repeat
			if InputQuery('Индекс', 'Введите индекс', input) then
				i := StrToIntDef(input, -1)
			else
				break;
			if (i > -1) and (i < CurrBooks.Count) then
			begin
				if QuestionDlg('Подтвердите действие', Format('Подтвердите удаление %s',
					[Copy(CurrBooks.Items[i], 3, length(CurrBooks.Items[i]))]),
					mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
				begin
					BookList.Delete(i);
					refresh;
				end;
				break;
			end;
		until (QuestionDlg('Ошибка!', 'Повторить ввод?', mtConfirmation,
				[mrYes, 'Да', mrNo, 'Нет'], '') = mrNo) or
			((i > -1) and (i < CurrBooks.Count)) or (i = -2);
		//Refresh;

	end;
end;

procedure TListEditor.InsertClick(Sender: TObject);
var
	i: longint;
	input: string;
begin
	if InputQuery('Индекс', 'Введите индекс', input) then
	begin
		i := StrToIntDef(input, -1);

		if (i > -1) and (i <= CurrBooks.Count) then
		begin
			Book_Editor.CreateItem();
			if Book_Editor.OkClicked then
			begin
				BookList.insert(i, Book_Editor.PB);
				Refresh;
			end;
		end
		else
		if (QuestionDlg('Ошибка!', Format('Ошибка%sПовторить ввод?', [#13#10]),
			mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') = mrYes) then
			InsertClick(Sender);

	end;
end;

procedure TListEditor.RemoveClick(Sender: TObject);
var
	i: longint;
begin
	for i := 0 to CurrBooks.Count - 1 do
		if CurrBooks.Selected[i] then
		begin
			if QuestionDlg('Подтвердите действие', Format('Подтвердите удаление %s',
				[Copy(CurrBooks.Items[i], 3, length(CurrBooks.Items[i]))]),
				mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
				BookList.Delete(i);
			break;
		end;
	Refresh;
end;

procedure TListEditor.RenameClick(Sender: TObject);
var
	input: string;
begin
	if InputQuery('Установка имени', 'Введите новое имя списка', input) then
	begin
		while pos(' ', input) = 1 do
			Delete(input, 1, 1);
		while pos('/', input) <> 0 do
			Delete(input, pos('/', input), 1);
		while pos('\', input) <> 0 do
			Delete(input, pos('\', input), 1);
		while pos('*', input) <> 0 do
			Delete(input, pos('*', input), 1);
		while pos('?', input) <> 0 do
			Delete(input, pos('?', input), 1);
		while pos(':', input) <> 0 do
			Delete(input, pos(':', input), 1);
		while pos('|', input) <> 0 do
			Delete(input, pos('|', input), 1);
		while pos('<', input) <> 0 do
			Delete(input, pos('<', input), 1);
		while pos('>', input) <> 0 do
			Delete(input, pos('>', input), 1);
		while pos('"', input) <> 0 do
			Delete(input, pos('"', input), 1);
		if input <> '' then
		begin
			BookList.NameList := input;
			self.Caption := Format('Редактор списка %s', [BookList.NameList]);
		end
		else
		if QuestionDlg('Повторить?', 'Повторить ввод?', mtConfirmation,
			[mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
			RenameClick(Sender);
	end;
end;

procedure TListEditor.SaveClick(Sender: TObject);
begin

	if pos('Default', BookList.NameList) = -1 then
		if QuestionDlg('АХТУНГ', 'Имя списка определено' + #13#10 +
			'по умолчанию. Изменить?', mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') =
			mrYes then
			RenameClick(Sender);
	if not fileexists(BookList.NameList) then
	begin
		if QuestionDlg('Сохранение?', Format('Список сохранится как %s%sПродолжаем?',
			[BookList.Namelist, #13#10]), mtConfirmation, [mrYes, 'Да', mrNo, 'Нет'], '') =
			mrYes then
		begin
			BookList.ToFile(BookList.NameList);
			StartName := BookList.NameList;
		end;
	end
	else
		case QuestionDlg('Ошибка', Format('Файл с именем %s уже существует',
				[BookList.Namelist]), mtConfirmation, [mrYes, 'Переписать', mrNo,
				'Изменить имя', mrCancel, 'Отмена'], '')
			of
			mrYes:
			begin
				BookList.ToFile(BookList.NameList);
				StartName := BookList.NameList;
			end;
			mrNo: Save_AsClick(Sender);
		end;
end;

procedure TListEditor.Save_AsClick(Sender: TObject);
begin
	List_Name_Get.NameGetter.Clear;
	List_Name_Get.NameGetter.Text := BookList.NameList;
	List_Name_Get.ShowModal;
	if List_Name_Get.okclicked then
	begin
		BookList.ToFile(List_Name_Get.NewName);
		BookList.NameList := List_Name_Get.NewName;
		StartName := List_Name_Get.NewName;
	end;
	//else
	//    List_Name_Get.ShowModal;

end;

procedure TListEditor.SearchClick(Sender: TObject);
var
	i: integer;
	input, res: string;

begin
	res := 'Найденные индексы:';
	case QuestionDlg('Поиск', 'Выберите тип', mtCustom,
			[mrName, 'По названию', mrPub, 'По автору', mrYes, 'Точный поиск',
			mrCancel, 'Отмена'], '') of
		mrName: if InputQuery('Поиск', 'Введите имя', input) then
			begin
				for i := 0 to BookList.Count - 1 do
					if pos(input, BookList[i]^.Name) <> 0 then
					begin
						res := res + ' '#13#10 + IntToStr(i);
					end;
				if res <> 'Найденные индексы:' then
					ShowMessage(res)
				else
					ShowMessage('Ничего не найдено');
			end;
		mrPub:
			if InputQuery('Поиск', 'Введите автора', input) then
			begin
				for i := 0 to BookList.Count - 1 do
					if pos(input, BookList[i]^.Publisher) <> 0 then
					begin
						res := res + ' '#13#10 + IntToStr(i);
					end;
				if res <> 'Найденные индексы:' then
					ShowMessage(res)
				else
					ShowMessage('Ничего не найдено');
			end;
		mrYes:
		begin
			Book_Editor.CreateItem();
			if Book_Editor.OkClicked then
				for i := 0 to BookList.Count - 1 do
					if BookList[i]^.Code = Book_Editor.PB^.Code then
					begin
						ShowMessage(Format('Найденный индекс: %d', [i]));
						exit;
					end;
			//else
			Application.MessageBox('Ничего не найдено!', 'Неудача', MB_ICONINFORMATION);
		end;
	end;

end;

procedure TListEditor.SortClick(Sender: TObject);
begin
	case QuestionDlg('Сортировка?', 'Выберите тип', mtCustom,
			[mrName, 'По Названию', mrYear, 'По году', mrPub, 'По издателю',
			mrCancel, 'Отмена'], '') of
		mrName: BookList.SortByName();
		mrYear: BookList.SortByYear();
		mrPub: BookList.SortByPublisher();
		//mrCancel: Woop_Woop.ShowIt;
	end;
	refresh;
end;

procedure TListEditor.ClearClick(Sender: TObject);
begin
	if QuestionDlg('Очистка', 'Подтвердите действие', mtConfirmation,
		[mrYes, 'Очистить', mrNo, 'Отмена'], '') = mrYes then
		BookList.Clear;
	refresh;
end;

procedure TListEditor.AppendClick(Sender: TObject);
begin
	Book_Editor.CreateItem();
	if Book_Editor.OkClicked then
	begin
		BookList.append(Book_Editor.PB);

		refresh();
	end;
end;

procedure TListEditor.CancelClick(Sender: TObject);
begin
	self.Close;
end;

procedure TListEditor.CurrBooksSelectionChange(Sender: TObject; User: boolean);
var
	i, j: longint;
begin
	BookInfo.Lines.Clear;
	for i := 0 to CurrBooks.Count - 1 do
		if CurrBooks.Selected[i] then
		begin
			with BookInfo.Lines do
			begin
				Add('Индекс: ' + IntToStr(i));
				Add(Format('Название: %s', [BookList[i]^.Name]));
				Add(Format('Год: %d', [BookList[i]^.Year]));
				Add(Format('Издательство: %s', [BookList[i]^.Publisher]));
				Add(Format('Код: %s', [BookList[i]^.Code]));
				Add('Авторы: ');
				for j := 0 to BookList[i]^.AuthorsCount - 1 do
					Add(Format('%d. %s', [j, BookList[i]^.Author[j]]));
			end;
		end;
end;

procedure TListEditor.EditClick(Sender: TObject);
var
	i: longint;
begin
	if CurrBooks.SelCount = 1 then
		for i := 0 to CurrBooks.Count - 1 do
			if CurrBooks.Selected[i] then
			begin
				Book_Editor.EditItem(BookList[i]);
				if Book_Editor.OkClicked then
				begin
					BookList.Delete(i);
					BookList.insert(i, Book_Editor.PB);
				end;
				refresh();
			end;
end;

procedure TListEditor.FormActivate(Sender: TObject);
begin
	self.Caption := Format('Редактор списка %s', [BookList.NameList]);
	Refresh();
end;

procedure TListEditor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
//<TODO> ПОЧИНИТЬ </TODO>
var
	tmp: TBookList;
	i: longint;
begin

	if fileexists(UTF8TOSys(startName + '.xml')) then
	begin
		tmp := TBookList.Create;
		tmp.FromFile(StartName);
		if ((StartName = BookList.NameList) and (tmp.Count = BookList.Count)) then
		begin
			i := 0;
			while (i < tmp.Count) and (i < BookList.Count) do
			begin
				if (tmp[i]^.Code <> BookList[i]^.Code) then
				begin
					case QuestionDlg('Сохранить изменения?', 'Имеются несохранённые изменения,' +
							#13#10 + 'Сохранить?', mtConfirmation, [mrYes, 'Да', mrNo,
							'Нет', mrCancel, 'Отмена'], '') of
						mrYes:
						begin
							Save_AsClick(Sender);
							break;
						end;
						mrNo: exit;
						mrCancel:
						begin
							CloseAction := CaNone;
							break;
						end;
					end;
				end;
				Inc(i);
			end;
		end
		else
			case QuestionDlg('Сохранить изменения?', 'Имеются несохранённые изменения,' +
					#13#10 + 'Сохранить?', mtConfirmation, [mrYes, 'Да', mrNo, 'Нет',
					mrCancel, 'Отмена'], '') of
				mrYes: Save_AsClick(Sender);
				mrNo: exit;
				mrCancel: CloseAction := CaNone;
			end;

	end
	else
	if BookList.Count > 0 then
		case QuestionDlg('Сохранить изменения?', 'Имеются несохранённые изменения,' +
				#13#10 + 'Сохранить?', mtConfirmation, [mrYes, 'Да', mrNo, 'Нет',
				mrCancel, 'Отмена'], '') of
			mrYes: Save_AsClick(Sender);
			mrNo: Exit;
			mrCancel: CloseAction := CaNone;
		end;
end;

procedure TListEditor.FormShow(Sender: TObject);
begin
	self.Caption := Format('Редактор списка %s', [BookList.NameList]);
end;

procedure TListEditor.EditShow(Sender: TObject; listName: string);
begin

	BookList := TBookList.Create;
	BookNamesList := TStringList.Create;
	try
		BookList.FromFile(listname);
	except
		on E: Exception do
		begin
			ShowMessage('Ошибка чтения файла.');
			if QuestionDlg('Ошибка', 'Удалить файл с ошибкой?', mtConfirmation,
				[mrYes, 'Да', mrNo, 'Нет'], '') = mrYes then
				DeleteFile(UTF8ToSys(listname + '.xml'));
			exit;

		end;

	end;


	startName := listname;
	Refresh;
	BookInfo.Lines.Clear;
	ShowModal;
end;

procedure TListEditor.MoveClick(Sender: TObject);	//FIX
begin
	if BookList.Count < 0 then
		Application.MessageBox('Нечего перемещать!',
			'Внимание!', MB_ICONINFORMATION)
	else
	begin
		_2IndForm.MoveIndexes;
		if _2IndForm.okclicked then
			with _2IndForm do
				if (ind1 >= 0) and (ind2 >= 0) and (ind1 < BookList.Count) and
					(ind1 <> ind2) and (ind2 < BookList.Count) then
				begin
					BookList.Move(ind1, ind2);
					Refresh;
				end
				else if QuestionDlg('Ошибка', 'Ошибка ввода индексов', mtInformation,
					[mrYes, 'Повторить', mrNo, 'Закрыть'], '') = mrYes then
					MoveClick(Sender);

	end;
	refresh;
end;

procedure TListEditor.ExchangeClick(Sender: TObject);
begin
	if BookList.Count < 2 then
		Application.MessageBox('В списке недостаточно элементов для обмена!',
			'Внимание!', MB_ICONINFORMATION)
	else
	begin
		_2IndForm.ExcIndexes;
		if _2IndForm.okclicked then
			with _2IndForm do
				if (ind1 >= 0) and (ind2 >= 0) and (ind1 < BookList.Count) and
					(ind2 < BookList.Count) then
				begin
					BookList.Exchange(ind1, ind2);
				end
				else if QuestionDlg('Ошибка', 'Ошибка ввода индексов', mtInformation,
					[mrYes, 'Повторить', mrNo, 'Закрыть'], '') = mrYes then
					ExchangeClick(Sender);

	end;
	Refresh;
end;

end.
