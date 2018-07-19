pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    uint public amount;
    address public lastWinner;
    uint total;


    function Lottery() public {
        manager = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function enter() public payable {
        require(msg.value > .01 ether);
        amount = msg.value;
        players.push(msg.sender);
        total += amount;
    }

    function pickWinner() public restricted {
        uint randomNum = random();
        uint winner = randomNum % players.length;
        lastWinner = players[winner];
        players[winner].transfer(total);
        players = new address[](0);
    }

    function random() private view returns (uint) {
        return uint(keccak256(now, block.difficulty, players));
    }

    function getPlayers() public view returns (address[]){
        return players;
    }
}
