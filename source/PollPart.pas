unit PollPart;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  BaseUnix,
  PollTypes;

type

  { TPollPart }

  TPollPart = class
  private
    FSock: cint;
    FNeedRead: boolean; //POLLIN
    FNeedWrite: boolean; //POLLOUT

    FIsWritable: boolean; //POLLOUT
    FIsReadable: boolean; //POLLIN
    FIsClosed: boolean;   //POLLHUP
    FIsError: boolean;    //POLLERR
    FIsUrgent: boolean;  //POLLPRI
    FIsInvalid: boolean;  //POLLNVAL

    FOnWritable: TOnWritable;
    FOnReadable: TOnReadable;
    FOnClosed: TOnClosed;
    FOnError: TOnError;
    FOnUrgent: TOnUrgent;
    FOnInvalid: TOnInvalid;

  public
    constructor Create(aSock: cint;
      aOnWritable: TOnWritable = nil; aOnReadable: TOnReadable = nil;
      aOnClosed: TOnClosed = nil; aOnError: TOnError = nil;
      aOnUrgent: TOnUrgent = nil; aOnInvalid: TOnInvalid = nil);
    destructor Destroy; override;

  public
    procedure Decode(aAnswer: smallint);
    procedure CallBack;
    procedure BuildMem(aPointer: pointer);

  public

    property Read: boolean read FIsReadable write FNeedRead;
    property Write: boolean read FIsWritable write FNeedWrite;
    property Closed: boolean read FIsClosed;
    property Error: boolean read FIsError;
    property Urgent: boolean read FIsUrgent;
    property Invalid: boolean read FIsInvalid;

    property OnWritable: TOnWritable read FOnWritable write FOnWritable;
    property OnReadable: TOnReadable read FOnReadable write FOnReadable;
    property OnClosed: TOnClosed read FOnClosed write FOnClosed;
    property OnError: TOnError read FOnError write FOnError;
    property OnUrgent: TOnUrgent read FOnUrgent write FOnUrgent;
    property OnInvalid: TOnInvalid read FOnInvalid write FOnInvalid;

  end;

implementation

{ TChatPoll }

constructor TPollPart.Create(aSock: cint;
      aOnWritable: TOnWritable = nil; aOnReadable: TOnReadable = nil;
      aOnClosed: TOnClosed = nil; aOnError: TOnError = nil;
      aOnUrgent: TOnUrgent = nil; aOnInvalid: TOnInvalid = nil);
begin
  FSock := aSock;
  FNeedRead := false;
  FNeedWrite := false;

  FIsWritable := False;
  FIsReadable := False;
  FIsClosed := False;
  FIsError := False;
  FIsUrgent := False;
  FIsInvalid := False;

  FOnWritable := aOnWritable;
  FOnReadable := aOnReadable;
  FOnClosed := aOnClosed;
  FOnError := aOnError;
  FOnUrgent := aOnUrgent;
  FOnInvalid := aOnInvalid;
end;

destructor TPollPart.Destroy;
begin
  inherited Destroy;
end;

procedure TPollPart.Decode(aAnswer: smallint);
begin
  FIsWritable := ((aAnswer and POLLOUT) = POLLOUT);
  FIsReadable := ((aAnswer and POLLIN) = POLLIN);
  FIsClosed := ((aAnswer and POLLHUP) = POLLHUP);
  FIsError := ((aAnswer and POLLERR) = POLLERR);
  FIsUrgent := ((aAnswer and POLLPRI) = POLLPRI);
  FIsInvalid := ((aAnswer and POLLNVAL) = POLLNVAL);
end;

procedure TPollPart.CallBack;
begin
  if not (FOnWritable = nil) and FIsWritable then FOnWritable;
  if not (FOnReadable = nil) and FIsReadable then FOnReadable;
  if not (FOnClosed = nil) and FIsClosed then FOnClosed;
  if not (FOnError = nil) and FIsError then FOnError;
  if not (FOnUrgent = nil) and FIsUrgent then FOnUrgent;
  if not (FOnInvalid = nil) and FIsInvalid then FOnInvalid;
end;

procedure TPollPart.BuildMem(aPointer: pointer);
var
  pfd: ppollfd;
begin
  pfd := aPointer;
  pfd^.fd := FSock;
  if FNeedRead then pfd^.events := POLLIN;
  if FNeedWrite then pfd^.events := pfd^.events or POLLOUT;
end;

end.
