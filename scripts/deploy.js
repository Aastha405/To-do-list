const hre = require("hardhat");

async function main() {
  const ToDoList = await hre.ethers.getContractFactory("ToDoList");
  const todo = await ToDoList.deploy();

  await todo.deployed();

  console.log("ToDoList deployed to:", todo.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
