extends Item

const CAULDRON_Z = 20

var plants: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	big_texture = texture
	big_texture_scale = scale
	z_index = CAULDRON_Z
	$Label.text = "Cauldron: drag onto the table,\nplace the correct plants inside,\nand press submit"
	$Label.add_theme_font_size_override("font_size", 40)
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color(0, 0, 0, 0.5)
	new_sb.expand_margin_right = 20
	new_sb.expand_margin_left = 20
	new_sb.expand_margin_top = 10
	new_sb.expand_margin_bottom = 10
	$Label.add_theme_stylebox_override("normal", new_sb)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pressed = Input.is_mouse_button_pressed(1)
	if in_menu and not pressed and get_rect().has_point(to_local(get_global_mouse_position())):
		show_label()
	else:
		hide_label()
	pass

func show_label():
	$Label.show()

func hide_label():
	$Label.hide()

func process_dragging(delta):
	if is_dragging:
		var tween = get_tree().create_tween();
		tween.tween_property(
			self,
			"position",
			get_global_mouse_position() - mouse_offset,
			DELAY * delta
		);
		for p in plants:
			var ptween = p.get_tree().create_tween();
			var plant_offset = global_position - p.position
			ptween.tween_property(
				p,
				"position",
				get_global_mouse_position() - mouse_offset - plant_offset,
				DELAY * delta
			);
		return true;
	return false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(get_global_mouse_position())):
				is_dragging = true;
				mouse_offset = get_global_mouse_position() - global_position;
		else:
			if is_dragging:
				release.emit(self)
			is_dragging = false;


func pos_in_cauldron(pos):
	var width = texture.get_width()
	var height = texture.get_height()
	var right = position.x + width / 2
	var top = position.y - height / 2
	var bottom = position.y + height / 2
	var left = position.x - width / 2
	return pos.x > left and pos.x < right and pos.y > top and pos.y < bottom


func _on_plant_dropped(plant):
	if in_menu:
		return
	if $"../PlantMenu".expanded and $"../PlantMenu".pos_in_menu(plant.position):
		if plant.in_cauldron:
			plant.in_cauldron = false
			plants.erase(plant)
		return
	if plant not in plants and pos_in_cauldron(plant.position):
		# added to cauldron
		plant.in_cauldron = true
		plants[plant] = null
	elif plant in plants and not pos_in_cauldron(plant.position):
		# removed from cauldron
		plant.in_cauldron = false
		plants.erase(plant)
	
