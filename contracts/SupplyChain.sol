// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract supplyChain {
    uint32 public product_id = 0;
    uint32 public participant_id = 0;
    uint32 public owner_id = 0;

    struct product {
        address ownerAddress;
        string modelNumber;
        string partNumber;
        string serialNumber;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping(uint32 => product) public products;

    struct participant {
        string userName;
        string passWord;
        string participantType;
        address participantAddress;
    }

    mapping(uint32 => participant) public participants;

    struct ownership {
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address ownerAddress;
    }

    mapping(uint32 => ownership) public ownerships;
    mapping(uint32 => uint32[]) public productTrack;

    event TransferOwnership(uint32 productId);

    function addParticipant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public returns (uint32) {
        uint32 userId = participant_id++;
        participants[userId].userName = _name;
        participants[userId].passWord = _pass;
        participants[userId].participantAddress = _pAdd;
        participants[userId].participantType = _pType;

        return userId;
    }

    function getParticipant(uint32 _participant_id)
        public
        view
        returns (
            string memory,
            address,
            string memory
        )
    {
        return (
            participants[_participant_id].userName,
            participants[_participant_id].participantAddress,
            participants[_participant_id].participantType
        );
    }

    function addProduct(
        uint32 _ownerId,
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost
    ) public returns (uint32) {
        if (
            keccak256(
                abi.encodePacked(participants[_ownerId].participantType)
            ) == keccak256("Manufacturer")
        ) {
            uint32 productId = product_id++;

            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].ownerAddress = participants[_ownerId]
                .participantAddress;
            products[productId].mfgTimeStamp = uint32(block.timestamp);

            return productId;
        }
        return 0;
    }

    modifier onlyOwner(uint32 _productId) {
        require(msg.sender == products[_productId].ownerAddress, "");
        _;
    }

    function getProduct(uint32 _productId)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint32,
            address,
            uint32
        )
    {
        return (
            products[_productId].modelNumber,
            products[_productId].partNumber,
            products[_productId].serialNumber,
            products[_productId].cost,
            products[_productId].ownerAddress,
            products[_productId].mfgTimeStamp
        );
    }

    function newOwner(
        uint32 _currentUId,
        uint32 _nextUId,
        uint32 _productId
    ) public onlyOwner(_productId) returns (bool) {
        participant memory currentP = participants[_currentUId];
        participant memory nextP = participants[_nextUId];
        uint32 ownership_id = owner_id++;

        if (
            keccak256(abi.encodePacked(currentP.participantType)) ==
            keccak256("Manufacturer") &&
            keccak256(abi.encodePacked(nextP.participantType)) ==
            keccak256("Supplier")
        ) {
            ownerships[ownership_id].productId = _productId;
            ownerships[ownership_id].ownerAddress = nextP.participantAddress;
            ownerships[ownership_id].ownerId = _nextUId;
            ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);

            products[_productId].ownerAddress = nextP.participantAddress;
            productTrack[_productId].push(ownership_id);

            emit TransferOwnership(_productId);
            return (true);
        } else if (
            keccak256(abi.encodePacked(currentP.participantType)) ==
            keccak256("Supplier") &&
            keccak256(abi.encodePacked(nextP.participantType)) ==
            keccak256("Supplier")
        ) {
            ownerships[ownership_id].productId = _productId;
            ownerships[ownership_id].ownerAddress = nextP.participantAddress;
            ownerships[ownership_id].ownerId = _nextUId;
            ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);

            products[_productId].ownerAddress = nextP.participantAddress;
            productTrack[_productId].push(ownership_id);

            emit TransferOwnership(_productId);
            return (true);
        } else if (
            keccak256(abi.encodePacked(currentP.participantType)) ==
            keccak256("Supplier") &&
            keccak256(abi.encodePacked(nextP.participantType)) ==
            keccak256("Customer")
        ) {
            ownerships[ownership_id].productId = _productId;
            ownerships[ownership_id].ownerAddress = nextP.participantAddress;
            ownerships[ownership_id].ownerId = _nextUId;
            ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);

            products[_productId].ownerAddress = nextP.participantAddress;
            productTrack[_productId].push(ownership_id);

            emit TransferOwnership(_productId);
            return (true);
        }
        return (false);
    }

    function getProvenance(uint32 _productId)
        external
        view
        returns (uint32[] memory)
    {
        return productTrack[_productId];
    }

    function getOwnership(uint32 _regId)
        public
        view
        returns (
            uint32,
            uint32,
            uint32,
            address
        )
    {
        ownership memory r = ownerships[_regId];
        return (r.productId, r.ownerId, r.trxTimeStamp, r.ownerAddress);
    }

    function authenticateParticipant(
        uint32 _uid,
        string memory _uname,
        string memory _pass,
        string memory _utype
    ) public view returns (bool) {
        if (
            keccak256(abi.encodePacked(participants[_uid].participantType)) ==
            keccak256(abi.encodePacked(_utype))
        ) {
            if (
                keccak256(abi.encodePacked(participants[_uid].userName)) ==
                keccak256(abi.encodePacked(_uname))
            ) {
                if (
                    keccak256(abi.encodePacked(participants[_uid].passWord)) ==
                    keccak256(abi.encodePacked(_pass))
                ) {
                    return (true);
                }
            }
        }

        return (false);
    }
}
