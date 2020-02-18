module.exports = {
	setupScratchOrg: function(alias, days, conf, devHub) {
		const shell = require("./commandExec.js");
		const util = require("./utils.js");

		if (!this.createAndSetDefaut(alias, days, conf, devHub, shell, util)) {
			return false;
		}

		if (!this.deploySource(alias, "config\\settings", 2, shell, util)) {
			return false;
		}

		if (!this.deploySource(alias, "config\\languages", 2, shell, util)) {
			return false;
		}

		if (!this.pushSource(alias)) {
			return false;
		}

		return true;
	},
	createAndSetDefaut: function(alias, days, conf, devHub, existing_shell, existing_util) {
		const shell = existing_shell ? existing_shell : require("./commandExec.js");
		const util = existing_util ? existing_util : require("./utils.js");

		var createOrgResult = shell.exec(`sfdx force:org:create -a ${alias} -d ${days} -f ${conf} -v ${devHub} --json`);
		//util.printJson(createOrgResult);
		if (createOrgResult.status != 0) {
			util.print(createOrgResult.message);
			return false;
		}

		var setDefaultResult = shell.exec(`sfdx force:config:set defaultusername=${alias} --json`);
		if (setDefaultResult.status != 0) {
			util.print("Error setting default org");
			return false;
		}

		return true;
	},
	pushSource: function(alias, existing_shell, existing_util) {
		const shell = existing_shell ? existing_shell : require("./commandExec.js");
		const util = existing_util ? existing_util : require("./utils.js");

		var sourcePushResult = shell.exec(`sfdx force:source:push -u ${alias} --json`);
		if (sourcePushResult.status != 0) {
			util.print(sourcePushResult);
			return false;
		}
		return true;
	},
	deploySource: function(alias, folder, wait = 30, existing_shell, existing_util) {
		const shell = existing_shell ? existing_shell : require("./commandExec.js");
		const util = existing_util ? existing_util : require("./utils.js");

		var sourceDeployResult = shell.exec(`sfdx force:source:deploy -w ${wait} -u ${alias} -p ${folder} --json`);
		if (sourceDeployResult.status != 0) {
			util.print(sourceDeployResult);
			return false;
		}
		return true;
	},
	openOrg: function(alias, existing_shell, existing_util) {
		const shell = existing_shell ? existing_shell : require("./commandExec.js");
		const util = existing_util ? existing_util : require("./utils.js");

		var openOrgResult = shell.exec(`sfdx force:org:open -u ${alias} --json`);
		if (openOrgResult.status != 0) {
			util.print(openOrgResult);
			return false;
		}
		return true;
	}
};
