extends Sprite2D
class_name Item

signal release(item)

## texture for the doc when it is inside the menu 
## (can be any size, code will autoscale it to fit a grid cell)
@export var small_texture: Texture;
var big_texture: Texture; # to store the original texture of the doc
var big_texture_scale: Vector2;
var in_menu: bool = false;

const DELAY = 1;

var mouse_offset;
var is_dragging = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reload_texture():
	texture = big_texture;
	scale = big_texture_scale;


func process_dragging(delta):
	if is_dragging:
		var tween = get_tree().create_tween();
		tween.tween_property(
			self,
			"position",
			get_global_mouse_position() - mouse_offset,
			DELAY * delta
		);
		return true;
	return false;
