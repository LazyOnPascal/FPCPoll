unit PollTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type

  TOnWritable = procedure of object;
  TOnReadable = procedure of object;
  TOnClosed = procedure of object;
  TOnError = procedure of object;
  TOnUrgent = procedure of object;
  TOnInvalid = procedure of object;

implementation

end.
