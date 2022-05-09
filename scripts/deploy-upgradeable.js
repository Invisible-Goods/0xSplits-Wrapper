const { ethers, upgrades, network } = require("hardhat");
const getTrustedForwarder = require("../utils/getTrustedForwarder");

async function main() {
  const trustedForwarder = getTrustedForwarder(network.name);
  console.log("TRUSTED FORWARDER", trustedForwarder);

  const factory = await ethers.getContractFactory(
    "Polygon_GasFreeSplit_Upgradeable"
  );
  const contract = await upgrades.deployProxy(factory, [trustedForwarder], {
    initializer: "initialize",
  });
  await contract.deployed();
  console.log("0xSplits Wrapper deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
