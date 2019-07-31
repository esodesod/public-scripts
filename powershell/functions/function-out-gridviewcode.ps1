# See https://www.dowst.dev/out-gridview-for-vs-code/
Function Out-GridViewCode{
<#    
.SYNOPSIS
    Sends output to an interactive table in a separate window. With extended support to display Out-GridView as main window when using VS Code
    
.DESCRIPTION
    The Out-GridView cmdlet sends the output from a command to a grid view window where the output is displayed in an interactive table. However, when you use VS Code the window appears in the background. Running this wrapper will bring the window to the front. 
	
	Parameters remain the same as the orginal Out-GridView
    
.PARAMETER InputObject
        Accepts input for Out-GridView.
            
.PARAMETER Title 
        Specifies the text that appears in the title bar of the Out-GridView window.
        
.PARAMETER OutputMode 
        Send items from the interactive window down the pipeline as input to other commands. By default, this cmdlet does not generate any output. To send items from the interactive window down the pipeline, click to select the items and then click OK.
		
.PARAMETER PassThru
        Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands. By default, this cmdlet does not generate any output. This parameter is equivalent to using the Multiple value of the OutputMode parameter.
        
.PARAMETER Wait
        Indicates that the cmdlet suppresses the command prompt and prevents Windows PowerShell from closing until the Out-GridView window is closed. By default, the command prompt returns when the Out-GridView window opens.
#>
    [CmdletBinding(DefaultParameterSetName = 'PassThru')]
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [PSObject[]]$InputObject,
        
        [Parameter(Mandatory=$false)]
        [string]$Title,

        [Parameter(ParameterSetName = "Wait")]
        [switch]$Wait,
        
        [Parameter(ParameterSetName = "OutputMode")]
        [Microsoft.PowerShell.Commands.OutputModeOption]$OutputMode,
        
        [Parameter(ParameterSetName = "PassThru")]
        [switch]$PassThru
    )
    Begin{
        # Create output list object
        [System.Collections.Generic.List[PSObject]] $OutputObject = @()

        # Load windows control and get VS Code process infomation
        $sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
        Add-Type -MemberDefinition $sig -name NativeMethods -namespace Win32
        $processes = Get-Process -Name Code,powershell

        # Build parameter object to splat later on
        $GridViewParams = @{}
        $PSBoundParameters.GetEnumerator() | Where-Object {$_.Key -ne 'InputObject'} | ForEach-Object{
            $GridViewParams.Add($_.Key,$_.Value)
        }
    }
    Process{
        # Load each item to the Output object. This is done to handle pipeline values
        $InputObject | ForEach-Object{ $OutputObject.Add($_) }
    }
    End{
        # if wait or passthru minimize VS Code window
        # since the process does not release we go ahead and minimize
        # VS code so the grid windows appears
        if($Wait -or $PassThru){
            foreach($proc in $processes){
                $hwnd = @($proc)[0].MainWindowHandle
                [Win32.NativeMethods]::ShowWindowAsync($hwnd, 2) | Out-Null
            }
        } 
        
        # display out-gridview
        $OutputObject | Out-GridView @GridViewParams

        # if wait or passthru restore VS Code window
        # else bring grid to the front
        if($Wait -or $PassThru){
            foreach($proc in $processes){
                $hwnd = @($proc)[0].MainWindowHandle
                [Win32.NativeMethods]::ShowWindowAsync($hwnd, 3) | Out-Null
            }
        } else {
            Get-Process -Name powershell | Where-Object {$_.MainWindowTitle.Trim() -eq '$OutputObject | Out-GridView @GridViewParams' -or
                $_.MainWindowTitle.Trim() -eq $title} | ForEach-Object{
                    $hwnd = @($_)[0].MainWindowHandle
                    [Win32.NativeMethods]::ShowWindowAsync($hwnd, 2) | Out-Null
                    [Win32.NativeMethods]::ShowWindowAsync($hwnd, 10) | Out-Null
                }
        }
    } 
}