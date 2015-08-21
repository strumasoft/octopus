Widget.QuestionPopup = function (data) {
    var info = parse(function(){/*!
		<h1>{{question}}</h1>
   
   		<button class="button" 
    		onclick='vars.questionPopup.delete()'>
    		No
    	</button>
		<button class="button special" 
			onclick='vars.questionPopup.proceed()'>
			OK
		</button>
	*/}, data)
	
	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.questionPopup = this.popup
	this.popup.init()
}

Widget.QuestionPopup.prototype = {
	constructor: Widget.QuestionPopup
}