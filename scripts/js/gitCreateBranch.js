const util = require("./util/utils.js");
const gitUtil = require("./util/gitUtils.js");

var params = util.parseScriptArguments(process.argv.slice(), {
	branchType: "feature",
	defaultBranch: "development",
	remote: "origin",
	branchName: "name"
});

main(params)
	.then(result => util.print(result))
	.catch(error => util.print(error));

async function main(params) {
	return gitUtil.checkoutNewBranch(`${params.branchType}/${params.branchName}`, params.defaultBranch);
}
