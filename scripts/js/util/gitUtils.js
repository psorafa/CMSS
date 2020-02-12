module.exports = {
	checkoutNewBranch: async function(branchName, branchFromName, remote) {
		const util = require("./utils.js");
		const git = require("simple-git/promise")();
		var isClean = await this.isClean(git, util);
		if (!isClean) {
			util.print("Working dir not clear. Stopping");
			return;
		}

		const pull = await git.pull(remote, branchFromName, { "--rebase": "true" });
		util.print(pull);

		return this.checkoutBranch(branchName, branchFromName, git, util);
	},
	isClean: async function(git_object, util_object) {
		const git = git_object ? git_object : require("simple-git/promise")();
		const util = util_object ? util_object : require("simple-git/promise")();
		const status = await git.status();
		//util.printJson(status);
		util.print(status.isClean());
		return status.isClean();
	},
	checkoutBranch: async function(branchName, branchFromName, git_object, util_object) {
		const git = git_object ? git_object : require("simple-git/promise")();
		const util = util_object ? util_object : require("simple-git/promise")();
		const checkout = await git.checkoutBranch(branchName, branchFromName);
		console.log(checkout);
		util.print(`Git: Checked out ${branchName}`);
		return true;
	}
};
