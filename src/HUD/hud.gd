class_name HUD extends Node2D
## Defines the bahaviour of the HUD.
##
## Communicates with the game world to manage healthbar changes. Dictates when to proceed to the next level.
## @experimental : TODO test healthbar activation on village spawn

## Signals grid to enlarge/zoom out/whatever
signal enlarge_grid

## Connects a village to its respective health bar.
## [br][br] [param village] : the village that has finally become vulnerable to damage.
func connect_village(village : Village):
	get_node(_health_bar_name(village.get_id())).activate(village.get_id())
	village.resource_delivery.connect(deliver_resource)

## Increases the resources (or the health bar) of the given [Village].
## [br][br]
## [param village_id] : Index designating the village. This is a number between 0 and 4; corresponding to the village from top to the bottom of the HUD, respectively.
func deliver_resource(village_id : int) -> void:
	get_node(_health_bar_name(village_id)).health += 1

# Obtains the name of the village healthbar associated with the village ID.
# [param index] : Index designating the village. This is a number between 0 and 4; corresponding to the village from top to the bottom of the HUD, respectively.
func _health_bar_name(index : int) -> String:
	return "HealthBar" + str(index) + "/ProgressBar"

# Decrease all active health bars by one.
func _on_timer_timeout() -> void:
	for i in range(1,6):
		get_node(_health_bar_name(i)).health -= 1

# Ends the game and spawns game over screen. TODO
func _on_game_over() -> void:
	pass # TODO : spawn game over screen

# Rides the enlarge grid signal.
func _on_button_press() -> void:
	enlarge_grid.emit()
