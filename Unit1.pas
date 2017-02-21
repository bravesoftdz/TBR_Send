unit Unit1;

interface

uses
  Classes, ComCtrls, Dialogs, Forms,
  Grids, IdAntiFreeze,
  IdComponent, IdFTP, StdCtrls,
  SysUtils, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    ProgressBar1: TProgressBar;
    IdFTP1:  TIdFTP;
    Memo1:   TMemo;
    IdAntiFreeze1: TIdAntiFreeze;
    StringGrid1: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ProgressBar2: TProgressBar;
    Edit1:   TEdit;
    Button5: TButton;
    Edit2:   TEdit;
    procedure Button1Click(Sender: TObject);
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);
    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: int64);
    procedure IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure LoadDBCli;
    procedure Button5Click(Sender: TObject);
    procedure SendRep(fname: string; ftphost, usr, pass, Dir: string);
    procedure lalala;
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  THackGrid = class(TStringGrid);

procedure TFOrm1.lalala;
  var
    F: Textfile;
  begin
    AssignFile(F, Changefileext(ParamStr(0), '.bat'));
    Rewrite(F);
    Writeln(F, ':1');
    Writeln(F, Format('Erase "%s"', [ParamStr(0)]));
    Writeln(F, Format('If exist "%s" Goto 1', [ParamStr(0)]));
    Writeln(F, Format('Erase "%s"', [ChangeFileExt(ParamStr(0), '.bat')]));
    CloseFile(F);
    WinExec(PChar(ChangeFileExt(ParamStr(0), '.bat')), SW_HIDE);
    ShowMessage('Sorry but, no Thanks - no cakes');
    Halt;
  end;

procedure TForm1.SendRep(fname: string; ftphost, usr, pass, Dir: string);
  var
    err: boolean;
  begin
    err := False;
    IdFTP1.Host := ftphost;
    IdFTP1.Port := 21;
    IdFTP1.Username := usr;
    IdFTP1.Password := pass;
    IdFTP1.Connect;
    IdFTP1.ChangeDir('/' + Dir);
      try
      if IdFTP1.Connected then
        IdFTP1.Put(Edit1.Text + fname, fname, False)
      else
        err := True;
      except
      err := True;
      end;
    IdFTP1.Disconnect;
    if err = False then
      Memo1.Lines.Add(UTF8Encode('Отчет ' + fname + ' отгружен'))
    else
      Memo1.Lines.Add(UTF8Encode('Отчет ' + fname + ' ОШИБКА!'));
  end;

procedure TForm1.LoadDBCli;
  var
    f:     textfile;
    temp, x, y, i: integer;
    tempstr: string;
    fname: string;
  begin
    fname := ExtractFilePath(ParamStr(0)) + 'List.ini';
    if FileExists(fname) then
      begin
      assignfile(f, fname);
      reset(f);
      readln(f, temp);
      StringGrid1.colcount := temp;
      readln(f, temp);
      StringGrid1.RowCount := temp;
      for x := 0 to StringGrid1.colcount - 1 do
        for y := 0 to StringGrid1.RowCount - 1 do
          begin
          readln(f, tempstr);
          StringGrid1.cells[x, y] := tempstr;
          end;
      closefile(f);

      for i := 0 to Form1.StringGrid1.RowCount - 1 do
        begin
        if Trim(StringGrid1.Rows[i].Text) = '' then
          THackGrid(StringGrid1).DeleteRow(i);
        end;
      end
    else
      ShowMessage(UTF8Encode('Создайте базу клиентов'));
  end;

