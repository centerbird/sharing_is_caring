class_name Villager extends Area2D
## [Villager]s follow paths and move though their own [Village]s to bring resources to thier [Village]s. TODO
## @experimental : not yet complete

func _ready():
	$AnimatedSprite2D.play("walk")

func get_destination() -> String:
	return ""

func give_direction(dir : String):
	pass
