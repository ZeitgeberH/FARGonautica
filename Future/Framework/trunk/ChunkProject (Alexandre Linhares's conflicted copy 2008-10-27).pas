unit ChunkProject;

interface

uses                 
  FARG_AND_NumboSlipnet, FARG_Framework_Similarity, Numboconnotations, ExternalMemoryClass, FARG_Framework_Chunk,  NumboViewer,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TForm1 = class(TForm)     
    TabControl1: TTabControl;                 
    Button1: TButton;                  
    Memo1: TMemo;
    Button2: TButton;

    procedure Button1Click(Sender: TObject);
    Procedure Look_at_target;
    Procedure Look_at_Brick;
    procedure FormCreate(Sender: TObject);
    procedure InitChunksForTest;
    procedure SlipnetExperiment1;
    Function PrintConnotationString(C:TConnotation):String;
    Procedure PrintProposedRelatedItems(R:TRelation);
    procedure Button2Click(Sender: TObject);

    public
    CH1: TChunk;

    procedure createNode(x:integer); overload;
    Procedure CreateNode(x,y:integer; kind:tclass); overload;

    
  end;

var Form1: TForm1;
    Brick: Tbrick;
    Target: TTarget;


implementation
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var x:integer;
s:string;
begin
    ExtMem:=TExt_mem.Create;
    Target:=TTarget.Create;
    STM_Content:= TList.Create;
    Randomize;
    RandSeed:=1528670047;   {for 3 times it creates 5x2 and destroys it!}
{    Randomize; }
    x:=RandSeed;

    str(x,S);
    Memo1.Lines.add(s);
end;



procedure TForm1.Look_at_Brick;
var s:string;
begin
    Brick:=TBrick.Create;
    Brick.BottomUpPropose;

    if (Brick.Relevance=1) and (STM_Content.IndexOf(Brick)<0) then
    begin
      with Brick do
      str(GetValue,s);     {Duplicate code (look below)}
      memo1.Lines.Add(Brick.ClassName+' is '+s);
      STM_Content.Add(Brick);
    end;
end;



procedure TForm1.Look_at_target;
var s:string;
begin
    {loads target into Target/TNumber/tProperty}
    {how do you do this?}
    {external memory has an int; bottomupscout of target must grab it and fill all needed info}
    Target.BottomUpPropose;

    if (STM_Content.IndexOf(Target)<0) then    
    begin
      {get full name?}
      with target do
      str(GetValue,s);     {Duplicate code (look above)}
      memo1.Lines.Add(Target.ClassName+' is '+s);
      STM_Content.Add(target);
    end;
end;




{create mini-slipnet for 2 quick and dirty experiments}

{experiment 1: 49=7*7}
{Nodes:
49
7*7=49
5+2=7
1
2
3
5
7

Here we have a client method, which will probably go into the FARG_Mediator, then NUMBO_Mediator:  Start_Slipnet

1. Create TNumber nodes
2. Create two TChunks (with operation nodes)
3. Link them up:
  3.1 each number that goes into one of the operations is linked to the chunks (5,2,7,49 & 2 chunks)
  3.2 link close numbers (following Numbo's convention)

4. Refactor and Use The Previous Implementation of the Slipnet, ANIMAL!!!
}

Procedure TForm1.SlipnetExperiment1;
begin
   CreateNode(1);
   CreateNode(2);
   CreateNode(3);
   CreateNode(5);
   CreateNode(7);
   CreateNode(49);

   CreateNode(7,7,TMultiplication);
   CreateNode(2,5,TMultiplication); {CHANGE TO Addition}

   {Now create links between close numbers}


   {Now create links between numbers and decompositions}

end;

procedure TForm1.createNode(x: integer);
begin

end;

procedure {BonnieAndClydeMediator}Preparations;
begin

end;

Procedure {BonnieAndClydeMediator}Include(List:TList; Num:integer);
var N:TNumber;
begin
    N:=TNumber.Create;
    N.Value:=Num;
    List.Add(N);
end;


function {BonnieAndClydeMediator}LoadBonnieAndClydeSet1:TList;
var List1:TList;
    x: integer;
begin
  List1:=TList.Create;

  {generate 10 ones}
  for x := 0 to 4 do
    Include(List1, 1);

  {generate 2 zeros}
  for x := 0 to 1 do
    Include(List1,0);

  for x := 0 to 4 do
    Include(List1, 1);

  result:=List1;
end;



function {BonnieAndClydeMediator}LoadBonnieAndClydeSet2:TList;
var List1:TList;
begin
  List1:=TList.Create;
  Include(List1, 222);
  Include(List1, 99);
  Include(List1, 132);
  Include(List1, 1);
  Include(List1, 128);
  Include(List1, 76);
  Include(List1, 4);
  Include(List1, 54);
  Include(List1, 68);
  Include(List1, 302);      {does not find outliers far from the edge, like 1 and 3333}
  Include(List1, 298);      {another statistical formula, and weights?}
  Include(List1, 305);     {consult matematica aplicada} {compute improvement of each approach, maximize improvement?}
  result:=List1;
end;

procedure TForm1.Button2Click(Sender: TObject); {Bonnie and Clyde Test}
Var Similarity: TSimilarity;
    L:Tlist;
    Xc, Yc: TNumber;
    S:String;
    I: Integer;

begin
    Preparations;
    Similarity:=TSimilarity.Create;
    L:=LoadBonnieAndClydeSet2;

    for I := 0 to L.Count - 1 do
    begin
      Xc:=L.Items[i];
      Similarity.ConnotationSet.Add(Xc);
    end;

    Similarity.MeasureSetSimilarities;


    Xc:=Similarity.ConnotationSet.Items[Similarity.MostOutlierX];
    Yc:=Similarity.ConnotationSet.Items[Similarity.MostOutlierY];
    Str(Xc.GetValue, S);
    Memo1.Lines.Add(S);
    Str(Yc.GetValue, S);
    Memo1.Lines.Add(S);
end;

procedure TForm1.createNode(x, y: integer; kind: tclass);
begin

end;


{
Slipnet Experiment 2: 49=(50-1)=((5*10)-1)=((5*(7+3)-1)
 Here we will have to get the system to automatically decrement
 Nodes: 50(similar to)49
 7+3
 5*10
 the -1 has to be computed, dude!!!!!
 }


Function TForm1.PrintConnotationString(C:TConnotation):String;
var L2:TList; S1: TStringName;S2:TString;
begin
    L2:=TList.Create;
    L2.Add(C);
    S1:=TStringName.Create;
    S1.ComputeRelation(L2);
    L2:=S1.NewElements;
    S2:=L2.items[0];
    result:=S2.GetValue;
end;

procedure TForm1.PrintProposedRelatedItems(R: TRelation);
var C:TConnotation;
begin
    C:=R.Elements.Items[0];
    Memo1.Lines.Add(PrintConnotationString(C));
    C:=R.Elements.Items[1];
    Memo1.Lines.Add(PrintConnotationString(C));

end;

procedure TForm1.InitChunksForTest;
var C, C2:TConnotation; L:Tlist; S:String;  ChunkInfo: TChunkInfo;
begin
    L:=TList.Create;

    C:= TBrick.Create;
    TBrick(C).Value:=5;
    L.add(c);
    C:=TBrick.Create;
    TBrick(C).Value:=2;
    L.add(c);
    C:= TMultiplication.create;
    TMultiplication(C).Elements:=L;
    TMultiplication(C).ComputeRelation(L);
    memo1.Lines.add(PrintConnotationString(C));

    {
    str (TChunk(C).Depth, S);
    Memo1.Lines.Add('Depth of Chunk='+S );
    }

    ChunkInfo:=TChunkInfo.create(TChunk(C));
    str (ChunkInfo.GetChunkDepth(TChunk(C)), S);
    Memo1.Lines.Add('Depth of Chunk='+S );

    L:=TList.Create;
    L.add(c);
    C2:=TChunk.Create;
    TChunk(C2).ChunkRelation(TMultiplication(C));

    memo1.Lines.add(PrintConnotationString(C2));

    {
    str (TChunk(C2).Depth, S);
    Memo1.Lines.Add('Depth of Chunk='+S );
    }
    ChunkInfo:=TChunkInfo.create(TChunk(C2));
    str (ChunkInfo.GetChunkDepth(TChunk(C2)), S);
    Memo1.Lines.Add('Depth of Chunk='+S );

    CH1:=TChunk(C2);
end;                                  

procedure TForm1.Button1Click(Sender: TObject);
var s:string;
    R: TRelation;
    C, C2, C3: TConnotation;
    Chunk:TChunk;
    I, I2: Integer;
    Sameness: TSimilarity;
    ChunkInfo: TChunkInfo;


begin
    {loads bricks and target and displays them}
    Look_at_Target;
    while extmem.FreeBricks>0 do
        Look_at_Brick;

    {InitChunksForTest;}

    {just checking that there are no duplicate bricks by any chance}
    str (STM_Content.Count, s);
    memo1.lines.Add('elements in STM:'+s);


    while (STM_Content.Count>2) do
    begin
      {now testing TMultiplication.GetBottomUpConnotationTypes}
      memo1.Lines.Add('-----------------------------------------------' );
      R:=TMultiplication.Create;
      R.BottomUpPropose;   {we are creating a relation, not a chunk}
      PrintProposedRelatedItems(R);
      {str (R.Elements.Count, s);
      memo1.lines.Add('elements found for use:'+s);}

      {now we should find a way to print out chunks here}
      I:=0;
      While (I<STM_Content.Count) do
      begin
           C:=STM_Content.items[I];
           if (C.inheritsfrom(TNumber)) then
              Memo1.Lines.Add(PrintConnotationString(C))
           else if (C.ClassType=TChunk) then {duplicate code 1 again}
           begin
              Memo1.Lines.Add(PrintConnotationString(C));

    ChunkInfo:=TChunkInfo.create(TChunk(C));
    str (ChunkInfo.GetChunkDepth(TChunk(C)), S);
    Memo1.Lines.Add('Depth of Chunk='+S );

            {  str (TChunk(C).Depth, S);
              Memo1.Lines.Add('Depth of Chunk='+S );}

              {displays classes involved in chunk, created now and previously}
              Chunk:=TChunk(C);
              s:='';
              for i2 := 0 to Chunk.Elements.Count - 1 do
              begin
                C2:=Chunk.Elements.Items[i2];
                s:=s+C2.ClassName+' ';
              end;
              memo1.Lines.Add(S);

              {Chunk:=TChunk(CH1);
              s:='';
              for i2 := 0 to Chunk.Elements.Count - 1 do
              begin
                C2:=Chunk.Elements.Items[i2];
                s:=s+C2.ClassName+' ';
              end;
              memo1.Lines.Add(S);}

              {structural similarity tests}
              (*Sameness:=Tset.Create;
              if (Sameness.Compare(CH1, TChunk(C))) then
                memo1.Lines.Add('O Set funciona');

              Sameness:=TTemplates.Create;
              if (Sameness.Compare(CH1, TChunk(C))) then
                memo1.Lines.Add('A template funciona');

              Sameness:=TChunks.Create;
              if (Sameness.Compare(CH1, TChunk(C))) then
              begin
                memo1.Lines.Add('OMG!!! It is alive!!!!');
                beep;
                TChunk(C).Destroyer;
              end; *)

           end;

           (*
           {now we Top-Down search for a Number 15 out there}
           C2:=TNumber.Create;
           TNumber(C2).Value:= 7;
           C3:=C.TopDownSeekFor(C2); {ooops... quebrou...}
           if (C3<>nil) then
           begin
              Memo1.Lines.Add(PrintConnotationString(C3));
              str (TNumber(C3).GetValue, s);
              memo1.lines.Add(C3.ClassName+' is actually found with a value of '+s);
           end;
           *)
           i:=i+1;
      end;
    end;
end;

end.