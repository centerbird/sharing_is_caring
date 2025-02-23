class_name DamageBar extends ProgressBar
## Defines a health bar for the [Village]s.
##
## [b]Note:[/b] Expects a [ProgressBar] child named "DamageBar" to function properly.

## Change the health represented on the healthbar.
@export var health = 16 : set = _set_health

# The background bar.
@onready var _damage_bar = $DamageBar

# Determines if this health bar is currently associated with an existing village.
# [br] If [code]true[/code], the health bar is active.
var _active = false

## Signal that a village is dead.
signal game_over

## Activates the [DamageBar]. Activated [DamageBar]s become succeptible to registering health changes.
func activate() -> void:
	_active = true

## Set hitpoints to maximum and initialize the health bar.
func _ready() -> void:
	max_value = health
	value = health
	_damage_bar.max_value = health
	_damage_bar.value = health

# Manages the behaviour of the health bar when the health value changes.
#[br][br]
# [param new_health] : 
func _set_health(new_health) -> void:
	if _active:
		var prev_health = health
		health = min(max_value, new_health)
		value = health
		if health <= 0:
			game_over.emit()
		if health >= prev_health:
			_damage_bar.value = health
