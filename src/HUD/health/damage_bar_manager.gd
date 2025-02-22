class_name DamageBarManager extends Node2D
## Manages the activation of [ProgressBars]
##
## @experimental : not yet finished

## Signals that the game is over.
signal game_over

## Hides the hud element.
func _ready():
	hide()

## Renders health bar visible and changes its color according to the village. TODO
func activate(village_id : int):
	show()
	modulate = SharingIsCaring.VillageColors[village_id]
	$ProgressBar.active = true

# Rides game over signal.
func _on_progress_bar_game_over() -> void:
	game_over.emit()
