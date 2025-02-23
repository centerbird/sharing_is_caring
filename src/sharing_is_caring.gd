class_name SharingIsCaring extends Node2D
## Defines the game.
##
## @experimental : not finished TODO

## Colors associated with [Village]s in order of appearance.
const VillageColors : Array[Color] = [Color.CYAN, Color.MAGENTA, Color.GOLDENROD, Color.LAWN_GREEN, Color.TURQUOISE]

## Connects new Village to the HUD.
func _on_new_village(village : Village) -> void:
	$Hud.connect_village(village)
