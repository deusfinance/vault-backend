//Be name khoda

pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract TransferController{

	constructor() public{}
	
	function beforeTokenTransfer(address from, address to, uint256 value) public{
		require(from == address(0) || to == address(0) , 'TimeToken is not transferable');
	}
}

contract TimeToken is ERC20, AccessControl{

    using SafeMath for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
	bytes32 public constant CONFIG_ROLE = keccak256("CONFIG_ROLE");

	TransferController public transferController;

    constructor() public ERC20('Deus Time Token ', 'DTT') {
		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
		_setupRole(CONFIG_ROLE, msg.sender);

		transferController = new TransferController();
    }

	function setTransferController(address _transferController) public{
		require(hasRole(CONFIG_ROLE, msg.sender), "Caller is not a configer");
		transferController = TransferController(_transferController);
	}

    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _burn(from, amount);
    }

	function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        transferController.beforeTokenTransfer(from, to, value);
        super._beforeTokenTransfer(from, to, value);
    }

}

//Dar panah khoda
