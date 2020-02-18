var util = require("./util/utils.js");
var git = require("./util/gitUtils.js");
var scratch = require("./util/createScratchOrg.js");

var params = {
	alias: "cmss",
	days: 10,
	conf: "config/project-scratch-def.json",
	deploy: true,
	data: true,
	devHub: "EnehanoDevHub",
	open: true
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
	if (params.open) {
		var openResultOk = await scratch.openOrg(params.alias);
		if (!openResultOk) {
			return "Created, Failed to open";
		}
	}
	return "ALL DONE!";
}
