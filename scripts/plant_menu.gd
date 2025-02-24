extends Area2D

signal submit(plants)

## proportion of the screen occupied by retracted menu
@export var peek: float = 0.07 
## proportion of the screen occupied by expanded menu
@export var full: float = 0.3

const rows: int = 3
const cols: int = 2
const margin: float = 0.3
const plant_proportion: float = 0.6

const PLANT_MENU_Z: int = 50
var retracted_pos: Vector2 = Vector2.ZERO
var expanded_pos: Vector2 = Vector2.ZERO
var width: int = 0
var height: int = 0
var expanded: bool = false

var plants: Dictionary = {}
var occupied: Dictionary = {}
var cauldron

var viewportWidth;


# Called when the node enters the scene tree for the first time.
func _ready():
	viewportWidth = 1152;
	print(get_viewport().size.x)
	position_menu()
	cauldron = $"../Cauldron"
	position_cauldron(cauldron)
	cauldron.in_menu = true
	for r in range(rows):
		for c in range(cols):
			occupied[Vector2(r, c)] = false
	var plant_arr = $"../Plants".get_children()
	for plant in plant_arr:
		plant.in_menu = true
		plant.texture = plant.small_texture
		rescale(plant)
		reposition(plant)
	update_menu_items()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func position_menu():
	var viewport_width = viewportWidth;
	width = $Sprite2D.texture.get_width()
	height = $Sprite2D.texture.get_height()
	retracted_pos = Vector2(viewport_width / 2 + width / 2 - peek * viewport_width, 0)
	expanded_pos = Vector2(viewport_width / 2 + width / 2 - full * viewport_width, 0)
	position = retracted_pos
	z_index = PLANT_MENU_Z
	

func pos_in_menu(pos):
	var left = expanded_pos.x - width / 2
	var top = expanded_pos.y - height / 2
	var bottom = expanded_pos.y + height / 2
	return pos.x > left and pos.y > top and pos.y < bottom


func update_menu_items():
	if expanded:
		for p in plants:
			p.show()
			p.set_process_input(true)
		if cauldron.in_menu:
			cauldron.show()
			cauldron.set_process_input(true)
	else:
		for p in plants:
			p.hide()
			p.set_process_input(false)
		if cauldron.in_menu:
			cauldron.hide()
			cauldron.set_process_input(false)


func rescale(plant):
	var col_width = (-expanded_pos.x + width / 2 + viewportWidth / 2) / cols
	var row_height = height * plant_proportion / rows
	var rect = plant.get_rect()
	var sprite_width = rect.size.x
	var sprite_height = rect.size.y
	var x_scale = (1 - margin) * col_width / sprite_width
	var y_scale = (1 - margin) * row_height / sprite_height
	plant.scale = Vector2(min(x_scale, y_scale), min(x_scale, y_scale))


# Snap a plant to a grid cell in the menu
func reposition(plant):
	var col_width = (-expanded_pos.x + width / 2 + viewportWidth / 2) / cols
	var row_height = height * plant_proportion / rows
	var top_left = Vector2(expanded_pos.x - width / 2, -height / 2)

	for r in range(rows):
		for c in range(cols):
			if not occupied[Vector2(r, c)]:
				var x_pos = col_width * (c + 0.5)
				var y_pos = row_height * (r + 0.5)
				plant.position = top_left + Vector2(x_pos, y_pos)
				plants[plant] = Vector2(r, c)
				occupied[plants[plant]] = true
				return


func position_cauldron(cauldron):
	var col_width = -expanded_pos.x + width / 2 + viewportWidth / 2
	var row_height = height * (1 - plant_proportion)
	var rect = cauldron.get_rect()
	var sprite_width = rect.size.x
	var sprite_height = rect.size.y
	var x_scale = (1 - margin) * col_width / sprite_width
	var y_scale = (1 - margin) * row_height / sprite_height
	cauldron.scale = Vector2(min(x_scale, y_scale), min(x_scale, y_scale))
	
	var top_left = Vector2(expanded_pos.x - width / 2, -height / 2)
	var x_pos = col_width / 2
	var y_pos = plant_proportion * height + row_height / 2
	cauldron.position = top_left + Vector2(x_pos, y_pos)
	

func _on_expand_button_pressed():
	if expanded:
		position = retracted_pos
	else:
		position = expanded_pos
	expanded = not expanded
	update_menu_items()
			


func _on_plant_dropped(plant):
	if expanded:
		plant.in_menu = pos_in_menu(plant.position) and plant.z_index > PLANT_MENU_Z
		if plant in plants and not plant.in_menu:
			# plant moved out of menu
			plant.reload_texture();
			occupied[plants[plant]] = false
			plants.erase(plant)
		elif plant not in plants and plant.in_menu:
			# plant moved into menu
			plant.texture = plant.small_texture
			rescale(plant)
			reposition(plant)
		elif plant in plants and plant.in_menu:
			# plant already in menu but dragged somewhere else within
			occupied[plants[plant]] = false
			reposition(plant)


func _on_cauldron_dropped(cauldron):
	if expanded:
		cauldron.in_menu = pos_in_menu(cauldron.position) and cauldron.z_index > PLANT_MENU_Z
		if not cauldron.in_menu:
			# cauldron moved out of menu
			cauldron.reload_texture();
		elif cauldron.in_menu:
			# cauldron moved into menu
			var cauldron_plants = cauldron.plants.duplicate()
			for plant in cauldron_plants:
				plant.in_menu = true
				plant.in_cauldron = false
				cauldron.plants.erase(plant)
				plant.texture = plant.small_texture
				rescale(plant)
				reposition(plant)
			cauldron.texture = cauldron.small_texture
			position_cauldron(cauldron)
