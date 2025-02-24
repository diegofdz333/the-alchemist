extends Node

const PLANT_Z = 10;

signal plant_dropped(plant)
signal cauldron_dropped(cauldron)
signal dragging

var plant_ordering: Array = [];
var cauldron;

# Called when the node enters the scene tree for the first time.
func _ready():
	var plants = get_children();
	for p in plants:
		p.release.connect(_on_plant_release)
		plant_ordering.push_back(p);
	cauldron = $"../Cauldron"
	cauldron.release.connect(_on_cauldron_release)
	refresh_z_indeces();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Process plant dragging
	for i in range(0, plant_ordering.size()):
		var p = plant_ordering[i];
		if p.process_dragging(delta):
			# Plant is being dragged
			dragging.emit()
			plant_ordering.pop_at(i);
			plant_ordering.push_front(p);
			refresh_z_indeces();
			return
			
	if cauldron.process_dragging(delta):
		# Cauldron is being dragged
		dragging.emit()
		
	refresh_z_indeces();


func _on_plant_release(plant):
	plant_dropped.emit(plant)


func _on_cauldron_release(cauldron):
	cauldron_dropped.emit(cauldron)
	

func refresh_z_indeces():
	var max_z = plant_ordering.size()
	cauldron.z_index = $"../Cauldron".CAULDRON_Z
	if cauldron.in_menu or cauldron.is_dragging:
		cauldron.z_index += ($"../PlantMenu".PLANT_MENU_Z)
	for i in range(0, max_z):
		# Higher z index is closer to screen
		var p: Sprite2D = plant_ordering[i];
		p.z_index = PLANT_Z + max_z - i - 1;
		if (i == 0 and p.is_dragging):
			p.z_index += 100
			continue
		if p.in_menu:
			p.z_index += ($"../PlantMenu".PLANT_MENU_Z)
		if p.in_cauldron:
			p.z_index += ($"../Cauldron".z_index)
