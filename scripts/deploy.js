const { ethers } = require("hardhat");
const getTrustedForwarder = require("../utils/getTrustedForwarder");

async function main() {
  const trustedForwarder = getTrustedForwarder(network.name);
  console.log("TRUSTED FORWARDER", trustedForwarder);

  const splitsWrapperContract = await ethers.getContractFactory(
    "Polygon_GasFreeSplit"
  );
  const splits = await splitsWrapperContract.deploy(trustedForwarder);
  await splits.deployed();
  console.log("0xSplits Wrapper deployed to:", splits.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
