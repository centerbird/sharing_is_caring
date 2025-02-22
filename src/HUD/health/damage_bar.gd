class_name DamageBar extends ProgressBar
## Defines a health bar for the [Village]s.
##
## @experimental : not yet finished

## Change the health represented on the healthbar.
@export var health = 16 : set = _set_health

# The background bar.
@onready var _damage_bar = $DamageBar

# Determines if this health bar is currntly associated with an existing village.
# [br] If [code]true[/code], the health bar is active.
var active = false

## Signal that a village is dead.
signal game_over

## Set current hitpoints and initialize the health bar.
func _ready():
	var current_hitpoints = health
	var max_hitpoints = health
	max_value = max_hitpoints
	value = current_hitpoints
	_damage_bar.max_value = max_hitpoints
	_damage_bar.value = current_hitpoints
	_init_health(health)

# Manages the behaviour of the health bar when the health value changes.
func _set_health(new_health):
	if active:
		var prev_health = health
		health = min(max_value, new_health)
		value = health

		if health <= 0:
			game_over.emit()

		if health >= prev_health:
			_damage_bar.value = health

# Initializes both [DamageBar]s with the designated health value.
func _init_health(_health):
	health = _health
	max_value = health
	value = health
	_damage_bar.max_value = health
	_damage_bar.value = health
