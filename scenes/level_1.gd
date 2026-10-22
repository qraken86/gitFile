extends Node2D

@export var spawnpoint : Vector2 = Vector2(597,353)
@onready var player : CharacterBody2D = $CharacterBody2D

@export var level_number: int = 1
@onready var timer_label: Label = $HUD/timer_label
@onready var result_panel: Label = $HUD/Container/VBoxContainer/result_panel

var elapsed_time : float = 0.0
var timer_running : bool = false
var leveFinished : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for spike in $spike.get_children():
		if spike is Area2D:
			spike.body_entered.connect(_on_spike_body_entered)
	_start_timer()
	$HUD/Container.visible = false
	
func _start_timer():
	elapsed_time = 0.0
	timer_running = true     # Süreyi başlatmak için true yapıyoruz
	leveFinished = false     # Bölümün henüz bitmediğini belirtiyoruz
	result_panel.text = ""   # Başlangıçta paneli temizliyoruz

func _update_timer_label():
	timer_label.text = "%.2f sn" % elapsed_time

func _on_spike_body_entered(body:Node2D) -> void:
	if body == player:
		# NOT: change_scene_to_file yaparsanız aşağıdaki ışınlama kodları işlevsiz kalabilir. 
		# Eğer sadece öldüğünde başa dönsün istiyorsanız alttaki change_scene satırını silin.
		get_tree().change_scene_to_file("res://scenes/UI.tscn")
		
		player.global_position = spawnpoint
		player.velocity = Vector2.ZERO
		_start_timer() # Ölünce süreyi tekrar sıfırdan başlatıyoruz

func _process(delta: float) -> void:
	# Eğer zamanlayıcı çalışıyorsa süreyi ilerlet ve etiketi güncelle
	if timer_running:
		elapsed_time += delta
		_update_timer_label()

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass

func _on_finisharea_body_entered(body: Node2D) -> void:
	if body != player or leveFinished:
		return
	leveFinished = true
	timer_running = false
	$HUD/Container.visible = true
	
	result_panel.text = "level finished\n süre: %.2f sn" % elapsed_time



func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
