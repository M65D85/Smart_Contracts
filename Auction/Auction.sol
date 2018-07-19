pragma solidity ^0.4.16;

contract Auction {

    address beneficiery;
    uint highestBid;
    address highestBidder;

    uint auctionStart;
    uint biddingTime;

    mapping (address => uint) pendingReturns;

    bool ended;

    event HighestBidIncreased(address _highestBidder, uint amount);
    event AuctionEnded(address _winner, uint amount);

    function Auction(address _beneficiery, uint _biddingTime) public {
        beneficiery = _beneficiery;
        biddingTime = _biddingTime;
        auctionStart = now;
    }

    function bid(){
        if(now > auctionStart + biddingTime){
            throw;
        }

        if(msg.sender <= highesBid){
            throw;
        }

        if(highestBidder != 0){
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() {
        var amount = pendingReturns[msg.sender];
        pendingReturns[msg.sender] = 0;

        if(!msg.sender.send(amount)){
            throw;
        }
    }

    function auctionEnd() {
        if(now > auctionStart + biddingTime){
            throw;
        }
        if(ended){
            throw;
            AuctionEnded(highestBidder, highestBid);
        }

        if(!beneficiery.send(highestBid)){
            throw;
        }

        ended = true;

    }

    function () {
        throw;
    }

}