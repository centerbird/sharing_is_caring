class_name DamageBarManager extends Node2D
## Manages the activation of a [DamageBar].
##
## Initializes [DamageBar] according to associated [Village]. Channels [signal game_over] higher in the hierarchy.

## Signals that the game is over.
signal game_over

## Hides the hud element.
func _ready():
	hide()

## Renders health bar visible and changes its color according to the given village ID.
## [br][br]
## [param village_id] : Index designating the village. A number 0 or above; this number signifies which healthbar on the HUD this [Village] is associated to.
func activate(village_id : int):
	show()
	modulate = SharingIsCaring.VillageColors[village_id]
	$ProgressBar.activate()

# Rides game over signal.
func _on_progress_bar_game_over() -> void:
	game_over.emit()
