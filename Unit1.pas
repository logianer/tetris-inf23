unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure IdleHandler(Sender: TObject; var Done: boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type TGrid = array[0..7, 0..12] of integer;

CONST
  FPS_CAP = trunc(1000 / 25);
  COLORS: array [0 .. 6] of integer = (clMenu, $EF1111, $EFFE13, $00FF00, $00FFFF,
    $0000FF, $FF00FF);
  PIECES: array [1 .. 3] of array [1 .. 4] of array [1 .. 2] of integer =
    (((0, 0), (1, 0), (1, 1), (1, 2)), ((0, 0), (1, 0), (0, 1), (1, 1)),
    ((0, 0), (0, 1), (0, 2), (0, 3)));

var
  GAME_INIT: boolean;
  GAME_TICK: LongInt;
  DELTA_TIME: integer;
  COLOR_I: integer;
  GAME_GRID: TGrid;
  PIECE_GRID: TGrid;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawGrid(c: TCanvas; form: TForm);
var
  I, J, size, size_x, size_y: integer;
begin
  size := 35;
  size_x := 8;
  size_y := 13;
  c.brush.style := bsSolid;
  c.brush.color := clMenu;
  c.pen.style := psClear;
  c.rectangle(0, 0, form.width, form.height);


  c.brush.style := bsClear;
  c.pen.style := psSolid;

  for I := 0 to length(GAME_GRID)-1 do
  begin
    for J := 0 to length(GAME_GRID[0])-1 do
    begin
         c.brush.color := COLORS[GAME_GRID[I][J]];
    c.rectangle(15 + I * size, 15 + J * size, 15 + size + I * size,
      15 + size + J * size);
    end;
  end;
  Application.ProcessMessages;
end;

procedure SpawnPiece(piece_i: integer);
begin

end;

procedure Pause(ms: integer);
var
  current_time: LongInt;
  pause_time: LongInt;
begin
  current_time := GetTickCount;
  pause_time := current_time + ms;
  while current_time < (pause_time) do
  begin
    Application.ProcessMessages;
    current_time := GetTickCount;
  end;
end;

procedure GameLoop;
var
  time_index: LongInt;
begin
  inc(GAME_TICK);
  time_index := LongInt(GetTickCount);

  DrawGrid(Form1.Canvas, Form1);

  DELTA_TIME := LongInt(GetTickCount) - time_index;
  if DELTA_TIME < FPS_CAP then
    Pause(FPS_CAP - DELTA_TIME);
  Application.ProcessMessages;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    32:
      begin
        inc(COLOR_I);
        COLOR_I := COLOR_I mod length(COLORS)
      end;
  end;
end;

procedure TForm1.IdleHandler(Sender: TObject; var Done: boolean);
begin
  GameLoop;
  Done := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I, J: Integer;
begin
  GAME_TICK := 0;
  DELTA_TIME := 0;
  Application.OnIdle := IdleHandler;
  for I := 0 to 7 do
  begin
    for J := 0 to 12 do GAME_GRID[I][J] := 0
  end;

end;

end.
