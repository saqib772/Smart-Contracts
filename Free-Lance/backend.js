const express = require("express");
const bodyParser = require("body-parser");
const Web3 = require("web3");
const app = express();
const web3 = new Web3("<YOUR_RPC_PROVIDER>"); // Replace with your own Ethereum RPC provider

// Import and instantiate the smart contract ABI and contract address
const abi = require("<CONTRACT_ABI_PATH>");
const contractAddress = "<CONTRACT_ADDRESS>";
const contract = new web3.eth.Contract(abi, contractAddress);

// Middleware for request body parsing
app.use(bodyParser.json());

// Register as a freelancer
app.post("/freelancer/register", async (req, res) => {
    try {
        const { ratePerHour } = req.body;
        // Input validation
        if (!ratePerHour || typeof ratePerHour !== "number" || ratePerHour <= 0) {
            return res.status(400).json({ error: "Invalid rate per hour" });
        }

        // Register the freelancer on the smart contract
        const accounts = await web3.eth.getAccounts();
        await contract.methods.registerFreelancer(ratePerHour).send({ from: accounts[0] });
        res.json({ message: "Freelancer registered successfully" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Create a job
app.post("/job/create", async (req, res) => {
    try {
        const { freelancerAddress, totalAmount, hoursWorked } = req.body;
        // Input validation
        if (!freelancerAddress || !web3.utils.isAddress(freelancerAddress)) {
            return res.status(400).json({ error: "Invalid freelancer address" });
        }
        if (!totalAmount || typeof totalAmount !== "number" || totalAmount <= 0) {
            return res.status(400).json({ error: "Invalid total amount" });
        }
        if (!hoursWorked || typeof hoursWorked !== "number" || hoursWorked <= 0) {
            return res.status(400).json({ error: "Invalid hours worked" });
        }

        // Create a job on the smart contract
        const accounts = await web3.eth.getAccounts();
        await contract.methods.createJob(freelancerAddress, totalAmount, hoursWorked).send({ from: accounts[0] });
        res.json({ message: "Job created successfully" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Complete a job
app.post("/job/complete", async (req, res) => {
    try {
        const { jobIndex, hoursWorked } = req.body;
        // Input validation
        if (!jobIndex || typeof jobIndex !== "number" || jobIndex < 0) {
            return res.status(400).json({ error: "Invalid job index" });
        }
        if (!hoursWorked || typeof hoursWorked !== "number" || hoursWorked <= 0) {
            return res.status(400).json({ error: "Invalid hours worked" });
        }

        // Complete the job on the smart contract
        const accounts = await web3.eth.getAccounts();
        await contract.methods.completeJob(jobIndex, hoursWorked).send({ from: accounts[0] });
        res.json({ message: "Job completed successfully" });
    } catch (error) 
    {
              console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Get list of available jobs
app.get("/jobs", async (req, res) => {
    try {
        // Get the list of available jobs from the smart contract
        const jobs = await contract.methods.getAvailableJobs().call();
        res.json({ jobs });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Get list of jobs for a specific freelancer
app.get("/freelancer/jobs/:freelancerAddress", async (req, res) => {
    try {
        const { freelancerAddress } = req.params;
        // Input validation
        if (!freelancerAddress || !web3.utils.isAddress(freelancerAddress)) {
            return res.status(400).json({ error: "Invalid freelancer address" });
        }

        // Get the list of jobs for the specific freelancer from the smart contract
        const jobs = await contract.methods.getJobsByFreelancer(freelancerAddress).call();
        res.json({ jobs });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Handle not found routes
app.use((req, res) => {
    res.status(404).json({ error: "Not found" });
});

// Handle errors
app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
});

// Start the server
const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});

       
