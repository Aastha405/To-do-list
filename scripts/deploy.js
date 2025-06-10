// scripts/deploy.js

const hre = require("hardhat");

async function main() {
  // Compile contracts (optional in Hardhat >=2.0, but good for clarity)
  await hre.run('compile');

  // Get the contract factory
  const ToDoList = await hre.ethers.getContractFactory("ToDoList");

  // Deploy the contract
  const todoList = await ToDoList.deploy();

  // Wait for deployment to complete
  await todoList.deployed();

  // Log the deployed address
  console.log("✅ ToDoList contract deployed to:", todoList.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
