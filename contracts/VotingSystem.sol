pragma solidity ^0.8.0;

contract VotingSystem {
    
    
    struct Topic {
        string name;
        string description;
        uint256[] votingIds;
        address[] voters;
        mapping (address => bool) votersChoiceMapping;
        mapping (address => bool) votedMapping;
        uint256 yesVotes;
        uint256 noVotes;
        bool active;
    }
    
    mapping (address => bool) public admins;
    mapping (uint256 => Topic) public topics;
    uint256 public numVotings;
    uint256 public numTopics;
    
    constructor() {
        admins[msg.sender] = true; // Contract creator is an admin by default
    }
    
    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can perform this action");
        _;
    }
    
    function addAdmin(address _admin) public onlyAdmin {
        admins[_admin] = true;
    }
    
    function removeAdmin(address _admin) public onlyAdmin {
        admins[_admin] = false;
    }
    
    function createTopic(string memory _name, string memory _description) public onlyAdmin returns (uint256){
        uint256 votingId = numVotings++;
        topics[votingId].name = _name;
        topics[votingId].description = _description;
        topics[votingId].active = true;
        return votingId;
    }
    
    function endTopic(uint256 _topicId) public onlyAdmin {
        Topic storage topic = topics[_topicId];
        require(topic.active, "Voting is not active");
        topic.active = false;
        // TODO: Add end topic actions
    }
    
    function vote(uint256 _topicId, bool _vote) public {
        Topic storage topic = topics[_topicId];
        require(topic.active, "Voting is not active");
        require(topic.votedMapping[msg.sender], "You have already voted in this voting");
        topic.votedMapping[msg.sender] = true;
        if (_vote) {
            topic.yesVotes++;
            topic.votersChoiceMapping[msg.sender] = true;
        } else {
            topic.noVotes++;
            topic.votersChoiceMapping[msg.sender] = false;
        }
    }

    function getTopicName(uint256 _topicId) public view returns (string memory) {
        Topic storage topic = topics[_topicId];
        return (topic.name);
    }

    function getTopicDescription(uint256 _topicId) public view returns (string memory) {
        Topic storage topic = topics[_topicId];
        return (topic.description);
    }
    
    function getTopicResult(uint256 _topicId) public view returns (uint256, uint256) {
        Topic storage topic = topics[_topicId];
        require(!topic.active, "Voting is still active");
        return (topic.yesVotes, topic.noVotes);
    }
    
    function getTopicVotingIds(uint256 _topicId) public view returns (uint256[] memory) {
        return topics[_topicId].votingIds;
    }
    
    function hasVoted(uint256 _topicId, address _voter) public view returns (bool) {
        Topic storage topic = topics[_topicId];
        return topic.votedMapping[_voter];
    }
    
    function getVote(uint256 _topicId, address _voter) public view returns (bool) {
        Topic storage topic = topics[_topicId];
        require(topic.votedMapping[_voter],  "The voter has not voted in this voting");
        return topic.votersChoiceMapping[_voter];
    }
}