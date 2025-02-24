class_name Villager extends Area2D
## [Villager]s follow paths to bring resources to thier [Village]s.
##
## [Villager]s are meant to be directed towards different targets, through paths that go through [PAthTile]s.
## @experimental : TODO

## Sets initial animation.
func _ready():
	$AnimatedSprite2D.play("walk")

## Learn the destination of this [Villager].
## [br][br]
## [code]Return[/code] : 
func get_destination() -> String: #TODO
	return ""

## Change this [Villager]'s destination.
## [br][br]
## [param dir] : The new direction for the [Villager]. The direction should be as it appears on the node tree.
## [br][br]
## [b]Note:[/b] Has no effect if [Villager] is carrying resources.
func give_direction(dir : String): #TODO
	pass
