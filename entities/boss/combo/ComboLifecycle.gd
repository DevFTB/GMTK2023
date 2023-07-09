extends Node2D
class_name ComboLifecycle

class ActionLifecycle:
	signal started
	signal completed
	signal hit(strength: float)
	signal failed
	
	var boss: Node2D
	var action : BossAction
	# when the animations start playing, for charge attacks, the play must start holding now.
	var start_beat : int
	var hit_beat : int
	var end_beat : int
	
	var has_started = false
	
	var success_hit = false

	func _init(p_boss: Node2D, p_action: BossAction, p_offset = 0):
		boss  = p_boss
		action = p_action
		start_beat = p_offset
		hit_beat = p_offset + action.amount_of_beats
		end_beat = hit_beat + action.amount_of_cooldown_beats
		
		print("start ", start_beat, " hit: ", hit_beat, " end: ", end_beat)
		
	func process_beat(beat: int):
		if not has_started and beat >= start_beat:
			has_started = true
			started.emit()
			
		if has_started and beat >= end_beat and success_hit:
			completed.emit()
			
		if has_started and beat >= hit_beat + 1 and not success_hit:
			failed.emit()
			
	func next_player_beat() -> int:
		return hit_beat
	
	func rhythm_hit(strength: float, pressed: bool = true):
		if not success_hit:
			if pressed:
				if strength == 0:
					failed.emit()
				else:
					success_hit = true
					execute(strength)
					hit.emit(strength)

	func execute(strength: float, position: Vector2 = Vector2.ZERO):
		if action.action_scene:
			var action_instance = action.action_scene.instantiate()
			action_instance.strength = strength
		
			action_instance.position = position
			action_instance.rotation = boss.attack_direction.angle()
			action_instance.action = action
		
			boss.add_child(action_instance)
			
		else:
			print("action ", action.action_name, " with strength ", strength)
			
		action.do_effect(boss, Vector2.from_angle(boss.attack_direction.angle()))
		pass

class HoldActionLifecycle:
	extends ActionLifecycle
	
	var press_strength = 0
	
	func process_beat(beat: int):
		if has_started:
			if beat >= hit_beat + 1 and not success_hit:
				print("didn't hit in time")
				failed.emit()
			
			if beat >= end_beat:
				if success_hit:
					completed.emit()
				else:
					failed.emit()
		else:
			if beat >= start_beat + 1 and not success_hit:
				failed.emit()

	
	func rhythm_hit(strength: float, pressed: bool = true):
		print(action.action_name, " recieved ", "press" if  pressed else "release", " with stregnth ", strength)
		if not success_hit:
			
			if pressed and not has_started:
				if is_equal_approx(0, strength):
					failed.emit()
				else:
					press_strength = strength
					has_started = true
					started.emit()
					
			elif not pressed and not success_hit and has_started:
				if is_equal_approx(0, strength):
					failed.emit()
				else:
					execute(press_strength * strength)
					success_hit = true
					hit.emit(press_strength * strength)
					
	func next_player_beat() -> int:
		if not has_started:
			return start_beat
		else:
			return hit_beat
		

signal failed
signal completed

signal action_activated(action: BossAction)
signal action_hit(action: BossAction, strength: float)
signal action_started(action: BossAction)
signal action_completed(action: BossAction)

var combo : Combo

var active_action : ActionLifecycle:
	set(value):
		active_action = value
		if value != null:
			value.completed.connect(_on_action_completed)
			value.started.connect(_on_action_start)
			value.failed.connect(_on_action_failed)
			value.hit.connect(_on_action_hit)

var action_queue = []

var is_charging = false

var press_strength = 0

var next_beat = 0

var direction = Vector2.UP

@onready var beat_manager = get_tree().get_first_node_in_group("beat_manager")
# Called when the node enters the scene tree for the first time.
func _ready():
	beat_manager.beat.connect(_on_beat)
	
	print(rotation)
	var offset = beat_manager.beat_number + (1 if beat_manager.get_beat_progress() < 0.5 else 2)
	if combo.actions[0].is_hold_action:
		offset += 1
	
	for slot in range(combo.amount_of_slots):
		var action = combo.actions[slot]
		var lc
		if action.is_hold_action:
			lc = HoldActionLifecycle.new(get_parent(), action, offset)
			
		else:
			lc = ActionLifecycle.new(get_parent(), action, offset)
			
		action_queue.append(lc)
		offset = lc.end_beat
	
	active_action = action_queue.pop_front()
	pass # Replace with function body.	

func _input(event: InputEvent):
	if active_action:
		

		
		if event.is_action_pressed("rhythm_hit"):
			if active_action.success_hit and not action_queue.is_empty():
				active_action = action_queue.pop_front()
			var sync = beat_manager.get_sync_amount(active_action.next_player_beat())
			active_action.rhythm_hit(sync, true)
		
		if event.is_action_released("rhythm_hit"):
			var sync = beat_manager.get_sync_amount(active_action.next_player_beat())
			active_action.rhythm_hit(sync, false)
			

func _on_beat(beat_number: int):
	if active_action:
		active_action.process_beat(beat_number)
	pass

func _on_action_hit(strength):
	print("hit ", active_action.action.action_name)
	action_hit.emit(active_action.action, strength)
	pass
func _on_action_start():
	print("started ", active_action.action.action_name)
	action_started.emit(active_action.action)
	pass

func _on_action_completed():
	print("completed ", active_action.action.action_name)
	action_completed.emit(active_action.action)
	active_action = action_queue.pop_front()
	if active_action != null:
		action_activated.emit(active_action)
	else:
		completed.emit()
		queue_free()
	pass
	
func _on_action_failed():
	print("failed ", active_action.action.action_name)
	failed.emit()
	queue_free()
	pass
