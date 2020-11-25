pragma solidity >=0.4.22 <0.7.0;

contract LEM{
    enum Role{
        pi,//police investigator
        node,//blockchain node 
        pd,//police department
        sa,//crime scene analyst
        jr,//juror
        jg//juror
    }
    
    struct Investigation{
        string des;//meatadata
        address sender;
        uint256 timestamp;
        //dead time
        State state;
        //state
        Param param;
        mapping(bytes32=>bytes32) kv;
    }

    
    struct CollectionRequest{
        string pi;
        uint256 timestamp;
        bytes32 data_hash;
        string download_link;
    }
    
    address initializer;
    mapping(address=>Role) public roles;
    mapping(bytes32=>CollectionRequest) public CollectionRequestPool;
    mapping(bytes32=>Investigation) public investigatioPool;
    string[] public broadcastPool;
    
        
    enum CurrentState{
        Collection,
        Upload,
        Reject_Upload,
        Store,
        Access,
        Vote,
        Complete
    }
    CurrentState currentstate;
    
    constructor() public{
        initializer=msg.sender;
    }
    
    function setChars(address[] memory pil,address[] memory nodel,address[] memory pdl,address[] memory sal,address[] memory jrl,address[] memory jgl) public{
        require(
            msg.sender==initializer,
            "Illegal"
            );
        for(uint pii = 0; pii <pil.length ; pii++) {
            roles[pil[pii]]=Role.pi;
        }
        for(uint nodei = 0; nodei <nodel.length ; nodei++) {
            roles[nodel[nodei]]=Role.node;
        }
        for(uint pdi = 0; pdi <pdl.length ; pdi++) {
            roles[pdl[pdi]]=Role.pd;
        }
        for(uint sai = 0; sai <sal.length ; sai++) {
            roles[sal[sai]]=Role.sa;
       }
       for(uint jri = 0; jri <jrl.length ; jri++) {
            roles[jrl[jri]]=Role.jr;
       }
       for(uint jgi = 0; jgi <jgl.length ; jgi++) {
            roles[jgl[jgi]]=Role.jg;
       }
    }
    
    
    function orRequest(string memory pi,uint256 ts,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.pi,
            "Illegal"
        );
        currentstate=CurrentState.Collection;
        bytes32 hpi=keccak256(abi.encodePacked(pi,ts));
        CollectionRequest memory cr=CollectionRequest(pi,ts,"","");
        CollectionRequestPool[hpi]=cr;
        broadcastPool.push("A collection request has been created.");
    }
    
    function orUpload(string memory pi,string memory R_omega,bytes32 hash_c_omega,uint256 tspi,string memory rho,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.pi,
            "Illegal"
        );
        currentstate=CurrentState.Upload;
        bytes32 hpi=keccak256(abi.encodePacked(pi,tspi));
        CollectionRequest memory cr=CollectionRequest(pi,tspi,hash_c_omega,"");
        CollectionRequestPool[hpi]=cr;
        broadcastPool.push("New evidence have been collected by a police investigator.");
        
    }
    
    function orRejectUpload(bytes32 hash_index,bytes32 sig,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{//called by the node
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.node,
            "Illegal"
        );
        currentstate=CurrentState.Reject_Upload;
        delete CollectionRequestPool[hash_index];
        broadcastPool.push("The upload has been rejected by a blockchain node.");
    }
    
    function orStore(bytes32 hash_index,bytes32 hash_c_omega,uint256 tspd,bytes32 sig,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.pd,
            "Illegal"
        );
        currentstate=CurrentState.Store;
        CollectionRequestPool[hash_index].download_link=byte32UintToString(hash_c_omega,tspd);
        broadcastPool.push("New evidence have been stored.");
    }
    
    function orAccess(string memory sa,string memory cisa,uint256 tssa,string memory rho_sa,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.sa,
            "Illegal"
        );
        currentstate=CurrentState.Access;
        broadcastPool.push("An access has been granted.");
    }
    
    
    function orVote(string memory v1d,string memory v2d,string memory v3d,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.jr,
            "Illegal"
        );
        currentstate=CurrentState.Vote;
        broadcastPool.push("A vote has been submitted.");
    }
    
    function orComplete(string memory vfinal,bytes32 sig,bytes32 msgh,uint8 v,bytes32 r,bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        require(
            roles[msg.sender]==Role.jg,
            "Illegal"
        );
        currentstate=CurrentState.Complete;
        broadcastPool.push("A trial result has been achieved.");
    }
    
    
    function byte32UintToString(bytes32 b,uint256 num)private returns (string memory) {
       
       bytes memory nb = new bytes(32);
       assembly { mstore(add(nb, 32), num) }
       
       bytes memory names = new bytes(b.length+nb.length);
       
       for(uint i = 0; i < b.length; i++) {
           
           names[i] = b[i];
       }
       for(uint j=0;j<nb.length;j++){
           names[j+b.length]=nb[j];
       }
       return string(names);
   }
}
