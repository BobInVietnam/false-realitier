extends Node

@onready var tilemap: Node2D = $Tilemap
@onready var frab: CharacterBody2D = $Frab
@onready var parallax_2d: Parallax2D = $Parallax2D
@onready var signs: Node2D = $Signs
@onready var hurt_timer: Timer = $Node/HurtTimer
@onready var pill_timer: Timer = $Node/PillTimer

var isPilled: bool = false;
var checkpoint: Vector2 = Vector2(0, -16);
var pill_time = 10;
var use_count = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pill"):
		if (!isPilled):
			take_pill();
			isPilled = !isPilled;

func take_pill() -> void:
	tilemap.get_child(1).visible = false;
	tilemap.get_child(0).visible = true;
	parallax_2d.visible = false;
	frab.set_p_state(1)
	for sign in signs.get_children():
		if sign is Sign:
			sign.get_node("Real").visible = true;
			sign.get_node("Normal").visible = false;
	print("Pilled")
	if use_count > 0:
		pill_timer.start(pill_time);
	use_count -= 1;
	pill_time += 4;
	
func wear_out_pill() -> void:
	tilemap.get_child(0).visible = false;
	tilemap.get_child(1).visible = true;
	parallax_2d.visible = true;
	frab.set_p_state(0)
	for sign in signs.get_children():
		if sign is Sign:
			sign.get_node("Real").visible = false;
			sign.get_node("Normal").visible = true;
	print("Not pilled")
	isPilled = false;

func _on_frab_is_hurt() -> void:
	print("Nooooooo");
	hurt_timer.start();

func _on_hurt_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
func _on_pill_timer_timeout() -> void:
	wear_out_pill();