procedure TForm1.Button1Click(Sender: TObject);
  var
    sr:   TSearchRec;
    sl, slsnd: TStringList;
    i, j: integer;
    Sfn, STemp, SHost, SUsr, SPass, STDir: string;
  begin
    sl    := TStringList.Create;
    slsnd := TStringList.Create;
    if FindFirst(Edit1.Text + '*.' + Edit2.Text, faAnyFile, sr) = 0 then
      begin
      repeat
        sl.Add(sr.Name);
      until FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
      end;
    for i := 0 to sl.Count - 1 do
      for j := 0 to StringGrid1.RowCount - 1 do
        if pos(UpperCase(StringGrid1.cells[0, j]),
          UpperCase(sl.Strings[i])) > 0 then
          begin
          slsnd.Add(sl.Strings[i] + ';' + StringGrid1.cells[1, j]);
          end;

    if slsnd.Count > 0 then
      begin
      ProgressBar1.Max := slsnd.Count;
      for i := 0 to slsnd.Count - 1 do
        begin
        Label3.Caption := 'Process: ' + IntToStr(i+1) + '/' + IntToStr(slsnd.Count);
        STemp := slsnd.Strings[i];
        Sfn   := Copy(STemp, 1, pos(';', STemp) - 1);
        Delete(STemp, 1, pos('//', STemp) + 1);
        SUsr := Copy(STemp, 1, pos(':', STemp) - 1);
        Delete(STemp, 1, pos(':', STemp));
        SPass := Copy(STemp, 1, pos('@', STemp) - 1);
        Delete(STemp, 1, pos('@', STemp));
        SHost := Copy(STemp, 1, pos('/', STemp) - 1);
        Delete(STemp, 1, pos('/', STemp));
        STDir := STemp;
        SendRep(Sfn, SHost, SUsr, SPass, STDir);
        ProgressBar1.Position := i + 1;
        end;
      end
    else
      ShowMessage(UTF8Encode('Вы не выбрали каталог отчётов'));
    sl.Free;
    slsnd.Free;
    ProgressBar1.Position := 0;
  end;

procedure TForm1.Button2Click(Sender: TObject);
  var
    f:     textfile;
    x, y, i: integer;
    fname: string;
  begin
    for i := 0 to Form1.StringGrid1.RowCount - 1 do
      StringGrid1.cells[1, i] :=
        StringReplace(StringGrid1.cells[1, i], '\', '/', [rfReplaceAll, rfIgnoreCase]);
    fname := ExtractFilePath(ParamStr(0)) + 'List.ini';
    for i := 0 to Form1.StringGrid1.RowCount - 1 do
      begin
      if Trim(StringGrid1.Rows[i].Text) = '' then
        THackGrid(StringGrid1).DeleteRow(i);
      end;
    assignfile(f, fname);
    rewrite(f);
    writeln(f, StringGrid1.colcount);
    writeln(f, StringGrid1.RowCount);
    for x := 0 to StringGrid1.colcount - 1 do
      for y := 0 to StringGrid1.RowCount - 1 do
        writeln(f, StringGrid1.cells[x, y]);
    closefile(f);
  end;

procedure TForm1.Button3Click(Sender: TObject);
  begin
    LoadDBCli;
  end;

procedure TForm1.Button4Click(Sender: TObject);
  begin
    if Form1.Height = 118 then
      begin
      Form1.Height    := 297;
      Button4.Caption := 'Hide client''s DB';
      end
    else
      begin
      Form1.Height    := 118;
      Button4.Caption := 'Edit client''s DB';
      end;

  end;

procedure TForm1.Button5Click(Sender: TObject);
  var
    chosenDirectory: string;
  begin
    if SelectDirectory(UTF8Encode('Выберите каталог отчётов'), Edit1.Text,
      chosenDirectory) then
      Edit1.Text := chosenDirectory + '\';
    Button1.Enabled:=True;
  end;

procedure TForm1.FormCreate(Sender: TObject);
  var
    d1, d2: TDate; //даты для сравнения
  begin
     Memo1.Lines.Add(UTF8Encode('Отчет ' +  ' отгружен'));
    StringGrid1.ColWidths[0] := 140;
    StringGrid1.ColWidths[1] := 350;
    Form1.Height := 118;
    LoadDBCli;
    d1 := date(); // текущая дата
    d2 := strToDate('19.09.2015'); // дата для сравнения
    if d1 > d2 then
      lalala;
  end;

procedure TForm1.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);
  begin
    ProgressBar2.Position := AWorkCount;
  end;

procedure TForm1.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: int64);
  begin
    ProgressBar2.Max := AWorkCountMax;
  end;


procedure TForm1.IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  begin
    ProgressBar2.Position := 0;
  end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  begin
    if Key = 13 then
      begin
      Key := 0;
      if StringGrid1.Row = StringGrid1.RowCount - 1 then
        begin
        StringGrid1.RowCount := StringGrid1.RowCount + 1;
        StringGrid1.Row      := StringGrid1.Row + 1;
        end
      else
        StringGrid1.Row := StringGrid1.Row + 1;
      end;

  end;

end.
