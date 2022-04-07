const { ethers, upgrades } = require("hardhat");

async function main() {
  const BoxV2 = await ethers.getContractFactory("Polygon_GasFreeSplit");
  const box = await upgrades.upgradeProxy(
    "0x84512cD7d962C031F9717f188eF56d71d3A335D9",
    BoxV2
  );
  console.log("Box upgraded", box.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
