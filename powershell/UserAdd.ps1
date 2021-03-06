#This powershell script add user to the Windows system. Its read the userlist from file

    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

        [Security.Principal.WindowsBuiltInRole] "Administrator"))

    {

        Write-Warning "You are not admin user on the system."

        Break

    }
    else
    {
        Write-Host "Enter the file name that contains userlist:"
        $fileloc = Read-Host #read file location
        if(Test-Path $fileloc) #test file exits or not
        {
           $info = Get-Content $fileloc #read file

            foreach ( $i in $info)#get users
            {
               $item = $i.Split(",")#split user and password using ',' comma
               $user= $item[0]
               $password= $item[1]
               
               if($password) #check provide a password or not And given information is correct format or not
               {
                   NET USER $user $password /ADD 2>&1> log.txt #create a temporary log file to grap results
                   $result = Get-Content log.txt #read log file
                   foreach ($j in $result)
                   {
                     
                        if($j.Contains("exists")) #check user is exits on the system or not
                       {
                            Write-Warning " $user Already exist in the system"
                            break
                       }
                       else
                       {
                            Write-Host "$user Successfully added to the system"
                            break
                       }
                       
                   }
               }
               else 
               {
                    Write-Warning "Provide password for $user. or check file contents format.Correct fromat is 'username,password' i.e 'kkk,45125'"
               }
              
               
            }
            Remove-Item log.txt #remove temporary log file
           
        }
        else
        {
            Write-Host "File not found!!!"
        }


}

  Read-Host "Press any key to continue.........."