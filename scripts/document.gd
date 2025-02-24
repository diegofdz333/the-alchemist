extends Item

@export_multiline var text: String;
@export var isEnglish: bool = true;

# Max holding time to be considered "clicked" rather than held
# In miliseconds
const SELECTION_TIME = 500;

var is_selected = false;
var click_time = 0;
var time

# Called when the node enters the scene tree for the first time.
func _ready():
	big_texture = texture
	big_texture_scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Overriden by Book
func get_text():
	return text;

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(get_global_mouse_position())):
				click_time = Time.get_ticks_msec();
				is_dragging = true;
				mouse_offset = get_global_mouse_position() - global_position;
			else:
				if $"../../Table".get_rect().has_point(get_global_mouse_position()):
					is_selected = false;
		else:
			if is_dragging:
				release.emit(self)
			is_dragging = false;
			if not in_menu:
				if get_rect().has_point(to_local(get_global_mouse_position())):
					if Time.get_ticks_msec() - click_time <= SELECTION_TIME:
						is_selected = true;
