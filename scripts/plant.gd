extends Item

## name of the plant
@export var plant_name: String;

var in_cauldron: bool = false;
var label_shown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	big_texture = texture
	big_texture_scale = scale
	$Label.text = plant_name
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
	if not pressed and get_rect().has_point(to_local(get_global_mouse_position())):
		show_label()
	else:
		hide_label()
	pass


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
			
	
			

func show_label():
	$Label.show()

func hide_label():
	$Label.hide()
	
	
