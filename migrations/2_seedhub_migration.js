// artifacts in first line are saying "Hey give me compilations for SeedHub"
const SeedHub = artifacts.require("SeedHub");
// and then we pass it to the deployer object and say "deploy, dummie!"
// will also allow constructor variables from other contracts (address of e.g. inherited 
//contract, which we put in the function body i.e. SeedHub)
module.exports = function (deployer) {
  deployer.deploy(SeedHub);
};