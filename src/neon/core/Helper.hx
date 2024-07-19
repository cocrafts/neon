package neon.core;

var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

function randomChar():String {
	return chars.charAt(Math.floor(Math.random() * chars.length));
}

function generateUniqueId():String {
	var id = "";

	for (i in 0...8) {
		id += randomChar();
	}

	return id;
}
