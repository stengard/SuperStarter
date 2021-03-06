#The sample scripts are not supported under any Microsoft standard support 
#program or service. The sample scripts are provided AS IS without warranty  
#of any kind. Microsoft further disclaims all implied warranties including,  
#without limitation, any implied warranties of merchantability or of fitness for 
#a particular purpose. The entire risk arising out of the use or performance of  
#the sample scripts and documentation remains with you. In no event shall 
#Microsoft, its authors, or anyone else involved in the creation, production, or 
#delivery of the scripts be liable for any damages whatsoever (including, 
#without limitation, damages for loss of business profits, business interruption, 
#loss of business information, or other pecuniary loss) arising out of the use 
#of or inability to use the sample scripts or documentation, even if Microsoft 
#has been advised of the possibility of such damages.

Function CreateVirtualDesktopInWin10
{
    $KeyShortcut = Add-Type -MemberDefinition @"
    [DllImport("user32.dll")]
    static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    //WIN + CTRL + D: Create a new desktop
    public static void CreateVirtualDesktopInWin10()
    {
        //Key down
        keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
        keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
        keybd_event((byte)0x44, 0, 0, UIntPtr.Zero); //D
        //Key up
        keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
        keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
        keybd_event((byte)0x44, 0, (uint)0x2, UIntPtr.Zero);
    }
"@ -Name CreateVirtualDesktop -UsingNamespace System.Threading -PassThru
    $KeyShortcut::CreateVirtualDesktopInWin10()
}


