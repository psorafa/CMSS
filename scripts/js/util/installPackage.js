module.exports = {
	installPackage: async function(alias, package_id, package_pwd, package_options, seconds) {
		var log = require("./util/utils");
		var sfdx = require("./util/commandExec");
		var installResult = sfdx.exec(this.installPackageCommand(alias, package_id, package_pwd, package_options));
		log.printJson(installResult);
		if (installResult.status != 0) {
			log.print(installResult.message);
			return false;
		}
		var counter = 0;
		var successfullyInstalled = false;
		var step = 5;
		while (!successfullyInstalled && counter < seconds) {
			log.print(`Checking progress for ${installResult.result.Id}. Waiting for ${seconds - counter}s`);
			var status;
			await log.sleep(step * 1000);
			status = this.getInstallStatus(alias, installResult.result.Id, sfdx, log);
			if ("SUCCESS" == status) {
				successfullyInstalled = true;
				break;
			}
			if ("ERROR" == status) {
				break;
			}
			counter += step;
		}
		return successfullyInstalled;
	},
	getInstallStatus(alias, request_id, sfdx, log) {
		var progressResult = sfdx.exec(this.checkInstallProgressCommand(alias, request_id));
		log.print(progressResult.result.Status);
		if (progressResult.result.message) {
			log.print(progressResult.result.message);
		}
		return progressResult.result.Status;
	},
	installPackageCommand: function(alias, package_id, package_pwd, package_options) {
		var command = `sfdx force:package:install -r -p ${package_id}`;
		command = command.concat(` -s ${package_options}`);
		command = command.concat(` -k ${package_pwd}`);
		command = command.concat(` --json`);
		return command;
	},
	checkInstallProgressCommand: function(alias, request_id) {
		return `sfdx force:package:install:report -u ${alias} -i ${request_id} --json`;
	}
};
