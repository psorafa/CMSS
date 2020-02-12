var util = require("./util/utils.js");
var scratch = require("./util/createScratchOrg.js");
var apexTest = require("./util/runTests.js");

var params = {
	alias: "cmss_validate",
	days: 1,
	conf: "config/project-scratch-def.json",
	deploy: true,
	data: false,
	devHub: "EnehanoDevHub",
	testLevel: "RunAllTestsInOrg"
};

params = util.parseScriptArguments(process.argv.slice(), params);

main(params)
	.then(result => util.print(result))
	.catch(error => util.print(error));

async function main(params) {
	var orgResultOk = await scratch.setupScratchOrg(params.alias, params.days, params.conf, params.devHub);
	if (!orgResultOk) {
		return "Failed creating scratch org";
	}

	var openResultOk = await apexTest.runTests(params.alias, params.testLevel);
	if (!openResultOk) {
		return "Tests Failed!";
	}

	return "ALL DONE!";
}
