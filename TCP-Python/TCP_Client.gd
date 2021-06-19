extends Node

var tcp := StreamPeerTCP.new()
var connected = false
var response

func _ready():
	tcp.connect_to_host("127.0.0.1", 4242)
	
func _process(delta):
	if tcp.get_status() == 2:
		tcp.put_data("The answer is... 42!".to_utf8())
		response = tcp.get_data(1024)
		print(response[1].get_string_from_utf8())
		
