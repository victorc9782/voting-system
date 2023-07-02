// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

async function votingSystemSetup(){
  const VotingSystem = await ethers.getContractFactory("VotingSystem");
  const votingSystem = await VotingSystem.deploy();
  await votingSystem.deployed();
  return votingSystem;
}

async function createTopic(votingSystem, topic, description){
  const newTopic = await votingSystem.createTopic(topic, description);
  return newTopic;
}
describe("VotingSystem", function () {
  it("test create voting", async function () {
    const votingSystem = await votingSystemSetup();

    const topic = "Testing Topic";
    const description = "Testing Description"
    const newVoting = (await createTopic(votingSystem, topic, description)).value;
    expect(newVoting).to.equal(0);

    const createdTopic = await votingSystem.getTopicName(newVoting);
    expect(createdTopic).to.equal(topic);
    
    const createdDescription = await votingSystem.getTopicDescription(newVoting);
    expect(createdDescription).to.equal(description);
  });
});