class_name SharingIsCaring extends Node2D
## Provides a connection between the [HUD] and the game world ([Grid]).
##
## [b]Note:[/b] .

## The [HUD] reference from this scene.
@export var hud : HUD

## The [Grid] reference from this scene.
@export var grid : Grid

## Colors associated with [Village]s in order of appearance.
const VillageColors : Array[Color] = [Color.CYAN, Color.MAGENTA, Color.GOLDENROD, Color.LAWN_GREEN, Color.TURQUOISE]

## Connects new [Village] to the [HUD].
##[br][br]
## [param village] : The new [Village] to be connected.
func _on_new_village(village : Village) -> void:
	hud.connect_village(village)

## Zooms out the game world and spawns new Tiles.
func _on_enlarge() -> void:
	grid.enlarge()
