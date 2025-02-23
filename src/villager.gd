class_name Villager extends CharacterBody2D
## [Villager]s follow paths and move though their own [Village]s to bring resources to thier [Village]s. TODO
## @experimental : not yet complete

func _ready():
	$AnimatedSprite2D.play("walk")

func get_destination() -> String:
	return ""

func give_direction(dir : String):
	pass

var target : Node

var speed = 300
var acceleration = 7

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _physics_process(delta):
	var direction = Vector2.ZERO

	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, acceleration * delta)

	move_and_slide()

func _on_timer_timeout():
	navigation_agent.target_position = target.global_position

var _village : Village

func setup(village : Village):
	_village = village
	target = $"../Grid/ResourceTile"
	print(target)
