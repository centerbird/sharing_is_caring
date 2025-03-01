class_name Villager extends CharacterBody2D
## [Villager]s follow paths to bring resources to thier [Village]s.
##
## [Villager]s are meant to be directed towards different targets, through paths that go through [PathTile]s.
## @experimental : TODO

# This var is where the villager is headed, villager will navigate to the .global_position of nodes given.
var target : Node

var _resourceNode : Node
var _village : Node
var loaded : bool

@export var SPEED = 300
@export var ACCELERATION = 7

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# Sets initial animation.
	$AnimatedSprite2D.play("walk")
	
	# These values need to be adjusted for the actor's speed and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	# Villager spawns with empty hands
	loaded = false
	
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

# Physics set up
func actor_setup():
	
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target.global_position)
	#var test_location = Vector2(300, 600)
	#set_movement_target(test_location)

# TODO
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


#func get_destination() -> String:
	#return ""
#
#func give_direction(dir : String):
	#pass

# Moves villager
func _physics_process(delta):
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	velocity = velocity.lerp(current_agent_position.direction_to(next_path_position) * SPEED, ACCELERATION * delta)
	
	move_and_slide()

## Learn the destination of this [Villager].
## [br][br]
## [code]Return[/code] : TODO
func get_destination() -> String: #TODO
	return ""

## Change this [Villager]'s destination.
## [br][br]
## [param dir] : The new direction for the [Villager]. The direction should be as it appears on the node tree.
## [br][br]
## [b]Note:[/b] Has no effect if [Villager] is carrying resources.
func give_direction(dir : String): #TODO
	pass

#Repeatedly sets villager target to target so when something changes the target it properly applies
func _on_timer_timeout():
	#Temp: Prevents crashes when resource node is empty thus freed
	if target != null:
		#Sets villager movement target to target (currently other nodes do this by changing the target node)
		set_movement_target(target.global_position)


#Setup is called by village node to send info about village node that spawned this villager 
#	and resource node this villager should start moving towards
#	other setup functions are handled by _ready() and actor_setup()
func setup(village : Node, resourceNode: Node):
	_village = village
	_resourceNode = resourceNode
	target = _resourceNode
