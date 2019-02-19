pragma solidity ^0.4.23;

import "github.com/ethereum/dapp-bin/library/stringUtils.sol";

contract MemberContract
{

	struct Member 
	{
	    uint id;
	    string email;
	    string password;
        address acctAddr;
        string acctKey;
        bool isActive;
	}
    
     mapping(string => Member) listMember;
     address[] private listAddress;
     uint listCount;
     
    // Register Account 
    function registerAccount(string _email, string _password, address _acctAddr,string _acctKey) public returns (bool isSuccess,string errMsg)
    {
        if(listMember[_email].isActive)
        {
            return (false, 'Account email already exists');
        }
        
        else
        {
            Member memory acct = Member(listCount, _email, _password, _acctAddr,_acctKey, true);
            listMember[_email] = acct;
            listAddress.push(_acctAddr);
            return (true,'');
        }
        
        listCount++;
    }
    
    //Maybe not needed
     function getAccountByEmail(string _email, string _password) public view returns(string Email,address AcctAddr,string AcctKey)
     {
        if(isEmailExist(_email, _password))
        {
            return (_email,listMember[_email].acctAddr,listMember[_email].acctKey);
        }
        
        else
        {
            address emptyAddr = address(0);
            return ('',emptyAddr,'');
        }
    }
    
    function isAccountValid(address _addr) public view returns(bool status) 
    {
        bool result = false;
        for(uint i = 0;i < listAddress.length;i++)
        {
            if(listAddress[i] == _addr)
            {
                result = true;
            }
        }
        return result;
    }
    
    // Check if Email exists on registered accounts
    function isEmailExist(string _email, string _password) private returns(bool isExists)
    {
        if(listMember[_email].isActive)
        {
        
          if(StringUtils.equal(listMember[_email].password, _password)){
              return true;
          }
          else
          {
            return false;    
          }
                
        }
        return false;
    }
    
	
    
}


contract FileContract is MemberContract
{
 
    struct File
	{
        uint id;
        string filehash;
        string filetitle;
        string filedescription;
        string backuphash;
        string date;
    }

   mapping(address => mapping(uint => File)) private mapfiles;
   mapping(address => uint) private FileCount;
   
   function AddFiles(uint _id, string _fileHash, string _filetitle , string _filedescription, string _backuphash, string _date)public returns(bool status) 
   {
       if(MemberContract.isAccountValid(msg.sender))
       {
           File memory tmpfile = File(_id, _fileHash,_filetitle,_filedescription, _backuphash, _date);
           FileCount[msg.sender]++;
           mapfiles[msg.sender][FileCount[msg.sender]] = tmpfile;
           return true;
       }
       else
       {
           return false;
       }
   }
   
   function GetFiles(uint _count) public view returns(uint id, string filehash, string filetitle, string filedescription, string backuphash, string date)
   {
       return (
           mapfiles[msg.sender][_count].id, 
           mapfiles[msg.sender][_count].filehash,
           mapfiles[msg.sender][_count].filetitle,
           mapfiles[msg.sender][_count].filedescription,
           mapfiles[msg.sender][_count].backuphash, 
           mapfiles[msg.sender][_count].date
           );
   }
   
   function GetCount() public view returns(uint count)
   {
         return FileCount[msg.sender];
   }
   
}