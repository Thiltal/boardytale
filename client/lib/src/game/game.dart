import 'package:angular/core.dart';
import 'package:boardytale_client/src/services/state_service.dart';
import 'package:boardytale_client/src/world/world_component.dart';

@Component(
    selector: 'game',
    template: '''
      <h1>game</h1>
      <world></world>
      ''',
    directives: const [WorldComponent],
    styles: const [":host{display: block;}"])
class GameComponent {
  StateService state;
  GameComponent(this.state) {
    this.state.onTaleLoaded.add(taleLoaded);
    this.state.loadTale("arena");
  }

  void taleLoaded() {
    // DO initialization of players
  }
}
