pragma solidity ^0.4.17;

contract Campaign {

    struct Request {
        string  description;
        uint  value;
        address  recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) haveVoted;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;

    mapping(address => bool) public approvers;
    uint public approversCount;


    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint _minimumContribution) public {
        manager = msg.sender;
        minimumContribution = _minimumContribution;
    }

    function contribute() public payable {
        require(msg.value >= minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string _description, uint _value, address _recipient) public restricted {
        Request memory newRequest = Request ({
            description: _description,
            value: _value,
            recipient: _recipient,
            complete: false,
            approvalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint _requestIndex) public {
        Request storage request = requests[_requestIndex];

        require(approvers[msg.sender]);
        require(!request.haveVoted[msg.sender]);

        request.haveVoted[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint _requestIndex) public restricted {
        Request storage request = requests[_requestIndex];

        require(!request.complete);
        require(request.approvalCount > (approversCount/2));

        request.recipient.transfer(request.value);
        request.complete = true;
    }

}
