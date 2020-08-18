pragma solidity ^0.4.22;
contract LEM{
    
    struct Character{
        Role role;
        string description;
    }

    mapping(address=>Character) public characters;
    mapping(bytes32=>Investigatio) public investigatioPool;
    mapping(bytes32=>Investigation) public investigatioPool;
    string[] public broadcastPool;

    struct Investigatio{
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

    struct Param{

    }

    enum State{
            WarrantRequest,
            InvestigationInitiate,
@@ -42,15 +37,9 @@ contract LEM{
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
@@ -59,118 +48,98 @@ contract LEM{
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
    function register(string au,string aci,string date, string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
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
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("register");
    }//tx1
    //On receiving tx1
    function or1(){

    }

    function storeKeyBlindPara(bytes32 hashreq,string keyBlindPara) public{
    function grant(string au,string aci,string date, string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
        warrentPool[hashreq].param.keyBlindPara=keyBlindPara;
    }
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("grant");
    }//tx2

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
    //On receiving tx2
    function or2(){

    }

    function collect(bytes32 hashreq,string dataDigest) public{
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
    function upload(string pii,string pi,string ci,string md,string hash1,string hash2,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            warrentPool[hashreq].param.sharesNum>=t+1,
            "Poor sharesNum"
            );
        warrentPool[hashreq].param.dataDigest=dataDigest;
        warrentPool[hashreq].state=State.DataAnalysis;
        broadcastPool.push("The investigator has collected the forensics data.");
    }
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("upload");
    }//tx3

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
    //On receiving tx3
    function or3(){

    }

    function complete(bytes32 hashreq,string) public{//from l and c
        require(
            characters[msg.sender].role==Role.l,
            "Invalid Character"
            );
    function access(string pij,string pi,string md,string pi2,string hash,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public returns(uint256){
        require(
            warrentPool[hashreq].state==State.ForensicsReport,
            "Incorrect state"
            );

        //verify mutilSignature
        warrentPool[hashreq].state=State.Completed;
        broadcastPool.push("The investigation has been accomplished");
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("access");
    }//tx4

    //On receiving tx4
    function or4(){

    }
    function permit(string au, string pij,string date , string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s){
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("permit");
    }//tx5

    function getBroadcast(uint32 index) public returns(string){
        return broadcastPool[index];
    //On receiving tx5
    function or5(){

    }
    function analyze(string au, string pij,string date , string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s){
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("analyze");
    }//tx6

    function hashCompareInternal(string a, string b) internal returns (bool) {
        return keccak256(a) == keccak256(b);
    //On receiving tx6
    function or6(){

    }
    function report(string pij,string hash,string date,string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s){
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("report");
    }//tx7

    function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);

    //On receiving tx7
    function or7(){

    }
    function close(string pij,string md,string date,string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s){
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("close");
    }//tx8
    //On receiving tx8
    function or8(){

    }
}
