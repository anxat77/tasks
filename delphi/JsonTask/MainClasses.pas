unit MainClasses;

interface

uses
  System.Generics.Collections;


type
  TAuto = class(TObject)
  private
    FBrand: string;
    FColor: string;
    FID: Integer;
    FModel: string;
    FNumber: string;
  public
    property Brand: string read FBrand write FBrand;
    property Color: string read FColor write FColor;
    property ID: Integer read FID write FID;
    property Model: string read FModel write FModel;
    property Number: string read FNumber write FNumber;
  end;

  TDriver = class(TObject)
  private
    FID: Integer;
    FName: string;
    FPhone: string;
  public
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Phone: string read FPhone write FPhone;
  end;

  TTrip = class(TObject)
  private
    FAutoID: Integer;
    FDriverID: Integer;
    FStartTime: TDateTime;
  public
    property AutoID: Integer read FAutoID write FAutoID;
    property DriverID: Integer read FDriverID write FDriverID;
    property StartTime: TDateTime read FStartTime write FStartTime;
  end;


  TDriverList = class(TObjectList<TDriver>)
  public
    function LoadFromJSON(AFileName: string): Boolean;
    function SaveToJSON(AFileName: string): Boolean;
  end;

  TAutoList =class(TObjectList<TAuto>)
  public
    function LoadFromJSON(AFileName: string): Boolean;
    function SaveToJSON(AFileName: string): Boolean;
  end;

  TTripList =class(TObjectList<TTrip>)
  public
    function LoadFromJSON(AFileName: string): Boolean;
    function SaveToJSON(AFileName: string): Boolean;
  end;


implementation

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  System.JSON;



{ TDriverList }

function TDriverList.LoadFromJSON(AFileName: string): Boolean;
var
  Jo: TJSONObject;
  JDriver: TJSONObject;
  Ja: TJSONArray;
  JSONValue: TJSONValue;

  I: Integer;

  ID: Integer;
  Name: string;
  Phone: string;
begin
  Result := False;

  ID := -1;
  Name := '';
  Phone := '';

  // Clear before read
  Self.Clear;



  if FileExists(AFileName) then
  begin

    try
      Jo := TJSONObject.ParseJSONValue(TFile.ReadAllText(AFileName)) as TJSONObject;
    except
      // insurance
    end;

    if Assigned(Jo) then
    begin
      try
        try

          JSONValue := Jo.GetValue('Driver');
          if Assigned(JSONValue) and
             (JSONValue is TJSONArray) then
          begin
            Ja := JSONValue as TJSONArray;

            for I := 0 to Ja.Count - 1 do
            begin
              JDriver := Ja.Items[I] as TJSONObject;

              if Assigned(JDriver) then
              begin

                JSONValue := JDriver.GetValue('ID');
                if Assigned(JSONValue) then
                  ID := StrToIntDef(JSONValue.Value, -1);

                JSONValue := JDriver.GetValue('Name');
                if Assigned(JSONValue) then
                  Name := JSONValue.Value;

                JSONValue := JDriver.GetValue('Phone');
                if Assigned(JSONValue) then
                  Phone := JSONValue.Value;

                if ID <> -1 then
                begin
                  Self.Add(TDriver.Create);
                  Self.Last.ID := ID;
                  Self.Last.Name := Name;
                  Self.Last.Phone := Phone;
                end;

              end; // if Assigned(JDriver) then
            end;  // for I := 0 to Ja.Count - 1 do
            Result := True;
          end;  // if Assigned(JSONValue) and (JSONValue is TJSONArray)

        except
          // if missed some mistake
        end;
      finally
        Jo.Free;
      end;

    end;  // if Assigned(Jo) then
  end;  // if FileExists(FileName)

end;

function TDriverList.SaveToJSON(AFileName: string): Boolean;
var
  I: Integer;

  Jo: TJSONObject;
  JDriver: TJSONObject;
  Ja: TJSONArray;

