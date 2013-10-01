function main() {
	var a = 1;
	var b = 22;
	var f = ( function(myvariable) {
		return function() {	
			console.log(myvariable);
		}
	}) (b);
	a = 2;
	f();
}

main();