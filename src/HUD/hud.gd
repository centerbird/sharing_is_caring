class_name HUD extends Node2D
## Defines the bahaviour of the HUD.
##
## Communicates with the game world to manage health bar changes. Dictates when to proceed to the next level.

## Signals grid to enlarge/zoom out/go to next level/whatever
signal enlarge_grid

## Connects a village to its respective health bar.
## [br][br] [param village] : the village that has finally become vulnerable to damage.
func connect_village(village : Village) -> void:
	get_node(_health_bar_name(village.get_id())).activate(village.get_id())
	village.resource_delivery.connect(deliver_resource)

## Increases the resources (or the health bar) of the given [Village].
## [br][br]
## [param village_id] : Index designating the village. This is a number between 0 and 4; corresponding to the village from top to the bottom of the HUD, respectively.
func deliver_resource(village_id : int) -> void:
	get_node(_damage_bar_name(village_id)).health += 1

# Obtains the name of the damage bar associated with a village.
#[br][br]
# [param index] : Index designating the village. This is a number between 0 and 4; corresponding to the village from top to the bottom of the HUD, respectively.
#[br][br]
# [code]Returns[/code] : Name of the corresponding [DamaeBar] on scene.
func _damage_bar_name(index : int) -> String:
	return "HealthBar" + str(index + 1) + "/ProgressBar"

# Obtains the name of the village healthbar associated with the village ID.
#[br][br]
# [param index] : Index designating the village. This is a number between 0 and 4; corresponding to the village from top to the bottom of the HUD, respectively.
#[br][br]
# [code]Returns[/code] : Name of the corresponding [DamageBarManager] on scene.
func _health_bar_name(index : int) -> String:
	return "HealthBar" + str(index + 1)

# Decrease all active health bars by one.
func _on_timer_timeout() -> void:
	for i in range(0,5):
		get_node(_damage_bar_name(i)).health -= 1

# Ends the game and spawns game over screen. TODO
func _on_game_over() -> void:
	pass # TODO : spawn game over screen

# Rides the enlarge grid signal.
func _on_button_press() -> void:
	enlarge_grid.emit()
