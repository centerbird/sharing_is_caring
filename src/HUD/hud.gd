class_name HUD extends Node2D
## Defines the bahaviour of the HUD.
##
## @experimental : this class is not yet finished

## Increases the resources (or the health bar) of the given [Village].
## [br][br]
## [param village_id] : Index designating the village. This is a number between 0 and 4; corresponding to the village from top to the bottom of the HUD, respectively.
func deliver_resource(village_id : int) -> void:
	get_node(_health_bar_name(village_id)).health += 1

# Obtains the name of the village healthbar associated with the village ID.
func _health_bar_name(index : int) -> String:
	return "HealthBar" + str(index) + "/ProgressBar"

# Decrease all active health bars by one.
func _on_timer_timeout() -> void:
	for i in range(1,6):
		get_node(_health_bar_name(i)).health -= 1

# Ends the game and spawns game over screen. TODO
func _on_game_over() -> void:
	pass # TODO : spawn game over screen
