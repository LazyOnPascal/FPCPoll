{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit FPCPoll;

{$warn 5023 off : no warning about unused units}
interface

uses
  PollTypes, PollPart, PollList, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('FPCPoll', @Register);
end.
