pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

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
        //states
    }
    
    struct RegisteStruct{
        string au;
        string aci;
        string date;
        string ts;
        bool processed;
        bytes32 hash;
    }
    
    struct UploadStruct{
        string pii;
        string pi;
        string ci;
        string md;
        string hash1;
        string hash2;
    }
    
    struct GrantStruct{
        string au;
        string aci;
        string date;
        string ts;
    }
    
    struct AccessStruct{
        string  pij;
        string  pi;
        string  md;
        string  pi2;
        string  hash;
    }
    
    struct PermitStruct{
        bytes32 iindex;
        string au;
        string pij;
        string date; 
        string ts;
    }
    
    struct AnalyzeStruct{
        bytes32 iindex;
        string au;
        string pij;
        string date;
        string ts;
    }
    
    
    struct ReportStruct{
        bytes32 iindex;
        string pij;
        string hash;
        string date;
        string ts;
    }
    
    struct CloseStruct{
        bytes32 iindex;
        string pij;
        string md;
        string date;
        string ts;
    }
    
    RegisteStruct[] public rl;
    UploadStruct[] public ul;
    GrantStruct[] public gl;
    AccessStruct[] public al;
    PermitStruct[] public pl;
    AnalyzeStruct[] public anl;
    ReportStruct[] public rel;
    CloseStruct[] public cl;
    
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
    
    // function register(string memory au,string memory aci,string memory date, string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
    //     require(
    //         ecrecover(msgh, v, r, s)==msg.sender,
    //         "Incorrect"
    //     );
    //     broadcastPool.push("register");
    //     strings.slice memory s = aci.toSlice();
    //     strings.slice memory delim = ".".toSlice();
    //     string[] memory parts = new string[](s.count(delim) + 1);
    //     for(uint i = 0; i < parts.length; i++) {
    //         parts[i] = s.split(delim).toString();
    //     }
        
    //     bytes32 h=keccak256( abi.encode(au,parts[0],parts[1],parts[2],parts[3]));//just for testing
    //     RegisteStruct memory rs=RegisteStruct(au,aci,date,ts,false,h);
    // }//tx1
    
    function register(string memory au,string memory aci,string memory date, string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("register");
        
        RegisteStruct memory rs=RegisteStruct(au,aci,date,ts,false,msgh);
        rl.push(rs);
    }//tx1
    
    
    
    
    
    //On receiving tx1
    
    
    
    function or1() public{
        
    }
    function grant(string memory au,string memory aci,string memory date, string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("grant");
        GrantStruct memory gs=GrantStruct(au,aci,date,ts);
        gl.push(gs);
    }//tx2
    
    //On receiving tx2
    function or2() public{
        
    }
    function upload(string memory pii,string memory pi,string memory ci,string memory md,string memory hash1,string memory hash2,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("upload");
        bytes32 h=keccak256( abi.encode(pii,pi,ci,md));
        UploadStruct memory us=UploadStruct(pii,pi,ci,md,hash1,hash2);
        ul.push(us);
    }//tx3
    
    //On receiving tx3
    function or3() public{
        
    }
    function access(string memory pij,string memory pi,string memory md,string memory pi2,string memory hash,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public returns(uint256){
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("access");
        Investigation memory i=Investigation("test",msg.sender,block.timestamp,State.WarrantRequest);
        investigatioPool[msgh]=i;
        AccessStruct memory aas=AccessStruct(pij,pi,md,pi2,hash);
        al.push(aas);
        emit access_e(msgh);
    }//tx4
    
    //On receiving tx4
    function or4() public{
        
    }
    function permit(bytes32 iindex,string memory au, string memory pij,string memory date , string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("permit");
        Investigation memory i=investigatioPool[iindex];
        i.state=State.DataRequest;
        investigatioPool[iindex]=i;
        PermitStruct memory ps=PermitStruct(iindex,au,pij,date,ts);
        pl.push(ps);
    }//tx5
    
    //On receiving tx5
    function or5() public{
        
    }
    function analyze(bytes32 iindex,string memory au, string memory pij,string memory date , string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("analyze");
        Investigation memory i=investigatioPool[iindex];
        i.state=State.DataAnalysis;
        investigatioPool[iindex]=i;
        AnalyzeStruct memory azs=AnalyzeStruct(iindex,au,pij,date,ts);
        anl.push(azs);
    }//tx6
    
    //On receiving tx6
    function or6() public{
        
    }
    function report(bytes32 iindex,string memory pij,string memory hash,string memory date,string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("report");
        Investigation memory i=investigatioPool[iindex];
        i.state=State.ResultReport;
        investigatioPool[iindex]=i;
        ReportStruct memory rs=ReportStruct(iindex,pij,hash,date,ts);
        rel.push(rs);
    }//tx7
    
    //On receiving tx7
    function or7() public{
        
    }
    function close(bytes32 iindex,string memory pij,string memory md,string memory date,string memory ts,bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public{
        require(
            ecrecover(msgh, v, r, s)==msg.sender,
            "Incorrect"
        );
        broadcastPool.push("close");
        Investigation memory i=investigatioPool[iindex];
        i.state=State.InvestigationClosure;
        investigatioPool[iindex]=i;
        CloseStruct memory cs=CloseStruct(iindex,pij,md,date,ts);
        cl.push(cs);
    }//tx8
    //On receiving tx8
    
    function or8() public{
        
    }
    
    event access_e(bytes32 msgh);
}
