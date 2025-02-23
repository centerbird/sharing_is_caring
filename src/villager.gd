class_name Villager extends Area2D
## [Villager]s follow paths to bring resources to thier [Village]s.
##
## [Villager]s are meant to be directed towards different targets, through paths that go through [PAthTile]s.
## @experimental : TODO

## Sets initial animation.
func _ready():
	$AnimatedSprite2D.play("walk")

func get_destination() -> String:
	return ""

func give_direction(dir : String):
	pass
