pragma solidity ^0.4.22;
contract LEM{
    
    struct Character{
        Role role;
        string description;
    }
    
    mapping(address=>Character) public characters;
    mapping(bytes32=>Investigation) public investigatioPool;
    string[] public broadcastPool;
    
    struct Investigation{
        string des;//meatadata
        address sender;
        uint256 timestamp;
        //dead time
        State state;
        //state
        mapping(bytes32=>bytes32) kv;
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
    
    
    address public chairperson;
    
    function setCharacter(address a,Role role) public{
        require(
            msg.sender==chairperson,
            "Operation not permitted"
        );
        characters[a].role=role;
    }
    
    function register(string au,string aci,string date, string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("register");
    }//tx1
    //On receiving tx1
    function or1(){
        
    }
    function grant(string au,string aci,string date, string ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("grant");
    }//tx2
    
    //On receiving tx2
    function or2(){
        
    }
    function upload(string pii,string pi,string ci,string md,string hash1,string hash2,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("upload");
    }//tx3
    
    //On receiving tx3
    function or3(){
        
    }
    function access(string pij,string pi,string md,string pi2,string hash,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public returns(uint256){
        require(
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
