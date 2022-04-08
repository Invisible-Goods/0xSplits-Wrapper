const { ethers } = require("hardhat");

async function main() {
  const splitsWrapperContract = await ethers.getContractFactory(
    "Polygon_GasFreeSplit"
  );
  const splits = await splitsWrapperContract.deploy(
    "0x9399bb24dbb5c4b782c70c2969f58716ebbd6a3b"
  );
  await splits.deployed();
  console.log("0xSplits Wrapper deployed to:", splits.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
