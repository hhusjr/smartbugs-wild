{"Ownable.sol":{"content":"pragma solidity \u003e=0.4.21 \u003c0.6.0;\n\n\n/**\n * @title Ownable\n * @dev The Ownable contract has an owner address, and provides basic authorization control\n * functions, this simplifies the implementation of \"user permissions\". This adds two-phase\n * ownership control to OpenZeppelin\u0027s Ownable class. In this model, the original owner\n * designates a new owner but does not actually transfer ownership. The new owner then accepts\n * ownership and completes the transfer.\n */\ncontract Ownable {\n    address _owner;\n\n    modifier onlyOwner() {\n        require(isOwner(msg.sender), \"OwnerRole: caller does not have the Owner role\");\n        _;\n    }\n\n    function isOwner(address account) public view returns (bool) {\n        return account == _owner;\n    }\n}\n"},"SafeMath.sol":{"content":"pragma solidity ^0.4.24;\n\n\n/**\n * @title SafeMath\n * @dev Math operations with safety checks that throw on error\n */\nlibrary SafeMath {\n\n    /**\n    * @dev Multiplies two numbers, throws on overflow.\n    */\n    function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n        // Gas optimization: this is cheaper than asserting \u0027a\u0027 not being zero, but the\n        // benefit is lost if \u0027b\u0027 is also tested.\n        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n        if (_a == 0) {\n            return 0;\n        }\n\n        c = _a * _b;\n        assert(c / _a == _b);\n        return c;\n    }\n\n    /**\n    * @dev Integer division of two numbers, truncating the quotient.\n    */\n    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n        // assert(_b \u003e 0); // Solidity automatically throws when dividing by 0\n        // uint256 c = _a / _b;\n        // assert(_a == _b * c + _a % _b); // There is no case in which this doesn\u0027t hold\n        return _a / _b;\n    }\n\n    /**\n    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n    */\n    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n        assert(_b \u003c= _a);\n        return _a - _b;\n    }\n\n    /**\n    * @dev Adds two numbers, throws on overflow.\n    */\n    function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n        c = _a + _b;\n        assert(c \u003e= _a);\n        return c;\n    }\n}\n"},"TokenStorage.sol":{"content":"pragma solidity \u003e=0.4.21 \u003c0.6.0;\n\nimport \"./SafeMath.sol\";\nimport \u0027./Ownable.sol\u0027;\n\n/**\n* @title TokenStorage\n*/\ncontract TokenStorage  is Ownable{\n    using SafeMath for uint256;\n\n    //    mapping (address =\u003e bool) internal _allowedAccess;\n\n    // Access Modifier for Storage contract\n    address internal _registryContract;\n\n    constructor() public {\n        _owner = msg.sender;\n        _totalSupply = 1000000000 * 10 ** 18;\n        _balances[_owner] = _totalSupply;\n    }\n\n    function setProxyContractAndVersionOneDeligatee(address registryContract) onlyOwner public{\n        require(registryContract != address(0), \"InvalidAddress: invalid address passed for proxy contract\");\n        _registryContract = registryContract;\n    }\n\n    function getRegistryContract() view public returns(address){\n        return _registryContract;\n    }\n\n    //    function addDeligateContract(address upgradedDeligatee) public{\n    //        require(msg.sender == _registryContract, \"AccessDenied: only registry contract allowed access\");\n    //        _allowedAccess[upgradedDeligatee] = true;\n    //    }\n\n    modifier onlyAllowedAccess() {\n        require(msg.sender == _registryContract, \"AccessDenied: This address is not allowed to access the storage\");\n        _;\n    }\n\n    // Allowances with its Getter and Setter\n    mapping (address =\u003e mapping (address =\u003e uint256)) internal _allowances;\n\n    function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyAllowedAccess {\n        _allowances[_tokenHolder][_spender] = _value;\n    }\n\n    function getAllowance(address _tokenHolder, address _spender) public view onlyAllowedAccess returns(uint256){\n        return _allowances[_tokenHolder][_spender];\n    }\n\n\n    // Balances with its Getter and Setter\n    mapping (address =\u003e uint256) internal _balances;\n    function addBalance(address _addr, uint256 _value) public onlyAllowedAccess {\n        _balances[_addr] = _balances[_addr].add(_value);\n    }\n\n    function subBalance(address _addr, uint256 _value) public onlyAllowedAccess {\n        _balances[_addr] = _balances[_addr].sub(_value);\n    }\n\n    function setBalance(address _addr, uint256 _value) public onlyAllowedAccess {\n        _balances[_addr] = _value;\n    }\n\n    function getBalance(address _addr) public view onlyAllowedAccess returns(uint256){\n        return _balances[_addr];\n    }\n\n    // Total Supply with Getter and Setter\n    uint256 internal _totalSupply = 0;\n\n    function addTotalSupply(uint256 _value) public onlyAllowedAccess {\n        _totalSupply = _totalSupply.add(_value);\n    }\n\n    function subTotalSupply(uint256 _value) public onlyAllowedAccess {\n        _totalSupply = _totalSupply.sub(_value);\n    }\n\n    function setTotalSupply(uint256 _value) public onlyAllowedAccess {\n        _totalSupply = _value;\n    }\n\n    function getTotalSupply() public view onlyAllowedAccess returns(uint256) {\n        return(_totalSupply);\n    }\n\n\n    // Locking Storage\n    /**\n    * @dev Reasons why a user\u0027s tokens have been locked\n    */\n    mapping(address =\u003e bytes32[]) internal lockReason;\n\n    /**\n     * @dev locked token structure\n     */\n    struct lockToken {\n        uint256 amount;\n        uint256 validity;\n        bool claimed;\n    }\n\n    /**\n     * @dev Holds number \u0026 validity of tokens locked for a given reason for\n     *      a specified address\n     */\n    mapping(address =\u003e mapping(bytes32 =\u003e lockToken)) internal locked;\n\n\n    // Lock Access Functions\n    function getLockedTokenAmount(address _of, bytes32 _reason) public view onlyAllowedAccess returns (uint256 amount){\n        if (!locked[_of][_reason].claimed)\n            amount = locked[_of][_reason].amount;\n    }\n\n    function getLockedTokensAtTime(address _of, bytes32 _reason, uint256 _time) public view onlyAllowedAccess returns(uint256 amount){\n        if (locked[_of][_reason].validity \u003e _time)\n            amount = locked[_of][_reason].amount;\n    }\n\n    function getTotalLockedTokens(address _of) public view onlyAllowedAccess returns(uint256 amount){\n        for (uint256 i = 0; i \u003c lockReason[_of].length; i++) {\n            amount = amount.add(getLockedTokenAmount(_of, lockReason[_of][i]));\n        }\n    }\n\n    function extendTokenLock(address _of, bytes32 _reason, uint256 _time) public onlyAllowedAccess returns(uint256 amount, uint256 validity){\n\n        locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);\n        amount = locked[_of][_reason].amount;\n        validity = locked[_of][_reason].validity;\n    }\n\n    function increaseLockAmount(address _of, bytes32 _reason, uint256 _amount) public onlyAllowedAccess returns(uint256 amount, uint256 validity){\n        locked[_of][_reason].amount = locked[_of][_reason].amount.add(_amount);\n        amount = locked[_of][_reason].amount;\n        validity = locked[_of][_reason].validity;\n    }\n\n    function getUnlockable(address _of, bytes32 _reason) public view onlyAllowedAccess returns(uint256 amount){\n        if (locked[_of][_reason].validity \u003c= now \u0026\u0026 !locked[_of][_reason].claimed)\n            amount = locked[_of][_reason].amount;\n    }\n\n    function addLockedToken(address _of, bytes32 _reason, uint256 _amount, uint256 _validity) public onlyAllowedAccess {\n        locked[_of][_reason] = lockToken(_amount, _validity, false);\n    }\n\n    function addLockReason(address _of, bytes32 _reason) public onlyAllowedAccess {\n        lockReason[_of].push(_reason);\n    }\n\n    function getNumberOfLockReasons(address _of) public view onlyAllowedAccess returns(uint256 number){\n        number = lockReason[_of].length;\n    }\n\n    function getLockReason(address _of, uint256 _i) public view onlyAllowedAccess returns(bytes32 reason){\n        reason = lockReason[_of][_i];\n    }\n\n    function setClaimed(address _of, bytes32 _reason) public onlyAllowedAccess{\n        locked[_of][_reason].claimed = true;\n    }\n\n    function caller(address _of) public view  onlyAllowedAccess returns(uint){\n        return getTotalLockedTokens(_of);\n    }\n}"}}