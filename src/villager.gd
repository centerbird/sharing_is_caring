class_name Villager extends CharacterBody2D
## [Villager]s follow paths and move though their own [Village]s to bring resources to thier [Village]s. TODO
## @experimental : not yet complete


func _ready():
	$AnimatedSprite2D.play("walk")
	# These values need to be adjusted for the actor's speed and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	$".."/"..".bake_navigation_polygon()
	await get_tree().physics_frame
	
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target.global_position)
	#var test_location = Vector2(300, 600)
	#set_movement_target(test_location)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


#func get_destination() -> String:
	#return ""
#
#func give_direction(dir : String):
	#pass

var target : Node
var _resourceNode : Node
var _village : Node

@export var SPEED = 300
@export var ACCELERATION = 7

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta):
	#var direction = Vector2.ZERO
	#direction = navigation_agent.get_next_path_position() - global_position
	#direction = direction.normalized()
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = velocity.lerp(current_agent_position.direction_to(next_path_position) * SPEED, ACCELERATION * delta)
	
	
	
	#velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
	move_and_slide()

func _on_timer_timeout():
	
	set_movement_target(target.global_position)
	
	#navigation_agent.target_position = target.global_position

func setup(village : Node, resourceNode: Node):
	_village = village
	_resourceNode = resourceNode
	target = _resourceNode
