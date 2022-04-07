const { ethers, upgrades } = require("hardhat");

async function main() {
  const Box = await ethers.getContractFactory("Polygon_GasFreeSplit");
  const box = await upgrades.deployProxy(
    Box,
    ["0x9399bb24dbb5c4b782c70c2969f58716ebbd6a3b"],
    {
      initializer: "initialize",
    }
  );
  await box.deployed();
  console.log("Box deployed to:", box.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
