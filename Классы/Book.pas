{$mode objfpc}

unit Book;

interface

uses SysUtils, md5;

type
	TBook = class
	protected
		Nm: string;
		Yr: integer;
		Pub: string;
		Aut: array of string;
		key: string;
		ACount: longint;
		function GetAut(index: integer): string;
		procedure SetAut(index: integer; auth: string);
		function getKey(): string;
		procedure SetName(Nam: string);
		procedure SetYr(Year: integer);
		procedure SetPub(Publisher: string);
	public
		property Code: string read key;
		procedure DeleteAuthor(index: integer);
		procedure AuthorAdd(auth: string);
		property Name: string read Nm write SetName;
		property Year: longint read Yr write SetYr;
		property Publisher: string read Pub write SetPub;
		property Author[index: integer]: string read GetAut write SetAut;
		procedure Authors();
		property AuthorsCount: longint read ACount;
		destructor Destroy; override;
	end;
//‚ ®á­®¢­®© ¯à®£à ¬¬¥ à á¯ àá¨âì áâà®ª¨ ¤® ­®à¬ «ì­®£® ¢¨¤ . —â®¡ë ¡ë«® 10/10.
implementation

procedure TBook.SetName(nam: string);
begin
	if nam <> '' then
	begin
		nm := nam;
		key := getKey;
	end
	else
		raise Exception.Create('Имя пусто.');
end;

procedure TBook.SetPub(Publisher: string);
begin
	if Publisher <> '' then
	begin
		Pub := Publisher;
		key := getKey;
	end
	else
		raise Exception.Create('Издательство пусто.');
end;

procedure TBook.SetYr(Year: integer);
begin
	if Year > 0 then
	begin
		yr := Year;
		key := getKey;
	end
	else
		raise Exception.Create('Год отрицателен.');
end;

function TBook.getKey(): string;
var
	hashstr: string;
	i: integer;
begin
	hashstr := md5print(md5String(md5print(
		md5String(md5print(md5String(Nm)) + md5print(md5String(IntToStr(yr))))) +
		md5print(md5String(pub))));
	for i := 0 to length(aut) - 1 do
		hashstr := md5print(md5String(hashstr + md5print(md5String(Aut[i]))));
	Result := Copy(HashStr, 0, 15);
end;

procedure TBook.Authors();
var
	i: integer;
begin
	for i := 0 to length(Aut) - 1 do
		writeln(Aut[i]);
end;

destructor TBook.Destroy();
var
	i: integer;
begin
	for i := 0 to length(Aut) - 1 do
		self.DeleteAuthor(0);
	inherited Destroy;
end;

procedure TBook.DeleteAuthor(index: integer);
var
	i: integer;
begin
	for i := index to length(Aut) - 2 do
		Aut[i] := Aut[i + 1];
	SetLength(Aut, length(Aut) - 1);
	key := getKey;
	Dec(ACount);
end;

function TBook.GetAut(index: integer): string;
begin
	Result := Aut[index];
end;

procedure TBook.SetAut(index: integer; auth: string);
begin
	if auth <> '' then
	begin
		key := getKey;
		Aut[index] := auth;
	end
	else
		raise Exception.Create('Íè÷òî ïèøåò êíèãè?');
end;

procedure TBook.AuthorAdd(auth: string);
var
	i, j: longint;
	tmp: string;
begin
	if auth <> '' then
	begin
		SetLength(Aut, length(Aut) + 1);
		self.Aut[length(Aut) - 1] := auth;
		Inc(ACount);
		for i := 0 to length(aut) - 2 do
			for j := 0 to length(aut) - 1 do
				if Aut[i] > Aut[i + 1] then
				begin
					tmp := Aut[i];
					Aut[i] := Aut[i + 1];
					Aut[i + 1] := tmp;

				end;
		key := getKey;

	end
	else
		raise Exception.Create('Ïóñòûå ñòðîêè íå ìîãóò â íàïèñàíèå êíèã!');
end;

end.
