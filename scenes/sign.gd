class_name Sign extends Area2D;

@export var normal_string: String
@export var alt_string: String
@onready var panel_container: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/MarginContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.visible = false;

func _on_body_entered(body: Node2D) -> void:
	if body is Frab:
		if body.isPilled():
			label.text = alt_string
		else:
			label.text = normal_string
		panel_container.visible = true;
	
func _on_body_exited(body: Node2D) -> void:
	panel_container.visible = false;
