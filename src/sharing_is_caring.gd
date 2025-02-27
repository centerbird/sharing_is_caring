class_name SharingIsCaring extends Node2D
## Defines the core of the game.
##
## [b]Note:[/b] Expects a [HUD] named "Hud" as a child to function correctly.

## Colors associated with [Village]s in order of appearance.
const VillageColors : Array[Color] = [Color.CYAN, Color.MAGENTA, Color.GOLDENROD, Color.LAWN_GREEN, Color.TURQUOISE]

## Connects new [Village] to the [HUD].
##[br][br]
## [param village] : The new [Village] to be connected.
func _on_new_village(village : Village) -> void:
	$Hud.connect_village(village)