begin
  Result := False;

  Jo := TJSONObject.Create;
  Jo.AddPair('Driver', TJSONArray.Create);
  Ja := Jo.GetValue('Driver') as TJSONArray;

  try
    try
      for I := 0 to Self.Count - 1 do
      begin
        Ja.AddElement(TJSONObject.Create);

        JDriver := Ja.Items[pred(Ja.Count)] as TJSONObject;

        if Self[I].ID > 0 then
        begin
          JDriver.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(Self[I].ID)));
          if Trim(Self[I].Name) <> '' then
            JDriver.AddPair(TJSONPair.Create('Name', TJSONString.Create(Trim(Self[I].Name))));
          if Trim(Self[I].Phone) <> '' then
            JDriver.AddPair(TJSONPair.Create('Phone', TJSONString.Create(Trim(Self[I].Phone))));
        end;

      end;


    try
      TFile.WriteAllText(AFileName, Jo.ToString);
    except
      // if incorrect FileName
    end;

      Result := True;
    except
    end;
  finally
    Jo.Free;
  end;

end;

{ TAutoList }

function TAutoList.LoadFromJSON(AFileName: string): Boolean;
var
  Jo: TJSONObject;
  JAuto: TJSONObject;
  Ja: TJSONArray;
  JSONValue: TJSONValue;

  I: Integer;

  ID: Integer;
  Brand: string;
  Model: string;
  Color: string;
  Number: string;
begin
  Result := False;

  ID := -1;
  Brand := '';
  Model := '';
  Color := '';
  Number := '';

  // Clear before read
  Self.Clear;


  if FileExists(AFileName) then
  begin

    try
      Jo := TJSONObject.ParseJSONValue(TFile.ReadAllText(AFileName)) as TJSONObject;
    except
      // insurance
    end;

    if Assigned(Jo) then
    begin
      try
        try
          JSONValue := Jo.GetValue('Auto');
          if Assigned(JSONValue) and
             (JSONValue is TJSONArray) then
          begin
            Ja := JSONValue as TJSONArray;

            for I := 0 to Ja.Count - 1 do
            begin
              JAuto := Ja.Items[I] as TJSONObject;

              if Assigned(JAuto) then
              begin

                JSONValue := JAuto.GetValue('ID');
                if Assigned(JSONValue) then
                  ID := StrToIntDef(JSONValue.Value, -1);

                JSONValue := JAuto.GetValue('Brand');
                if Assigned(JSONValue) then
                  Brand := JSONValue.Value;

                JSONValue := JAuto.GetValue('Model');
                if Assigned(JSONValue) then
                  Model := JSONValue.Value;

                JSONValue := JAuto.GetValue('Color');
                if Assigned(JSONValue) then
                  Color := JSONValue.Value;

                JSONValue := JAuto.GetValue('Number');
                if Assigned(JSONValue) then
                  Number := JSONValue.Value;

                if ID <> -1 then
                begin
                  Self.Add(TAuto.Create);
                  Self.Last.ID := ID;
                  Self.Last.Brand := Brand;
                  Self.Last.Model := Model;
                  Self.Last.Color := Color;
                  Self.Last.Number := Number;
                end;


              end; // if Assigned(JAuto) then
            end;  // for I := 0 to Ja.Count - 1 do
            Result := True;
          end;  // if Assigned(JSONValue) and (JSONValue is TJSONArray)

        except
          // if missed some mistake
        end;
      finally
        Jo.Free;
      end;

    end;  // if Assigned(Jo) then
  end;  // if FileExists(FileName)

end;

function TAutoList.SaveToJSON(AFileName: string): Boolean;
var
  I: Integer;

  Jo: TJSONObject;
  JAuto: TJSONObject;
  Ja: TJSONArray;

begin
  Result := False;

  Jo := TJSONObject.Create;
  Jo.AddPair('Auto', TJSONArray.Create);
  Ja := Jo.GetValue('Auto') as TJSONArray;

  try
    try
      for I := 0 to Self.Count - 1 do
      begin
        Ja.AddElement(TJSONObject.Create);
        JAuto := Ja.Items[pred(Ja.Count)] as TJSONObject;

        if Self[I].ID > 0 then
        begin
          JAuto.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(Self[I].ID)));
          if Trim(Self[I].Brand) <> '' then
            JAuto.AddPair(TJSONPair.Create('Brand', TJSONString.Create(Trim(Self[I].Brand))));
          if Trim(Self[I].Model) <> '' then
            JAuto.AddPair(TJSONPair.Create('Model', TJSONString.Create(Trim(Self[I].Model))));
          if Trim(Self[I].Color) <> '' then
            JAuto.AddPair(TJSONPair.Create('Color', TJSONString.Create(Trim(Self[I].Color))));
          if Trim(Self[I].Number) <> '' then
            JAuto.AddPair(TJSONPair.Create('Number', TJSONString.Create(Trim(Self[I].Number))));
        end;

      end;

      try
        TFile.WriteAllText(AFileName, Jo.ToString);
      except
        // if incorrect FileName
      end;

      Result := True;
    except
    end;

  finally
    Jo.Free;
  end;

