// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChainVantage
 * @dev A decentralized platform for recording and verifying supply chain transactions.
 */
contract ChainVantage {
    struct Record {
        uint256 id;
        string productName;
        string location;
        address owner;
        uint256 timestamp;
    }

    uint256 private recordCounter;
    mapping(uint256 => Record) private records;

    event RecordCreated(uint256 id, string productName, string location, address indexed owner, uint256 timestamp);
    event OwnershipTransferred(uint256 id, address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Create a new record in the supply chain.
     * @param _productName Name of the product.
     * @param _location Current location of the product.
     */
    function createRecord(string memory _productName, string memory _location) public {
        recordCounter++;
        records[recordCounter] = Record(recordCounter, _productName, _location, msg.sender, block.timestamp);

        emit RecordCreated(recordCounter, _productName, _location, msg.sender, block.timestamp);
    }

    /**
     * @dev Transfer ownership of a record to a new address.
     * @param _id Record ID.
     * @param _newOwner Address of the new owner.
     */
    function transferOwnership(uint256 _id, address _newOwner) public {
        Record storage record = records[_id];
        require(record.owner == msg.sender, "Only owner can transfer");
        require(_newOwner != address(0), "Invalid new owner address");

        address previousOwner = record.owner;
        record.owner = _newOwner;

        emit OwnershipTransferred(_id, previousOwner, _newOwner);
    }

    /**
     * @dev Fetch details of a record.
     * @param _id Record ID.
     */
    function getRecord(uint256 _id) public view returns (Record memory) {
        require(_id > 0 && _id <= recordCounter, "Record does not exist");
        return records[_id];
    }
}
