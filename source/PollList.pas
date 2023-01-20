unit PollList;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  PollPart,
  BaseUnix;

type

  { TPollList }

  TPollList = class(TFPList)
  private
    mem: ppollfd;
  private
    function Get(Index: integer): TPollPart;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function Add(aPollPart: TPollPart): integer;
    procedure BuildAndCall(aTimeOut: int64);
  public
    property Items[Index: integer]: TPollPart read Get; default;
  end;

implementation

{ TPollList }

function TPollList.Get(Index: integer): TPollPart;
begin
  Result := TPollPart(inherited get(Index));
end;

constructor TPollList.Create;
begin
  mem := nil;
end;

destructor TPollList.Destroy;
var
  I: integer;
begin
  for I := 0 to Count - 1 do
  begin
    if assigned(Items[I]) then Items[I].Free;
  end;
  inherited Destroy;
end;

function TPollList.Add(aPollPart: TPollPart): integer;
begin
  Result := inherited Add(aPollPart);
end;

procedure TPollList.BuildAndCall(aTimeOut: int64);
var
  I: integer;
  eventsCount: longint;
begin
  I := sizeof(pollfd) * Count;
  //сколько нам нужно памяти под структуру
  if (mem = nil) then           //выделяем в первый раз
  begin
    mem := GetMem(I);
  end
  else if not (MemSize(mem) = I) then   //перевыделяем
  begin
    FreeMem(mem);
    mem := GetMem(I);
  end;
  FillChar(mem, I, 0);           //обнуляем

  for I := 0 to Count - 1 do   //заполняем
  begin
    Items[I].BuildMem(@mem[I]);
  end;

  eventsCount := FpPoll(mem, Count, aTimeOut);  //вызываем

  if eventsCount = 0 then exit;

  for I := 0 to Count - 1 do                    //обрабатываем события
  begin
    if not (mem[I].revents = 0) then
    begin
      Items[I].Decode(mem[I].revents);          //декодируем
      Items[I].CallBack;                        //вызываем обработчики
      Dec(eventsCount);
      if (eventsCount = 0) then break;
    end;
  end;

end;



end.