end;

{ TTripList }

function TTripList.LoadFromJSON(AFileName: string): Boolean;
var
  Jo: TJSONObject;
  JTrip: TJSONObject;
  Ja: TJSONArray;
  JSONValue: TJSONValue;

  I: Integer;

  AutoID: Integer;
  DriverID: Integer;
  StartTime: TDateTime;

  AFormatSettings: TFormatSettings;
begin
  Result := False;

  AFormatSettings.DateSeparator := '-';
  AFormatSettings.TimeSeparator := ':';
  AFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  AFormatSettings.LongDateFormat := 'yyyy-mm-dd';
  AFormatSettings.LongTimeFormat := 'hh:nn:ss';


  AutoID := -1;
  DriverID := -1;
  StartTime := 0;

  // Clear before read
  Self.Clear;



  if FileExists(AFileName) then
  begin

    try
      Jo := TJSONObject.ParseJSONValue(TFile.ReadAllText(AFileName)) as TJSONObject;
    except
      // insurance
    end;

    if Assigned(Jo) then
    begin
      try
        try

          JSONValue := Jo.GetValue('Trip');
          if Assigned(JSONValue) and
             (JSONValue is TJSONArray) then
          begin
            Ja := JSONValue as TJSONArray;

            for I := 0 to Ja.Count - 1 do
            begin
              JTrip := Ja.Items[I] as TJSONObject;

              if Assigned(JTrip) then
              begin

                JSONValue := JTrip.GetValue('AutoID');
                if Assigned(JSONValue) then
                  AutoID := StrToIntDef(JSONValue.Value, -1);

                JSONValue := JTrip.GetValue('DriverID');
                if Assigned(JSONValue) then
                  DriverID := StrToIntDef(JSONValue.Value, -1);

                JSONValue := JTrip.GetValue('StartTime');
                if Assigned(JSONValue) then
                  StartTime := StrToDateTimeDef(JSONValue.Value, 0, AFormatSettings);


                if (AutoID <> -1) and (DriverID <> -1) and (StartTime <> 0) then
                begin
                  Self.Add(TTrip.Create);
                  Self.Last.AutoID := AutoID;
                  Self.Last.DriverID := DriverID;
                  Self.Last.StartTime := StartTime;
                end;

              end; // if Assigned(JDriver) then
            end;  // for I := 0 to Ja.Count - 1 do
            Result := True;
          end;  // if Assigned(JSONValue) and (JSONValue is TJSONArray)

        except
          // if missed some mistake
        end;
      finally
        Jo.Free;
      end;

    end;  // if Assigned(Jo) then
  end;  // if FileExists(FileName)

end;

function TTripList.SaveToJSON(AFileName: string): Boolean;
var
  I: Integer;

  Jo: TJSONObject;
  JTrip: TJSONObject;
  Ja: TJSONArray;

  StartTimeStr: string;

begin
  Result := False;

  Jo := TJSONObject.Create;
  Jo.AddPair('Trip', TJSONArray.Create);
  Ja := Jo.GetValue('Trip') as TJSONArray;

  try
    try
      for I := 0 to Self.Count - 1 do
      begin
        Ja.AddElement(TJSONObject.Create);
        JTrip := Ja.Items[pred(Ja.Count)] as TJSONObject;

        if (Self[I].AutoID > 0) and
           (Self[I].DriverID > 0) and
           (Self[I].StartTime <> 0) then
        begin
          JTrip.AddPair(TJSONPair.Create('AutoID', TJSONNumber.Create(Self[I].AutoID)));
          JTrip.AddPair(TJSONPair.Create('DriverID', TJSONNumber.Create(Self[I].DriverID)));

          DateTimeToString(StartTimeStr, 'yyyy-mm-dd hh:nn:ss', Self[I].StartTime);

          JTrip.AddPair(TJSONPair.Create('StartTime', TJSONString.Create(StartTimeStr)));
        end;

      end;

      try
        TFile.WriteAllText(AFileName, Jo.ToString);
      except
        // if incorrect FileName
      end;

      Result := True;
    except
    end;

  finally
    Jo.Free;
  end;

end;

end.