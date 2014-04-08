Strict

'version 2
' - added debugging
'version 1
' - first commit

Import monkey.boxes
Import monkey.map
Import skn3.arraylist

#DEBUG_CALLBACKS = False

Private
Global callbackIdCount:Int
Global callbackIds:= New ArrayList<String>
Global receiverIdLists:= New IntMap<ArrayList<CallbackReceiver>>
#IF DEBUG_CALLBACKS
Global debugReceiver:CallbackDebugReceiver
#EndIf
Public

'public interface
Interface CallbackReceiver
	Method OnCallback:Bool(id:Int, source:Object, data:Object)
End

Interface CallbackDebugReceiver
	Method OnDebugCallback:Void(id:Int, source:Object, data:Object)
End

'public api
Function SetCallbackDebugReceiver:Void(receiver:CallbackDebugReceiver)
	' --- change receiver of debug callbacks ---
	#IF DEBUG_CALLBACKS
	debugReceiver = receiver
	#EndIf
End

Function RegisterCallbackId:Int(name:string)
	' --- register a uniquee callback id ---
	'create new id
	callbackIdCount += 1
	
	'set the callback id name
	callbackIds.AddLast(name)
	
	'return id of callback
	Return callbackIdCount
End

Function GetCallbackId:String(id:Int)
	' --- get the id of a callback ---
	If id < 1 or id > callbackIdCount Return ""
	Return callbackIds.data[id - 1]
End

Function ClearCallbackReceivers:Void(id:Int)
	' --- this will clear all receivers for an id ---
	receiverIdLists.Remove(id)
End

Function RemoveCallbackReceiver:Void(receiver:CallbackReceiver)
	' --- remove a callback receiver ---
	Local list:ArrayList<CallbackReceiver>
	For Local listId:= EachIn receiverIdLists.Keys()
		list = receiverIdLists.Get(listId)
		If list
			'remove receiver from list
			list.Remove(receiver)
			
			'check for empty list
			If list.IsEmpty() receiverIdLists.Remove(listId)
		EndIf
	Next
End

Function AddCallbackReceiver:Void(receiver:CallbackReceiver, id:int)
	' --- add a callback receiver ---
	If id = 0 Return
	
	'see if the list exists
	Local list:= receiverIdLists.Get(id)
	If list = Null
		'create new list
		list = New ArrayList<CallbackReceiver>
		receiverIdLists.Set(id, list)
	EndIf
	
	'add receiver to list
	If list.Contains(receiver) = False list.AddLast(receiver)
End

Function FireCallback:Bool(id:Int, source:Object, data:Object)
	' --- fires a callback ---
	Local list:ArrayList<CallbackReceiver> = receiverIdLists.Get(id)
	If list
		'do debug log
		#IF DEBUG_CALLBACKS
			If debugReceiver debugReceiver.OnDebugCallback(id, source, data)
		#EndIf
		
		'fire callback for all receivers
		For Local index:= 0 Until list.count
			'check for a callback blocking further execution
			If list.data[index].OnCallback(id, source, data) = True Return True
		Next
	EndIf
	
	'return that it wasn't blocked
	Return False
End

Function FireCallback:Bool(id:Int, source:Object)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, Null)
End

Function FireCallback:Bool(id:Int, source:Object, data:String)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, BoxString(data))
End

Function FireCallback:Bool(id:Int, source:Object, data:Bool)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, BoxBool(data))
End

Function FireCallback:Bool(id:Int, source:Object, data:int)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, BoxInt(data))
End

Function FireCallback:Bool(id:Int, source:Object, data:Float)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, BoxFloat(data))
End
