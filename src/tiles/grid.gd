class_name Grid extends NavigationRegion2D
## Defines and manages the interactible game world.
##
## Positioned in the middle of the game world.
## Populates the game world with different kinds of Tiles and transforms them according to input from the player.
## Can be "zoomed out" or "shrunk" to reveal new tiles around its initial setup.


# --PROPERTIES--

## The maximum number of [Villages] allowed in the game.
@export var max_villages : int = 5

@export_group("Sizes")
## Dimensions of the initial game world (in Tiles).
## [br][br]
## Dimensions of the [Vector2] correspond to the number of Tiles in a row, and the number of Tiles in a column, respectively.
@export var dimensions : Vector2 = Vector2(5, 5)

## A tile's [i]width[/i] (and [i]height[/i]) in pixels.
## This value is used to calculate the positions of Tiles proportionate to the [Grid].
## [br]
## [b]Note:[/b] The [i]width[/i] and [i]hight[/i] of [b]each[/b] "Tile" must be this amount to ensure proper visual placement.
@export var tile_size : Vector2 = Vector2(128, 128)


# -- EXPORTED PROPERTIES--

@export_group("Tiles")
## Village tile.
## [br][br]
## These tiles are responsible for updating the game's state, spawning [Villager]s and assigning them.
@export var village := preload("res://Scenes/tiles/village.tscn")

## Unoccupied tiles of the scene.
## [br][br]
## The most common type of tile.
@export var empty := preload("res://Scenes/tiles/unoccupied_tile.tscn")

## Resource tiles serve as fuel for [Village]s.
@export var resource := preload("res://Scenes/tiles/resource_tile.tscn")

## A path tile.
## [br][br] Path tiles connect game world elements together. They inform the villages of the location of resources and direct villagers that traverse them.
@export var path := preload("res://Scenes/tiles/path_tile.tscn")

## A destroyed tile.
## [br][br] These tiles serve as obstacles now.
@export var destroyed := preload("res://Scenes/tiles/destroyed.tscn")

## A battle tile.
## [br][br] After letting villagers kill eachother, these tiles disappear.
@export var battlefield := preload("res://Scenes/tiles/battlefield.tscn")


@export_group("Spawn Rates")
## Spawn rate of [Village]s. 0 would mean no new [Village]s will be spawned and 100 would make every new tile a new [Village].
@export_range(0,100) var village_spawn_rate : int = 0

## Spawn rate of [Resource]s. 0 would mean no new [Resource]s will be spawned and 100 would make every new tile, that is not a [Village], a new [Resource].
## Yes, [Village]s have priority over [Reource]s.
@export_range(0,100) var resource_spawn_rate : int = 0


# --PRIVATE PROPERTIES--

# Number of spawned villages
var _village_number : int = 0

# Keeps track of how small the grid has become
var _new_zero : int = 0

# The distance of [Grid] from the top left corner of the tile at coordinates (0, 0).
var _initial_offset : Vector2


# --PROPERTIES UPDATED ON INSTANTIATION--

# Random number generator for generating random Tiles.
@onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

# New dimensions of the [Grid] after rescaling.
@onready var _new_dimensions : Vector2 = dimensions

# Remember the original scale of the [Grid]. TODO : remove
#@onready var _initial_scale : Vector2 = scale 

# The child holding the Tiles of in the [Grid].
@onready var _tile_holder := $Node2D


# -- SIGNALS--

## Emitted when a new [Village] is added to the game world.
## [br][br]
## [param instance] : instance of the newly spawned [Village]
signal new_village


# --METHODS--
## Calculates the initial values of more complex private properties.
func _ready() -> void:
	var half_size := tile_size/2.0
	var coefficient := Vector2.ONE - dimensions
	_initial_offset = Vector2(half_size.x * coefficient.x, half_size.y * coefficient.y)


## Populates the initial scene.
## [br][br]
## Creates an initial world scene by instantiating randomized Tiles at correct positions.
## The size of this scene is dependant on the [member dimensions].
func populate() -> void:
	var deck : Array[Resource] = []
	deck.append(village)
	deck.append(village)
	deck.append(resource)
	for i in range(dimensions.x * dimensions.y - 3):
		deck.append(empty)
	deck.shuffle()
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			var instance = deck.pop_front().instantiate()
			var location = calc_location(x, y)
			spawn_tile(location, instance)
	bake_navigation_polygon()

