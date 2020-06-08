pragma solidity ^0.4.22;
contract VDF{
    
    struct Character{
        Role role;
        string description;
    }
    
    mapping(address=>Character) public characters;
    mapping(bytes32=>Investigatio) public investigatioPool;
    string[] public broadcastPool;
    
    struct Investigatio{
        string des;//meatadata
        address sender;
        uint256 timestamp;
        //dead time
        State state;
        //state
        Param param;
    }
    
    struct Param{

    }
    
    enum State{
            WarrantRequest,
            InvestigationInitiate,
            DataRequest,
            DataRetrieval,
            DataAnalysis,
            ResultReport,
            InvestigationClosure,
            Completed
    }
    
    enum Role{
        l,//Law Enforcement
        c,//Court 
        v,//Vehicle
        a//Authority
    }
    
    uint32 t;
    
    address public chairperson;
    
    constructor() public{
        chairperson=msg.sender;
        t=10;
    }
    
    function setCharacter(address a,Role role) public{
        require(
            msg.sender==chairperson,
            "Operation not permitted"
        );
        characters[a].role=role;
    }
    
    function requestWarrant(string des,bytes32 hashreq,string timestamp) public{
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
        Param memory _param=Param(0,"0","0","0","0","0");
        Warrant memory _warrant=Warrant(des,msg.sender,now,State.WarrantRequest,_param);//init
        warrentPool[hashreq]=_warrant;
        broadcastPool.push("An investigation request has been created.");
    }//TX2 by l
    
    function handleWarrant(bool permit,bytes32 hashreq,string keyPara) public{
        require(
            characters[msg.sender].role==Role.c,
            "Invalid Character"
            );
        if(permit){
            //parse keyPara
            warrentPool[hashreq].param.keyPara=keyPara;
            warrentPool[hashreq].state=State.WarrantAuthorization;
            broadcastPool.push("An investigation has been permitted by the court.");
        }
        else{
            warrentPool[hashreq].state=State.Completed;
            broadcastPool.push("An investigation has been rejected by the court.");
        }
    }
    
    function storeKeyBlindPara(bytes32 hashreq,string keyBlindPara) public{
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
        warrentPool[hashreq].param.keyBlindPara=keyBlindPara;
    }
    
    function retrive(bytes32 hashreq,string sharesPara) public{
        require(
            characters[msg.sender].role==Role.a,
            "Invalid Character"
            );
        warrentPool[hashreq].param.sharesNum+=1;
        warrentPool[hashreq].param.sharesPara=sharesPara;
        if(warrentPool[hashreq].param.sharesNum>=t+1){
            warrentPool[hashreq].state=State.DataCollection;
            broadcastPool.push("The investigator collects enough shares.");
        }
        else{
            broadcastPool.push("The Aj submits the decryption key shares.");
        }
    }
    
    function collect(bytes32 hashreq,string dataDigest) public{
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
        require(
            warrentPool[hashreq].param.sharesNum>=t+1,
            "Poor sharesNum"
            );
        warrentPool[hashreq].param.dataDigest=dataDigest;
        warrentPool[hashreq].state=State.DataAnalysis;
        broadcastPool.push("The investigator has collected the forensics data.");
    }
    
    function report(bytes32 hashreq,string hreport) public{
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
        require(
            warrentPool[hashreq].state==State.DataAnalysis,
            "Incorrect state"
            );
        warrentPool[hashreq].param.report=hreport;
        warrentPool[hashreq].state=State.ForensicsReport;
        broadcastPool.push("The investigator starts to examine the forensics data.");
    }
    
    function complete(bytes32 hashreq,string) public{//from l and c
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
        require(
            warrentPool[hashreq].state==State.ForensicsReport,
            "Incorrect state"
            );
            
        //verify mutilSignature
        warrentPool[hashreq].state=State.Completed;
        broadcastPool.push("The investigation has been accomplished");
    }
    
    function getBroadcast(uint32 index) public returns(string){
        return broadcastPool[index];
    }
    
    function hashCompareInternal(string a, string b) internal returns (bool) {
        return keccak256(a) == keccak256(b);
    }
    
    function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);

    }
}