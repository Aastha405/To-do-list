const contractAddress = "YOUR_CONTRACT_ADDRESS";
const abi = [
  {
    "inputs": [
      { "internalType": "string", "name": "_description", "type": "string" },
      { "internalType": "uint256", "name": "_expiration", "type": "uint256" },
      { "internalType": "enum ToDoList.Priority", "name": "_priority", "type": "uint8" }
    ],
    "name": "addTask",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  { "inputs": [], "name": "clearAllTasks", "outputs": [], "stateMutability": "nonpayable", "type": "function" },
  {
    "inputs": [{ "internalType": "uint256", "name": "_index", "type": "uint256" }],
    "name": "completeTask",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  { "inputs": [], "name": "getAllTasks", "outputs": [{ "components": [
    { "internalType": "string", "name": "description", "type": "string" },
    { "internalType": "bool", "name": "completed", "type": "bool" },
    { "internalType": "uint256", "name": "timestamp", "type": "uint256" },
    { "internalType": "uint256", "name": "expiration", "type": "uint256" },
    { "internalType": "enum ToDoList.Priority", "name": "priority", "type": "uint8" }
  ], "internalType": "struct ToDoList.Task[]", "name": "", "type": "tuple[]" }], "stateMutability": "view", "type": "function" },
  {
    "inputs": [],
    "name": "getExpiredTasks",
    "outputs": [{ "components": [
      { "internalType": "string", "name": "description", "type": "string" },
      { "internalType": "bool", "name": "completed", "type": "bool" },
      { "internalType": "uint256", "name": "timestamp", "type": "uint256" },
      { "internalType": "uint256", "name": "expiration", "type": "uint256" },
      { "internalType": "enum ToDoList.Priority", "name": "priority", "type": "uint8" }
    ], "internalType": "struct ToDoList.Task[]", "name": "", "type": "tuple[]" }],
    "stateMutability": "view", "type": "function"
  },
  {
    "inputs": [{ "internalType": "bool", "name": "_completed", "type": "bool" }],
    "name": "getTasksByStatus",
    "outputs": [{ "components": [
      { "internalType": "string", "name": "description", "type": "string" },
      { "internalType": "bool", "name": "completed", "type": "bool" },
      { "internalType": "uint256", "name": "timestamp", "type": "uint256" },
      { "internalType": "uint256", "name": "expiration", "type": "uint256" },
      { "internalType": "enum ToDoList.Priority", "name": "priority", "type": "uint8" }
    ], "internalType": "struct ToDoList.Task[]", "name": "", "type": "tuple[]" }],
    "stateMutability": "view", "type": "function"
  },
  {
    "inputs": [{ "internalType": "enum ToDoList.Priority", "name": "_priority", "type": "uint8" }],
    "name": "getTasksByPriority",
    "outputs": [{ "components": [
      { "internalType": "string", "name": "description", "type": "string" },
      { "internalType": "bool", "name": "completed", "type": "bool" },
      { "internalType": "uint256", "name": "timestamp", "type": "uint256" },
      { "internalType": "uint256", "name": "expiration", "type": "uint256" },
      { "internalType": "enum ToDoList.Priority", "name": "priority", "type": "uint8" }
    ], "internalType": "struct ToDoList.Task[]", "name": "", "type": "tuple[]" }],
    "stateMutability": "view", "type": "function"
  },
  { "inputs": [], "name": "getTaskCount", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" },
  {
    "inputs": [{ "internalType": "uint256", "name": "_index", "type": "uint256" }],
    "name": "isTaskExists",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "view", "type": "function"
  },
  { "inputs": [], "name": "markAllCompleted", "outputs": [], "stateMutability": "nonpayable", "type": "function" },
  { "inputs": [], "name": "markAllPending", "outputs": [], "stateMutability": "nonpayable", "type": "function" },
  {
    "inputs": [{ "internalType": "uint256", "name": "_index", "type": "uint256" }],
    "name": "toggleTask",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "uint256", "name": "_index", "type": "uint256" },
      { "internalType": "string", "name": "_newDescription", "type": "string" }
    ],
    "name": "updateTask",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "uint256", "name": "_index", "type": "uint256" }],
    "name": "deleteTask",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

let provider, signer, contract;

async function connectWallet() {
  if (window.ethereum) {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    contract = new ethers.Contract(contractAddress, abi, signer);
    alert("Wallet connected!");
    loadTasks();
  } else {
    alert("Please install MetaMask!");
  }
}

document.getElementById("connectButton").onclick = connectWallet;

document.getElementById("taskForm").onsubmit = async (e) => {
  e.preventDefault();
  const description = document.getElementById("description").value;
  const expiration = new Date(document.getElementById("expiration").value).getTime() / 1000;
  const priority = document.getElementById("priority").value;
  const tx = await contract.addTask(description, expiration, priority);
  await tx.wait();
  loadTasks();
};

async function loadTasks() {
  const tasks = await contract.getAllTasks();
  const list = document.getElementById("taskList");
  list.innerHTML = "";
  tasks.forEach((task, index) => {
    const div = document.createElement("div");
    div.className = `task ${task.completed ? "completed" : ""}`;
    div.innerHTML = `
      <strong>${task.description}</strong><br/>
      Status: ${task.completed ? "✅ Completed" : "🕒 Pending"} |
      Priority: ${["Low", "Medium", "High"][task.priority]} |
      Expiry: ${task.expiration > 0 ? new Date(task.expiration * 1000).toLocaleString() : "Never"}<br/>
      <button onclick="toggle(${index})">Toggle</button>
      <button onclick="complete(${index})">Complete</button>
      <button onclick="remove(${index})">Delete</button>
    `;
    list.appendChild(div);
  });
}

async function toggle(index) {
  const tx = await contract.toggleTask(index);
  await tx.wait();
  loadTasks();
}

async function complete(index) {
  const tx = await contract.completeTask(index);
  await tx.wait();
  loadTasks();
}

async function remove(index) {
  const tx = await contract.deleteTask(index);
  await tx.wait();
  loadTasks();
}
