unit FrameworkConnotationInfo;

interface
 uses FARG_Framework_Chunk, classes, graphics, sysutils, ibutils;

type        



TConnotationInfo = class
                {this class can be like a strategy, in the sense of not returning anything
                if it's not a chunk, and returning the right stuff if it is}
                Connotation:TConnotation;
                Chunk:TChunk;
                Relation:TRelation;                   
                ChunkView: TBitmap;
                WidthInLevel: Array[1..1000] of integer;
                                   
                Constructor create; overload;
                constructor create (R:TRelation); overload;
                constructor create (C:TChunk); overload;
                Function GetWidth(C:TConnotation):integer;
                function GetChunkDepth(Chunk:TChunk):integer; overload;
                function GetChunkDepth(Chunk: TRelation): integer; overload;
                function GetChunkWidth(Chunk: TChunk): integer;
                function GetChunkWidthInLevelX(X:Integer): integer;

                Function ContainsConnotation(Chunk: TChunk; C:TConnotation):boolean; overload;
                Function ContainsConnotation(Chunk: TRelation; C:TConnotation):boolean; overload;
end;


implementation


{ TChunkInfo }
{This class can enable clients to get info on chunks without having to
change the TChunk interface, which can in this way be cleaned up

Also, subclasses might need to extend the interface here for specific
applications running on top of the framework, if that was done in the
TConnotation class structure, things might lose generality

This class structure does seems to be more loosely coupled

Why isn't it merely a set of TRelations?  Because some of the methods here
just feel better placed as method calls than TRelations creating new structures
that do not necessarily affect memory structures (such as the size of the
strings of connotations)}

function TConnotationInfo.ContainsConnotation(Chunk: TChunk; C: TConnotation): boolean;
var x: integer; res:boolean; Caux:TConnotation; CInfo:TConnotationInfo;
begin
    res:=false;
    CInfo:=TConnotationInfo.create;
    if Chunk.Elements.indexof(C)>=0 then
        res:=true
        else begin
          for x := 0 to chunk.Elements.Count - 1 do
            Caux:=Chunk.Elements.Items[x];
            if (Caux.InheritsFrom(TChunk)) then
              res:= Cinfo.ContainsConnotation(Tchunk(Caux), C)
              else if (Caux.InheritsFrom(TRelation)) then
              res:= CInfo.ContainsConnotation(TRelation(Caux), C)
        end;
    result:=res;
end;

function TConnotationInfo.ContainsConnotation(Chunk: TRelation;
  C: TConnotation): boolean;
var x: integer; res:boolean; Caux:TConnotation; CInfo:TConnotationInfo;
begin
    res:=false;
    CInfo:=TConnotationInfo.create;
    if Chunk.Elements.indexof(C)>=0 then
        res:=true
        else begin
          for x := 0 to chunk.Elements.Count - 1 do
          begin
            Caux:=Chunk.Elements.Items[x];
            if (Caux.InheritsFrom(TChunk)) then
              res:= Cinfo.ContainsConnotation(Tchunk(Caux), C)
              else if (Caux.InheritsFrom(TRelation)) then
              res:= CInfo.ContainsConnotation(TRelation(Caux), C)
          end;
        end;
    result:=res;
end;

constructor TConnotationInfo.create;
begin

end;

constructor TConnotationInfo.create(R: TRelation);
begin
     Relation:=R;
end;

constructor TConnotationInfo.create(C: TChunk);
begin
    Chunk:=C;
    //CType:=C.classtype;
end;

Function TConnotationInfo.GetWidth(C:TConnotation):integer;
var ClassName:string;
    MyName: String;
begin
    ClassName:=C.ClassName;
    MyName:='change this to something meaningful';
    Result:=Max(strlen(pchar(Classname)), strlen(pchar(MyName)));
end;



function TConnotationInfo.GetChunkDepth(Chunk: TChunk): integer;
var Depth, maxDepth, subTreeDepth, I:integer;
    C: TConnotation; ChunkInfo: TConnotationInfo;
begin
  Depth:=1;
  maxDepth:=1;
  {needs to traverse the chunk tree to compute the maximum depth size}
  for I := 0 to Chunk.Elements.Count - 1 do
  begin
       C:=Chunk.Elements.items[i];
       if (C.inheritsFrom(TChunk)) then
       begin
         ChunkInfo:=TConnotationInfo.Create(TChunk(C));
         subTreeDepth:=ChunkInfo.GetChunkDepth(TChunk(C));
         Depth:=Depth+subTreeDepth;
         if Depth>MaxDepth then MaxDepth:=Depth;
         Depth:=Depth-subTreeDepth;
       end else if (C.InheritsFrom(TRelation)) then
                begin
                    ChunkInfo:=TConnotationInfo.Create(TChunk(C));
                    subTreeDepth:=ChunkInfo.GetChunkDepth(TRelation(C));
                    Depth:=Depth+subTreeDepth;
                    if Depth>MaxDepth then MaxDepth:=Depth;
                    Depth:=Depth-subTreeDepth;
                end;
  end;
  result:=maxDepth;
end;

function TConnotationInfo.GetChunkDepth(Chunk: TRelation): integer;
var Depth, maxDepth, subTreeDepth, I:integer;
    C: TConnotation; ChunkInfo: TConnotationInfo;
begin
  Depth:=0;
  maxDepth:=0;
  {needs to traverse the chunk tree to compute the maximum depth size}
  for I := 0 to Chunk.Elements.Count - 1 do
  begin
       C:=Chunk.Elements.items[i];
       if (C.inheritsFrom(TChunk)) then
       begin
         ChunkInfo:=TConnotationInfo.Create(TChunk(C));
         subTreeDepth:=ChunkInfo.GetChunkDepth(TChunk(C));
         Depth:=Depth+subTreeDepth;
         if Depth>MaxDepth then MaxDepth:=Depth;
         Depth:=Depth-subTreeDepth;
       end else if (C.InheritsFrom(TRelation)) then
                begin
                    ChunkInfo:=TConnotationInfo.Create(TChunk(C));
                    subTreeDepth:=ChunkInfo.GetChunkDepth(TRelation(C));
                    Depth:=Depth+subTreeDepth;
                    if Depth>MaxDepth then MaxDepth:=Depth;
                    Depth:=Depth-subTreeDepth;
                end;
  end;
  result:=maxDepth;
end;

function TConnotationInfo.GetChunkWidth(Chunk: TChunk): integer;
var Depth, maxDepth, subTreeDepth, I:integer;
    C: TConnotation; ChunkInfo: TConnotationInfo;
begin
  Depth:=1;
  maxDepth:=1;
  {needs to traverse the chunk tree to compute the maximum depth size}
  for I := 0 to Chunk.Elements.Count - 1 do
  begin
       C:=Chunk.Elements.items[i];
       if (C.Classtype=TChunk) then
       begin
         ChunkInfo:=TConnotationInfo.Create(TChunk(C));
         subTreeDepth:=ChunkInfo.GetChunkDepth(TChunk(C));

         Depth:=Depth+subTreeDepth;
         WidthInLevel[Depth]:=WidthInLevel[Depth]+GetWidth(TChunk(C));
         if Depth>MaxDepth then MaxDepth:=Depth;
         Depth:=Depth-subTreeDepth;
       end;
  end;
  result:=maxDepth;
end;

function TConnotationInfo.GetChunkWidthInLevelX(X: Integer): integer;
begin
    result:=WidthInLevel[x];
end;


end.