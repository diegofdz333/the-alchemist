extends Node2D

const winning_plants: Dictionary = {
	"Starbloom": null,
	"Ashthorn": null,
	"Walking Toad": null,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_submit_button_pressed():
	var plants = $Cauldron.plants
	var names = {}
	for p in plants:
		names[p.plant_name] = null
	print(names)
	if names == winning_plants:
		print("win!")
	else:
		print("try again!")
	pass # Replace with function body.
