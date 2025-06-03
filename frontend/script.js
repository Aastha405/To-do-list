const contractAddress = "YOUR_CONTRACT_ADDRESS_HERE";
const contractABI = [/* ABI GOES HERE */];

let contract, signer;

document.getElementById("connectButton").onclick = async () => {
  if (window.ethereum) {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    contract = new ethers.Contract(contractAddress, contractABI, signer);
    alert("Wallet connected!");
    loadTasks();
  } else {
    alert("Install MetaMask to use this dApp!");
  }
};

document.getElementById("taskForm").onsubmit = async (e) => {
  e.preventDefault();
  const desc = document.getElementById("description").value;
  const exp = Math.floor(new Date(document.getElementById("expiration").value).getTime() / 1000);
  const priority = parseInt(document.getElementById("priority").value);

  try {
    const tx = await contract.addTask(desc, exp, priority);
    await tx.wait();
    loadTasks();
  } catch (err) {
    alert("Error adding task: " + err.message);
  }
};

async function loadTasks() {
  if (!contract) return;
  const taskCount = await contract.getMyTaskCount();
  const list = document.getElementById("taskList");
  list.innerHTML = "";

  for (let i = 0; i < taskCount; i++) {
    const task = await contract.getMyTask(i);
    const div = document.createElement("div");
    div.className = "task";
    if (task.completed) div.classList.add("completed");

    div.innerHTML = `
      <strong>${task.description}</strong><br/>
      Exp: ${new Date(task.expiration * 1000).toLocaleString()} | 
      Priority: ${["Low", "Medium", "High"][task.priority - 1]}<br/>
      <button onclick="toggleTask(${i})">${task.completed ? "Mark Incomplete" : "Mark Completed"}</button>
    `;
    list.appendChild(div);
  }
}

async function toggleTask(index) {
  const tx = await contract.toggleTask(index);
  await tx.wait();
  loadTasks();
}
