import 'package:angular/core.dart';
import 'package:angular/src/common/directives.dart';
import 'package:boardytale_client/services/state_service.dart';


@Component(selector: "alerts",
directives: const[NgFor],
template: """
<div *ngFor="let alert of alerts" class='alert {{alert["type"]}}'>{{alert["text"]}}</div>
""",
host: const{
  "class":"alerts"
},
  styles: const["""
  :host{
    position: fixed;
    left:0;
    bottom:0;
    z-index: 2;
  }
  .alert{
    padding: 4px;
    margin: 3px;
    border-radius: 5px;
  }
  .error{
    background-color: #ff8888;
  }
  .warning{
    background-color: #ffdd88;
  }
  .note{
    background-color: #ffffff;
    color: blue;
  }
  """]
)
class AlertsComponent{
  final ChangeDetectorRef changeDetector;
  final StateService state;
  List<Map> alerts=[];

  AlertsComponent(this.changeDetector, this.state){
    state.onAlert.add((Map alert){
      if(alerts.length>4){
        alerts.removeAt(0);
      }
      alerts.add(alert);
      changeDetector.detectChanges();
    });
  }


}