## Calculates the [member position] of a Tile, given it's coordinates on the [Grid].
## Used to calculate the prospective positions of Tiles before they are spawned.
## [br]
## The calculated position is proportionate to grid; it is [b]NOT[/b] the [member global_position].
## [br]
## [br][param x] : horizontal coordinate (abscissa) of the Tile in grid
## [br][param y] : vertical coordinate (ordinate) of the Tile in grid
## [br][br]
## [code]Returns[/code] : [member postion] of the Tile proportional to [Grid].
## [br][br]
## [b]Note:[/b] The coordinates of the Tiles correspond to the [b]initial[/b] layout of the [Grid] defined by its [member dimensions].
## When the [Grid] is first populated using [method populate], the Tile at the [i]top left[/i] corner would have the coordinates (0, 0).
## The Tile on the [i]bottom right[/i] would, on the other hand, have the coordinates ([member dimensions].x, [member dimansions].y).
## [br]
## If a new Tile is placed right above the Tile at (0, 0), for example with the [method fill_around] method, that new Tile right above the one at (0, 0) would have the coordinates (0, -1).
## The coordinates of the initial Tile at (0, 0) would [b]not[/b] change.
func calc_location(x : int, y : int) -> Vector2:
	return Vector2(_initial_offset.x + (tile_size.x * x), _initial_offset.y + (tile_size.y * y))

## Spawns a node at a given location.
## [br][br]
## [param location] : The position (relative to grid) at which to spawn the node.
func spawn_tile(location : Vector2, instance : Node2D) -> void:
	match instance.get_script():
		UnoccupiedTile:
			instance.expired.connect(_on_empty_expire)
		PathTile:
			instance.battle_start.connect(_on_battle_start)
		ResourceTile:
			instance.battle_start.connect(_on_battle_start)
			instance.depleted.connect(_on_destruction)
		Battlefield:
			instance.battle_ended.connect(_on_destruction)
		Village:
			instance.id(_village_number)
			_village_number += 1
			instance.modulate = SharingIsCaring.VillageColors[instance.get_id()]
			new_village.emit(instance)
	instance.position = location
	_tile_holder.add_child(instance)

## Rescales the [Grid] and populates the newly appeared empty area.
func enlarge() -> void:
	var old_dimensions = _new_dimensions
	_new_dimensions += Vector2.ONE * 2
	scale.x = scale.x * (float(old_dimensions.x)/float(_new_dimensions.x))
	scale.y = scale.y * (float(old_dimensions.y)/float(_new_dimensions.y))
	fill_around()
	bake_navigation_polygon()

## Fills the immediate area surrounding the currently existing game world with a one Tile thick line of Tiles.
## [br][br]
## [b]Note:[/b] If called before [method populate], fills around the area defined by [member dimensions].
func fill_around():
	var location : Vector2
	_new_zero -= 1
	# fill top and bottom (and corners)
	var new_dimensions = _new_dimensions + (Vector2.ONE * _new_zero)
	for tile_abscissa in range(_new_zero, new_dimensions.x):
		location = calc_location(tile_abscissa, _new_zero)
		spawn_tile(location, _get_random_tile_instance())
		location = calc_location(tile_abscissa, new_dimensions.y - 1)
		spawn_tile(location, _get_random_tile_instance())
	# fill sides (except corners)
	for tile_ordinate in range(_new_zero + 1, new_dimensions.y - 1):
		location = calc_location(_new_zero, tile_ordinate)
		spawn_tile(location, _get_random_tile_instance())
		location = calc_location(new_dimensions.x - 1, tile_ordinate)
		spawn_tile(location, _get_random_tile_instance())


# --PRIVATE METHODS--

# Resets the game world.
func _reset() -> void:
	for child in _tile_holder.get_children():
		remove_child(child)
		child.queue_free()
	_new_dimensions = dimensions
	_tile_holder.scale = scale
	_village_number = 0
	_new_zero = 0
	_on_start()

# Instantiates a random tile from the allowed options.
# [code]Returns[/code] : The instance of the newly instantiated tile.
func _get_random_tile_instance() -> Node2D:
	var x = _rng.randi_range(0, 100)
	match x:
		x when x < village_spawn_rate:
			if _village_number != max_villages:
				return village.instantiate()
		x when (x - village_spawn_rate) < resource_spawn_rate:
			return resource.instantiate()
	return empty.instantiate()


# --LISTENER METHODS--

# Spawns a "destroyed tile" on the spot where the destruction of a Tile was reported.
# [br][br]
# [param location] : The location where a Tile was supposedly destroyed for any reason.
func _on_destruction(location : Vector2) -> void:
	spawn_tile(location, destroyed.instantiate())
	bake_navigation_polygon()

# Spawns battlefield.
func _on_battle_start(location : Vector2) -> void: # TODO : tell people about the started battle?
	spawn_tile(location, battlefield.instantiate())

# Defines the behaviour when an unoccupied tile becomes a path.
# [br][br]
# [param location] : [member position] of the expired tile.
func _on_empty_expire(location : Vector2) -> void:
	spawn_tile(location, path.instantiate())
	bake_navigation_polygon()

# Behaviour to take at the very start of the game. Populates the initial range of [Grid].
func _on_start() -> void:
	populate()
