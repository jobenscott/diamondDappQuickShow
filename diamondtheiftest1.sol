// Users will send .01 to "mine" diamonds, which will then become "steal-able" at 50%.
// All diamonds will always be listed as either "mine-able" or "steal-able".
// After a diamond is acquired(whether through mining or stealing), it will go on a (undecided) minute cooldown.
// (undecided) minute cooldown is to allow for a "Quick Sale". Incurs (undecided)% fees
// The other type of sale is a "forced sale". Which is made as a diamond splits reaches when it reaches maturity.
// Diamonds reach maturity after 7 steal attempts(not including mining). 
// The diamond splits so the user can sell with no additional fee for 90%.
// The other 10% goes to creating a new diamond for the same user.
// This new diamond is now level 2 has a 52.5% chance
// The only way to profit off 

pragma solidity ^0.4.19;

contract StealTheDiamond {

    event NewDiamond(uint diamondId, bool mature, bool level_mature, uint level);

    struct Diamond {
        bool mature;
        bool level_mature;
        uint level;
    }

    Diamond[] public diamonds;

    mapping (uint => address) public diamondToOwner;
    mapping (address => uint) ownerDiamondCount;
    uint public diamondMineCount;

    function _createDiamond() private {
        uint id = diamonds.push(Diamond(false, false, 1)) - 1;
        NewDiamond(id, false, false, 1);
        diamondMineCount++;
    }

    function _mineDiamond(uint _diamondId) private { // might be public

        // add diamond to user
        diamondToOwner[_diamondId] = msg.sender;
        ownerDiamondCount[msg.sender]++;
    }

    function mineDiamond(uint256 _diamondId)
        external
        payable
    {
        address current_owner = diamondToOwner[_diamondId].at('address');
        // may need if to check if owner is contract
        current_owner.transfer(msg.value);
        // around this transfer
        diamondToOwner[_diamondId] = msg.sender;
        ownerDiamondCount[msg.sender]++;


    }

    function stealDiamond(uint256 _diamondId)
        external
        payable
    {
        address current_owner = diamondToOwner[_diamondId].at('address');
        current_owner.transfer(msg.value);
        diamondToOwner[_diamondId] = msg.sender;
        ownerDiamondCount[msg.sender]++;
    }

  }















  
    // EVENTS
    // 1. user "mines" diamond
    // 2. user steals diamond
    // 3. user sells diamond
    // 4. when new diamond should be minted(static amount of time after a diamond is sold * (number of total diamonds in circulation / 100?)) 
    


    // NOTES
    // all diamonds sold prematurely need to be taxed enough to give
        // 1. the devs a good piece(not too much though)
        // 2. enough eth to produce at least 2-3 more diamonds

    // DEV FEES
    // devs fees will include(negotiable)
        // 1. 30% of all diamonds mined
        // 2. 30% of the all prematurely sold diamonds
        // 3. 2% of all split diamond withdrawls



