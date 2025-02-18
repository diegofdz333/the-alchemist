extends Sprite2D
var is_dragging = false;
var mouse_offset;
var delay = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func process_dragging(delta):
	if is_dragging:
		var tween = get_tree().create_tween();
		tween.tween_property(
			self,
			"position",
			get_global_mouse_position() - mouse_offset,
			delay * delta
		);
		return true;
	return false;
	

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(get_global_mouse_position())):
				is_dragging = true;
				mouse_offset = get_global_mouse_position() - global_position;
		else:
			is_dragging = false;
