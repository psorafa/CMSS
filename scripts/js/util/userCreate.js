module.exports = {
	createUserCommand: function(alias, profile, conf) {
		var log = require("./utils");
		var params = {
			alias: "cmss",
			conf: "config/user.json",
			profile: "System Administrator"
		};
		if (alias) {
			params["alias"] = alias;
		}
		if (profile) {
			params["profile"] = profile;
		}
		if (conf) {
			params["conf"] = conf;
		}
		log.print(`create ${profile} user..`);
		return `sfdx force:user:create --setalias ${alias}-${profile} --definitionfile ${conf} profileName=${profile} lastName=${profile} --json`;
	}
};
