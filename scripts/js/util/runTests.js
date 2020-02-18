module.exports = {
	runTests: function(alias, testLevel) {
		const shell = require("./commandExec.js");
		const util = require("./utils.js");

		var runTestsResult = shell.exec(
			`sfdx force:apex:test:run --targetusername ${alias} --testlevel ${testLevel} --codecoverage --resultformat human --json`
		);

		if (runTestsResult.status != 0) {
			util.print(runTestsResult.message);
			return false;
		}

		return true;
	}
};
