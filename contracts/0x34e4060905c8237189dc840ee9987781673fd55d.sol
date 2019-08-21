{"ERC20.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./IERC20.sol\";\nimport \"./SafeMath.sol\";\n\n/**\n * @title Standard ERC20 token\n *\n * @dev Implementation of the basic standard token.\n * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n * Originally based on code by FirstBlood:\n * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n *\n * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n * all accounts just by listening to said events. Note that this isn\u0027t required by the specification, and other\n * compliant implementations may not do it.\n */\ncontract ERC20 is IERC20 {\n    using SafeMath for uint256;\n\n    mapping (address =\u003e uint256) private _balances;\n\n    mapping (address =\u003e mapping (address =\u003e uint256)) private _allowed;\n\n    uint256 private _totalSupply;\n\n    /**\n    * @dev Total number of tokens in existence\n    */\n    function totalSupply() public view returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n    * @dev Gets the balance of the specified address.\n    * @param owner The address to query the balance of.\n    * @return An uint256 representing the amount owned by the passed address.\n    */\n    function balanceOf(address owner) public view returns (uint256) {\n        return _balances[owner];\n    }\n\n    /**\n     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n     * @param owner address The address which owns the funds.\n     * @param spender address The address which will spend the funds.\n     * @return A uint256 specifying the amount of tokens still available for the spender.\n     */\n    function allowance(address owner, address spender) public view returns (uint256) {\n        return _allowed[owner][spender];\n    }\n\n    /**\n    * @dev Transfer token for a specified address\n    * @param to The address to transfer to.\n    * @param value The amount to be transferred.\n    */\n    function transfer(address to, uint256 value) public returns (bool) {\n        _transfer(msg.sender, to, value);\n        return true;\n    }\n\n    /**\n     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n     * race condition is to first reduce the spender\u0027s allowance to 0 and set the desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     * @param spender The address which will spend the funds.\n     * @param value The amount of tokens to be spent.\n     */\n    function approve(address spender, uint256 value) public returns (bool) {\n        require(spender != address(0));\n\n        _allowed[msg.sender][spender] = value;\n        emit Approval(msg.sender, spender, value);\n        return true;\n    }\n\n    /**\n     * @dev Transfer tokens from one address to another.\n     * Note that while this function emits an Approval event, this is not required as per the specification,\n     * and other compliant implementations may not emit the event.\n     * @param from address The address which you want to send tokens from\n     * @param to address The address which you want to transfer to\n     * @param value uint256 the amount of tokens to be transferred\n     */\n    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n        _transfer(from, to, value);\n        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n        return true;\n    }\n\n    /**\n     * @dev Increase the amount of tokens that an owner allowed to a spender.\n     * approve should be called when allowed_[_spender] == 0. To increment\n     * allowed value is better to use this function to avoid 2 calls (and wait until\n     * the first transaction is mined)\n     * From MonolithDAO Token.sol\n     * Emits an Approval event.\n     * @param spender The address which will spend the funds.\n     * @param addedValue The amount of tokens to increase the allowance by.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n        require(spender != address(0));\n\n        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n        return true;\n    }\n\n    /**\n     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n     * approve should be called when allowed_[_spender] == 0. To decrement\n     * allowed value is better to use this function to avoid 2 calls (and wait until\n     * the first transaction is mined)\n     * From MonolithDAO Token.sol\n     * Emits an Approval event.\n     * @param spender The address which will spend the funds.\n     * @param subtractedValue The amount of tokens to decrease the allowance by.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n        require(spender != address(0));\n\n        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n        return true;\n    }\n\n    /**\n    * @dev Transfer token for a specified addresses\n    * @param from The address to transfer from.\n    * @param to The address to transfer to.\n    * @param value The amount to be transferred.\n    */\n    function _transfer(address from, address to, uint256 value) internal {\n        require(to != address(0));\n\n        _balances[from] = _balances[from].sub(value);\n        _balances[to] = _balances[to].add(value);\n        emit Transfer(from, to, value);\n    }\n\n    /**\n     * @dev Internal function that mints an amount of the token and assigns it to\n     * an account. This encapsulates the modification of balances such that the\n     * proper events are emitted.\n     * @param account The account that will receive the created tokens.\n     * @param value The amount that will be created.\n     */\n    function _mint(address account, uint256 value) internal {\n        require(account != address(0));\n\n        _totalSupply = _totalSupply.add(value);\n        _balances[account] = _balances[account].add(value);\n        emit Transfer(address(0), account, value);\n    }\n\n    /**\n     * @dev Internal function that burns an amount of the token of a given\n     * account.\n     * @param account The account whose tokens will be burnt.\n     * @param value The amount that will be burnt.\n     */\n    function _burn(address account, uint256 value) internal {\n        require(account != address(0));\n\n        _totalSupply = _totalSupply.sub(value);\n        _balances[account] = _balances[account].sub(value);\n        emit Transfer(account, address(0), value);\n    }\n\n    /**\n     * @dev Internal function that burns an amount of the token of a given\n     * account, deducting from the sender\u0027s allowance for said account. Uses the\n     * internal burn function.\n     * Emits an Approval event (reflecting the reduced allowance).\n     * @param account The account whose tokens will be burnt.\n     * @param value The amount that will be burnt.\n     */\n    function _burnFrom(address account, uint256 value) internal {\n        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n        _burn(account, value);\n        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n    }\n}\n"},"ERC20Burnable.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./ERC20.sol\";\n\n/**\n * @title Burnable Token\n * @dev Token that can be irreversibly burned (destroyed).\n */\ncontract ERC20Burnable is ERC20 {\n    /**\n     * @dev Burns a specific amount of tokens.\n     * @param value The amount of token to be burned.\n     */\n    function burn(uint256 value) public {\n        _burn(msg.sender, value);\n    }\n\n    /**\n     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n     * @param from address The address which you want to send tokens from\n     * @param value uint256 The amount of token to be burned\n     */\n    function burnFrom(address from, uint256 value) public {\n        _burnFrom(from, value);\n    }\n}\n"},"ERC20Detailed.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./IERC20.sol\";\n\n/**\n * @title ERC20Detailed token\n * @dev The decimals are only for visualization purposes.\n * All the operations are done using the smallest and indivisible token unit,\n * just as on Ethereum all the operations are done in wei.\n */\ncontract ERC20Detailed is IERC20 {\n    string private _name;\n    string private _symbol;\n    uint8 private _decimals;\n\n    constructor (string memory name, string memory symbol, uint8 decimals) public {\n        _name = name;\n        _symbol = symbol;\n        _decimals = decimals;\n    }\n\n    /**\n     * @return the name of the token.\n     */\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @return the symbol of the token.\n     */\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @return the number of decimals of the token.\n     */\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n}\n"},"ERC20Pausable.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./ERC20.sol\";\nimport \"./Pausable.sol\";\n\n/**\n * @title Pausable token\n * @dev ERC20 modified with pausable transfers.\n **/\ncontract ERC20Pausable is ERC20, Pausable {\n    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n        return super.transfer(to, value);\n    }\n\n    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n        return super.transferFrom(from, to, value);\n    }\n\n    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n        return super.approve(spender, value);\n    }\n\n    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {\n        return super.increaseAllowance(spender, addedValue);\n    }\n\n    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {\n        return super.decreaseAllowance(spender, subtractedValue);\n    }\n}\n"},"GGCToken.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./Owned.sol\";\nimport \"./ERC20Detailed.sol\";\nimport \"./ERC20Pausable.sol\";\nimport \"./ERC20Burnable.sol\";\n\n\ncontract GGCToken is ERC20Detailed, ERC20Pausable, ERC20Burnable, Owned {\n\n    /**\n     * The token constructor. Invoked when the contract\n     * is deployed. Initializes the token name, symbol\n     * and number of decimals in the Detailed contract.\n     * Also mints the initial amount of tokens specified\n     * as a parameter. The deploying address is set as\n     * the owner, minter and pauser.\n     *\n     * @param initialSupply - The initial amount of\n     *                        tokens to be minted\n     */\n    constructor(uint256 initialSupply)\n    ERC20Detailed(\"GG Coin\", \"GGC\", 18)\n    public {\n        // Mint the initial token\n        _mint(msg.sender, initialSupply);\n    }\n\n    /**\n     * Overrides the default behavior of the transfer\n     * function defined in ERC20Pausable by requiring\n     * that the contract is either unpaused or being\n     * invoked by the contract owner\n     *\n     * @param to - The receiving address\n     * @param value - The amount of tokens to be sent\n     * @return bool - A success indicator\n     */\n    function transfer(address to, uint256 value)\n    public\n    returns (bool) {\n    \n        require(!paused() || isOwner(), \"Must either be unpaused or invoked by owner\");\n\n        // Transfer the tokens\n        _transfer(msg.sender, to, value);\n        return true;\n    }\n\n    /**\n     * A function used by the owner of the contract to\n     * make more than one token transfer in a single\n     * transaction. Used to speed-up the process of\n     * distributing tokens. Fails if not invoked by\n     * the owner of the contract\n     *\n     * @param recipients - A list of receiving addresses\n     * @param values - A list of amounts to be sent\n     */\n    function bulkTransfer(address[] memory recipients, uint256[] memory values)\n    public\n    onlyOwner {\n        \n        // Make sure there are as many recipients as values to transfer\n        require(recipients.length == values.length, \"There must be exactly one value for each recipient\");\n\n        // Go through each recipient\n        for(uint256 rxIndex = 0; rxIndex\u003crecipients.length; rxIndex++) {\n\n            // Transfer the respective amount to the current recipient\n            _transfer(msg.sender, recipients[rxIndex], values[rxIndex]);\n        }\n    }\n\n    /**\n     * A function used by the owner of the contract to\n     * make more than one token transfer in a single\n     * transaction. Unlike the \"bulkTransfer()\" function,\n     * this function transfers the same value to all recipients\n     *\n     * @param recipients - A list of receiving addresses\n     * @param value - The value to be transferred\n     */\n    function bulkTransferValue(address[] memory recipients, uint256 value)\n    public\n    onlyOwner {\n        \n        // Go through each recipient\n        for(uint256 rxIndex = 0; rxIndex\u003crecipients.length; rxIndex++) {\n\n            // Transfer the respective amount to the current recipient\n            _transfer(msg.sender, recipients[rxIndex], value);\n        }\n    }\n\n   \n    /**\n     * Used by the owner to remove pausers. By default,\n     * the ERC20Pausable contract allows pausers to\n     * renounce their position, but does not give the\n     * owner the ability to remove rogue pausers\n     *\n     * @param pauser - The address of the pauser\n     *                 to be removed\n     */\n    function removePauser(address pauser)\n    public\n    onlyOwner {\n        \n        // Remove the requested pauser\n        _removePauser(pauser);\n    }\n\n    /**\n     * Override the default ownership acceptance\n     * operation by adding the new owner\n     * as a pauser after executing the default\n     * operation\n     */\n    function acceptOwnership()\n    public {\n\n        // Remove the current owner as pauser\n        if(isPauser(_owner))\n            _removePauser(_owner);\n\n        // Make the new owner a pauser\n        if(!isPauser(msg.sender))\n            _addPauser(msg.sender);\n\n        // Call the default implementation\n        super.acceptOwnership();\n    }\n}"},"IERC20.sol":{"content":"pragma solidity ^0.5.0;\n\n/**\n * @title ERC20 interface\n * @dev see https://github.com/ethereum/EIPs/issues/20\n */\ninterface IERC20 {\n    function transfer(address to, uint256 value) external returns (bool);\n\n    function approve(address spender, uint256 value) external returns (bool);\n\n    function transferFrom(address from, address to, uint256 value) external returns (bool);\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address who) external view returns (uint256);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"},"Owned.sol":{"content":"pragma solidity ^0.5.0;\n\ncontract Owned {\n\n    // Holds the address of the owner of the contract\n    // who is able to perform contract management operations\n    address internal _owner;\n\n    // Holds the address of the invited party to become\n    // the new contract owner. This is switched back to\n    // address(0) once the new owner accepts.\n    address internal _newOwner;\n    \n\n    // An event emitted when the ownership is successfully\n    // transferred to the new owner\n    event OwnershipTransferred(address indexed _from, address indexed _to);\n\n    // Function modifier for functions accessable\n    // only by the owner of the contract\n    modifier onlyOwner {\n\n        require(msg.sender == _owner, \"Only the contract owner can call this function\");\n        _;\n    }\n\n\n    /**\n     * Constructor of the contract. Initializes the owner\n     * address as the address of the contract creator\n     */\n    constructor() \n    public {\n        \n        _owner = msg.sender;\n        _newOwner = address(0);\n    }\n\n    /**\n     * Invites another party to become the new owner of\n     * the contract. Current owner is still in charge until\n     * the new owner accepts the incitation. Current owner \n     * can revoke the invitation by calling this function\n     * again with address(0), assuming it has not been accepted\n     *\n     * @param newOwner - The address of the new owner\n     */\n    function transferOwnership(address newOwner) \n    public \n    onlyOwner {\n\n        _newOwner = newOwner;\n    }\n\n    /**\n     * Invoked by the invited party to accept the ownership\n     * invitation. Must be called from the address stored\n     * in newOwner. Once this call succeeds, the owner is changed\n     * and an OwnershipTransferred event is emitted\n     */\n    function acceptOwnership() \n    public {\n\n        require(msg.sender == _newOwner, \"This function can be called only by the new owner address\");\n        \n        emit OwnershipTransferred(_owner, _newOwner);\n\n        _owner = _newOwner;\n        _newOwner = address(0);\n    }\n\n    /**\n     * A constant function used to check if the if the\n     * caller is the owner of the contract\n     *\n     * @return bool - True if \u0027msg.sender\u0027 is the owner\n     */\n    function isOwner() \n    public view \n    returns (bool) {\n\n        return msg.sender == _owner;\n    }\n\n    /**\n     * A constant function used to get the address of\n     * the contract owner\n     *\n     * @return address - The address of the owner.\n     */\n    function owner() \n    public view \n    returns (address) {\n        return _owner;\n    }\n}\n"},"Pausable.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./PauserRole.sol\";\n\n/**\n * @title Pausable\n * @dev Base contract which allows children to implement an emergency stop mechanism.\n */\ncontract Pausable is PauserRole {\n    event Paused(address account);\n    event Unpaused(address account);\n\n    bool private _paused;\n\n    constructor () internal {\n        _paused = false;\n    }\n\n    /**\n     * @return true if the contract is paused, false otherwise.\n     */\n    function paused() public view returns (bool) {\n        return _paused;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is not paused.\n     */\n    modifier whenNotPaused() {\n        require(!_paused);\n        _;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is paused.\n     */\n    modifier whenPaused() {\n        require(_paused);\n        _;\n    }\n\n    /**\n     * @dev called by the owner to pause, triggers stopped state\n     */\n    function pause() public onlyPauser whenNotPaused {\n        _paused = true;\n        emit Paused(msg.sender);\n    }\n\n    /**\n     * @dev called by the owner to unpause, returns to normal state\n     */\n    function unpause() public onlyPauser whenPaused {\n        _paused = false;\n        emit Unpaused(msg.sender);\n    }\n}\n"},"PauserRole.sol":{"content":"pragma solidity ^0.5.0;\n\nimport \"./Roles.sol\";\n\ncontract PauserRole {\n    using Roles for Roles.Role;\n\n    event PauserAdded(address indexed account);\n    event PauserRemoved(address indexed account);\n\n    Roles.Role private _pausers;\n\n    constructor () internal {\n        _addPauser(msg.sender);\n    }\n\n    modifier onlyPauser() {\n        require(isPauser(msg.sender));\n        _;\n    }\n\n    function isPauser(address account) public view returns (bool) {\n        return _pausers.has(account);\n    }\n\n    function addPauser(address account) public onlyPauser {\n        _addPauser(account);\n    }\n\n    function renouncePauser() public {\n        _removePauser(msg.sender);\n    }\n\n    function _addPauser(address account) internal {\n        _pausers.add(account);\n        emit PauserAdded(account);\n    }\n\n    function _removePauser(address account) internal {\n        _pausers.remove(account);\n        emit PauserRemoved(account);\n    }\n}\n"},"Roles.sol":{"content":"pragma solidity ^0.5.0;\n\n/**\n * @title Roles\n * @dev Library for managing addresses assigned to a Role.\n */\nlibrary Roles {\n    struct Role {\n        mapping (address =\u003e bool) bearer;\n    }\n\n    /**\n     * @dev give an account access to this role\n     */\n    function add(Role storage role, address account) internal {\n        require(account != address(0));\n        require(!has(role, account));\n\n        role.bearer[account] = true;\n    }\n\n    /**\n     * @dev remove an account\u0027s access to this role\n     */\n    function remove(Role storage role, address account) internal {\n        require(account != address(0));\n        require(has(role, account));\n\n        role.bearer[account] = false;\n    }\n\n    /**\n     * @dev check if an account has this role\n     * @return bool\n     */\n    function has(Role storage role, address account) internal view returns (bool) {\n        require(account != address(0));\n        return role.bearer[account];\n    }\n}\n"},"SafeMath.sol":{"content":"pragma solidity ^0.5.0;\n\n/**\n * @title SafeMath\n * @dev Unsigned math operations with safety checks that revert on error\n */\nlibrary SafeMath {\n    /**\n    * @dev Multiplies two unsigned integers, reverts on overflow.\n    */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\n        // benefit is lost if \u0027b\u0027 is also tested.\n        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b);\n\n        return c;\n    }\n\n    /**\n    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n    */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Solidity only automatically asserts when dividing by 0\n        require(b \u003e 0);\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\n\n        return c;\n    }\n\n    /**\n    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n    */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        require(b \u003c= a);\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    /**\n    * @dev Adds two unsigned integers, reverts on overflow.\n    */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c \u003e= a);\n\n        return c;\n    }\n\n    /**\n    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n    * reverts when dividing by zero.\n    */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        require(b != 0);\n        return a % b;\n    }\n}\n"}}