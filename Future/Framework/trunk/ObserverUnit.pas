unit ObserverUnit;

interface

uses Classes,  Activation1Unit;

type

{IObserverActivation = Interface
                  procedure Update(A: Real);
           end;


ISubjectActivation =   Interface
                      procedure RegisterObserver(const Observer: TObject);
                      procedure UnRegisterObserver(const Observer: TObject);
                      procedure Notify (A: TActivation);
                end;

}

implementation

end.