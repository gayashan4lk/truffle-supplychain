const erc20Token = artifacts.require('erc20Token');
const SupplyChain = artifacts.require('SupplyChain');

module.exports = function (deployer) {
	deployer.deploy(erc20Token, 10000, 'TotalSem Token', 18, 'TotalSem');
	deployer.deploy(SupplyChain);
};
