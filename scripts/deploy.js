const hre = require("hardhat");

async function main() {
    const DegreeSystem = await hre.ethers.getContractFactory("DegreeSystem");
    const degreeSystem = await DegreeSystem.deploy();

    await degreeSystem.deployed();
    console.log(`DegreeSystem deployed to: ${degreeSystem.address}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
