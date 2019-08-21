{"nest.sol":{"content":"pragma solidity 0.4.21;\r\n\r\nimport \"./Pausable.sol\";\r\nimport \"./SafeMath.sol\";\r\n\r\n\r\n\r\n// ----------------------------------------------------------------------------\r\n// ERC Token Standard #20 Interface\r\n// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\r\n// ----------------------------------------------------------------------------\r\ncontract ERC20Interface {\r\n    function totalSupply() public constant returns (uint);\r\n    function balanceOf(address tokenOwner) public constant returns (uint balance);\r\n    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\r\n    function transfer(address to, uint tokens) public returns (bool success);\r\n    function approve(address spender, uint tokens) public returns (bool success);\r\n    function transferFrom(address from, address to, uint tokens) public returns (bool success);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint tokens);\r\n    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\r\n}\r\n\r\n\r\n// ----------------------------------------------------------------------------\r\n// Contract function to receive approval and execute function in one call\r\n//\r\n// Borrowed from MiniMeToken\r\n// ----------------------------------------------------------------------------\r\ncontract ApproveAndCallFallBack {\r\n    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\r\n}\r\n\r\n\r\n// ----------------------------------------------------------------------------\r\n// ERC20 Token, with the addition of symbol, name and decimals and an\r\n// initial fixed supply\r\n// ----------------------------------------------------------------------------\r\ncontract HXMC is ERC20Interface, Pausable {\r\n    using SafeMath for uint;\r\n\r\n    string public symbol;\r\n    string public  name;\r\n    uint8 public decimals;\r\n    uint public _totalSupply;\r\n\r\n    mapping(address =\u003e uint) balances;\r\n    mapping(address =\u003e mapping(address =\u003e uint)) allowed;\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Constructor\r\n    // ------------------------------------------------------------------------\r\n    function HXMC() public {\r\n        symbol = \"HXMC\";\r\n        name = \"HXMC\";\r\n        decimals = 18;\r\n        _totalSupply = 900000000 * 10**uint(decimals);\r\n        balances[owner] = _totalSupply;\r\n        emit Transfer(address(0), owner, _totalSupply);\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Total supply\r\n    // ------------------------------------------------------------------------\r\n    function totalSupply() public constant returns (uint) {\r\n        return _totalSupply  - balances[address(0)];\r\n    }\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Get the token balance for account `tokenOwner`\r\n    // ------------------------------------------------------------------------\r\n    function balanceOf(address tokenOwner) public constant returns (uint balance) {\r\n        return balances[tokenOwner];\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Transfer the balance from token owner\u0027s account to `to` account\r\n    // - Owner\u0027s account must have sufficient balance to transfer\r\n    // - 0 value transfers are allowed\r\n    // ------------------------------------------------------------------------\r\n    function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {\r\n        balances[msg.sender] = balances[msg.sender].sub(tokens);\r\n        balances[to] = balances[to].add(tokens);\r\n        emit Transfer(msg.sender, to, tokens);\r\n        return true;\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Token owner can approve for `spender` to transferFrom(...) `tokens`\r\n    // from the token owner\u0027s account\r\n    //\r\n    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\r\n    // recommends that there are no checks for the approval double-spend attack\r\n    // as this should be implemented in user interfaces \r\n    // ------------------------------------------------------------------------\r\n    function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {\r\n        allowed[msg.sender][spender] = tokens;\r\n        emit Approval(msg.sender, spender, tokens);\r\n        return true;\r\n    }\r\n\r\n    function increaseApproval (address _spender, uint _addedValue) public whenNotPaused\r\n        returns (bool success) {\r\n        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\r\n        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\r\n        return true;\r\n    }\r\n\r\n    function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused\r\n        returns (bool success) {\r\n        uint oldValue = allowed[msg.sender][_spender];\r\n        if (_subtractedValue \u003e oldValue) {\r\n          allowed[msg.sender][_spender] = 0;\r\n        } else {\r\n          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\r\n        }\r\n        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\r\n        return true;\r\n    }\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Transfer `tokens` from the `from` account to the `to` account\r\n    // \r\n    // The calling account must already have sufficient tokens approve(...)-d\r\n    // for spending from the `from` account and\r\n    // - From account must have sufficient balance to transfer\r\n    // - Spender must have sufficient allowance to transfer\r\n    // - 0 value transfers are allowed\r\n    // ------------------------------------------------------------------------\r\n    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {\r\n        balances[from] = balances[from].sub(tokens);\r\n        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\r\n        balances[to] = balances[to].add(tokens);\r\n        emit Transfer(from, to, tokens);\r\n        return true;\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Returns the amount of tokens approved by the owner that can be\r\n    // transferred to the spender\u0027s account\r\n    // ------------------------------------------------------------------------\r\n    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\r\n        return allowed[tokenOwner][spender];\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Token owner can approve for `spender` to transferFrom(...) `tokens`\r\n    // from the token owner\u0027s account. The `spender` contract function\r\n    // `receiveApproval(...)` is then executed\r\n    // ------------------------------------------------------------------------\r\n    function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {\r\n        allowed[msg.sender][spender] = tokens;\r\n        emit Approval(msg.sender, spender, tokens);\r\n        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\r\n        return true;\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Don\u0027t accept ETH\r\n    // ------------------------------------------------------------------------\r\n    function () public payable {\r\n        revert();\r\n    }\r\n\r\n\r\n    // ------------------------------------------------------------------------\r\n    // Owner can transfer out any accidentally sent ERC20 tokens\r\n    // ------------------------------------------------------------------------\r\n    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\r\n        return ERC20Interface(tokenAddress).transfer(owner, tokens);\r\n    }\r\n}\r\n"},"Ownable.sol":{"content":"pragma solidity 0.4.21;\r\n\r\n// ----------------------------------------------------------------------------\r\n// Owned contract\r\n// ----------------------------------------------------------------------------\r\ncontract Ownable {\r\n    address public owner;\r\n    address public newOwner;\r\n\r\n    event OwnershipTransferred(address indexed _from, address indexed _to);\r\n\r\n    function Ownable() public {\r\n        owner = msg.sender;\r\n    }\r\n\r\n    modifier onlyOwner {\r\n        require(msg.sender == owner);\r\n        _;\r\n    }\r\n\r\n    function transferOwnership(address _newOwner) public onlyOwner {\r\n        newOwner = _newOwner;\r\n    }\r\n    function acceptOwnership() public {\r\n        require(msg.sender == newOwner);\r\n        emit OwnershipTransferred(owner, newOwner);\r\n        owner = newOwner;\r\n        newOwner = address(0);\r\n    }\r\n}"},"Pausable.sol":{"content":"pragma solidity 0.4.21;\r\n\r\n\r\nimport \u0027./Ownable.sol\u0027;\r\n\r\ncontract Pausable is Ownable {\r\n\tevent Pause();\r\n\tevent Unpause();\r\n\r\n\tbool public paused = false;\r\n\r\n\r\n\t/**\r\n\t * @dev modifier to allow actions only when the contract IS paused\r\n\t */\r\n\tmodifier whenNotPaused() {\r\n\t\trequire(!paused);\r\n\t\t_;\r\n\t}\r\n\r\n\t/**\r\n\t * @dev modifier to allow actions only when the contract IS NOT paused\r\n\t */\r\n\tmodifier whenPaused {\r\n\t\trequire(paused);\r\n\t\t_;\r\n\t}\r\n\r\n\t/**\r\n\t * @dev called by the owner to pause, triggers stopped state\r\n\t */\r\n\tfunction pause() onlyOwner whenNotPaused public returns (bool) {\r\n\t\tpaused = true;\r\n\t\temit Pause();\r\n\t\treturn true;\r\n\t}\r\n\r\n\t/**\r\n\t * @dev called by the owner to unpause, returns to normal state\r\n\t */\r\n\tfunction unpause() onlyOwner whenPaused public returns (bool) {\r\n\t\tpaused = false;\r\n\t\temit Unpause();\r\n\t\treturn true;\r\n\t}\r\n}"},"SafeMath.sol":{"content":"pragma solidity ^0.4.21;\r\n\r\n\r\n/**\r\n * @title SafeMath\r\n * @dev Math operations with safety checks that throw on error\r\n */\r\nlibrary SafeMath {\r\n\r\n  /**\r\n  * @dev Multiplies two numbers, throws on overflow.\r\n  */\r\n  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\r\n    if (a == 0) {\r\n      return 0;\r\n    }\r\n    c = a * b;\r\n    assert(c / a == b);\r\n    return c;\r\n  }\r\n\r\n  /**\r\n  * @dev Integer division of two numbers, truncating the quotient.\r\n  */\r\n  function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    // assert(b \u003e 0); // Solidity automatically throws when dividing by 0\r\n    // uint256 c = a / b;\r\n    // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n    return a / b;\r\n  }\r\n\r\n  /**\r\n  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\r\n  */\r\n  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    assert(b \u003c= a);\r\n    return a - b;\r\n  }\r\n\r\n  /**\r\n  * @dev Adds two numbers, throws on overflow.\r\n  */\r\n  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\r\n    c = a + b;\r\n    assert(c \u003e= a);\r\n    return c;\r\n  }\r\n}\r\n"}}