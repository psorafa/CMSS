module.exports = {
	printJson: function(json_string) {
		console.log(JSON.stringify(json_string, null, 2));
	},
	print: function(string) {
		console.log(string);
	},
	sleep: function(millis) {
		return new Promise(resolve => setTimeout(resolve, millis));
	},
	parseScriptArguments: function(scriptArgs, defaultArgs, tokenOffset = 2) {
		//0: node, 1: file, 2.. args
		var scriptArgs = process.argv.slice();
		for (int = 0; i < tokenOffset; i++) {
			scriptArgs.shift();
		}
		this.print("Provided Arguments..[" + scriptArgs.length / 2 + "]");
		for (var i = 0; i < scriptArgs.length; i = i + 2) {
			var argName = scriptArgs[i].replace(/-/g, "");
			var argValue = scriptArgs[i + 1];
			this.print(argName + ": " + argValue);
			defaultArgs[argName] = argValue;
		}
		this.printJson(defaultArgs);
		return defaultArgs;
	}
};
