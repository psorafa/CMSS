module.exports = {
	exec: function(command_string) {
		var util = require("./utils.js");
		util.print(command_string);
		var tokens = command_string.split(" ");
		var sfdxCommand = tokens.shift();
		try {
			const result = require("child_process").execFileSync(sfdxCommand, tokens, {});
			return command_string.includes("--json") ? JSON.parse(result) : result;
		} catch (error) {
			console.log(error);
			return command_string.includes("--json") ? JSON.parse(error["stderr"]) : error["stderr"];
		}
	}
};
