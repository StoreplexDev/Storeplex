pragma solidity ^0.4.16;

import './SafeMath.sol';

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
  function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }

}

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

 contract ERC20Interface {
     function balanceOf(address _owner) public constant returns (uint256 balance);
     function transfer(address _to, uint256 _value) public returns (bool success);
     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
     function approve(address _spender, uint256 _value) public returns (bool success);
     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
     function totalSupply() public constant returns (uint256 _totalSupply);
        
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
     event Burn(address indexed from, uint256 value);
    }

 contract PLEXToken is ERC20Interface {
     
     using SafeMath for uint256;
     
     string public constant symbol = "PLEX";
     string public constant name = "PLEX Token";
     uint8 public constant decimals = 2;
     uint256 _totalSupply;
     
     address public owner;
 
    mapping(address => uint256) balances;
    
    mapping(address => mapping (address => uint256)) allowed;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    modifier onlyOwner() {
         if (msg.sender != owner) {
             revert();
         }
         _;
     }
     
    function PLEXToken() public {
        owner = msg.sender;
        balances[owner] = _totalSupply;
    } 
    
    function totalSupply() public constant returns (uint256 balance) 
    {
        return _totalSupply;
    }
    
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _amount) public returns (bool success) {
        if (balances[msg.sender] >= _amount 
             && _amount > 0
             && balances[_to] + _amount > balances[_to]) {
             balances[msg.sender] = balances[msg.sender].sub(_amount);
             balances[_to] = balances[_to].add(_amount);
             Transfer(msg.sender, _to, _amount);
             return true;
         } else {
             return false;
         }
    }
    
    function transferFrom (
            address _from,
            address _to,
            uint256 _amount
        )   public returns (bool success) {
            if (balances[_from] >= _amount
             && allowed[_from][msg.sender] >= _amount
             && _amount > 0
             && balances[_to] + _amount > balances[_to]) {
             balances[_from] = balances[_from].sub(_amount);
             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
             balances[_to] = balances[_to].add(_amount);
             Transfer(_from, _to, _amount);
             return true;
         }  else {
             return false;
         }
    }
    
    function approve(address _spender, uint256 _amount) public returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
         Approval(msg.sender, _spender, _amount);
         return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
    }
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        _totalSupply -= _value;                      // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}
