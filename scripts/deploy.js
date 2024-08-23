
const { ethers } = require("hardhat");

async function main() {

  const lock = await ethers.deployContract("Save2DraftContract");

  await lock.waitForDeployment();

  console.log(
   `deployed to ${lock.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});